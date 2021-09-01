import 'dart:async';

import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OStartEngine.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';

class DataTransferManager {
  DataTransferManager._();

  static DataTransferManager instance = DataTransferManager._();

  late String currentEntryName;

  late BaseDataTransfer currentDataTransfer;

  /// [currentEntryName] 必须比 [currentDataTransfer] 更先进行初始化，
  /// 因为 [currentDataTransfer] 需要 [currentEntryName]。
  ///
  /// [dataTransfer] 不能用对象传入，而必须用函数传入。
  /// 因为如果用对象传入，则会导致执行 [binding] 前 [BaseDataTransfer] 会先被构造，这时 [currentEntryName] 还并未初始化过，从而导致程序出错。
  void binding(String entryName, BaseDataTransfer dataTransfer()) {
    currentEntryName = entryName;
    currentDataTransfer = dataTransfer();
  }

  /// 成功的返回结果只能 true，其他全为失败。
  ///
  /// 如果 [operationIdIfEngineFirstFrameInitialized] 为空，则 [R] 必须为 [bool]。
  Future<MessageResult<R>> pushToEngine<S, R extends Object>({
    required String startWhichEngine,
    required bool isOpenView,
    required String? operationIdIfEngineFirstFrameInitialized,
    required S data,
  }) async {
    final MessageResult<R> pushResult = MessageResult<R>(resultData: null, exception: Exception('未对初始 pushResult 进行更改！'), stackTrace: null);

    // 检测是否已启动引擎，如果未启动，则启动。
    final MessageResult<bool> messageResult = await currentDataTransfer.sendMessageToOtherEngine<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.native,
      operationId: OStartEngine.START_ENGINE,
      data: <String, Object?>{
        'start_which_engine': startWhichEngine,
        'is_start_view': isOpenView,
      },
    );

    // 引擎已启动或已触发启动引擎，则返回 true。
    await messageResult.handle(
      (bool data) async {
        if (data) {
          final bool isInitialized = await _isPushedEngineFirstFrameInitialized(isStartView: isOpenView);
          if (isInitialized) {
            if (operationIdIfEngineFirstFrameInitialized == null) {
              // 到这里 仅 说明 startEngine 成功（含是否 open view）。
              pushResult.setAll(resultData: true as R?, exception: null, stackTrace: null);
            } else {
              (await currentDataTransfer.sendMessageToOtherEngine(
                sendToWhichEngine: startWhichEngine,
                operationId: operationIdIfEngineFirstFrameInitialized!,
                data: data,
              ))
                  .cloneTo(pushResult);
            }
          } else {
            throw Exception('第一帧初始化失败！');
          }
        } else {
          throw Exception('data 不为 true!');
        }
      },
      (Object? exception, StackTrace? stackTrace) async {
        pushResult.setAll(resultData: null, exception: exception, stackTrace: stackTrace);
      },
    );
    return pushResult;
  }

  // 检查对应引擎的第一帧是否已被初始化完成。
  Future<bool> _isPushedEngineFirstFrameInitialized({required bool isStartView}) async {
    bool isDone = false;

    final Future<void> Function() send = () async {
      // 响应是否已被初始化完成。
      final MessageResult<bool> messageResult = await currentDataTransfer.sendMessageToOtherEngine<bool, bool>(
        sendToWhichEngine: EngineEntryName.native,
        operationId: OStartEngine.IS_FIRST_FRAME_INITIALIZED,
        data: isStartView,
      );

      await messageResult.handle(
        (bool data) async {
          isDone = data;
        },
        (Object? exception, StackTrace? stackTrace) async {
          throw Exception(exception);
        },
      );
    };

    // 每0.5s检测一次。
    const Duration delayed = Duration(milliseconds: 500);
    for (int i = 0; i < 20; i++) {
      await send();
      if (isDone) {
        return true;
      } else {
        await Future<void>.delayed(delayed);
      }
    }
    return false;
  }
}
