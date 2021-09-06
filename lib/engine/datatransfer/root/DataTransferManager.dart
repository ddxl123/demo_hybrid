import 'dart:async';

import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OExecute.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DataTransferManager.g.dart';

@JsonSerializable()
class ViewParams {
  ViewParams({
    required this.width,
    required this.height,
    required this.x,
    required this.y,
    required this.alpha,
  });

  factory ViewParams.fromJson(Map<String, Object?> json) => _$ViewParamsFromJson(json);

  Map<String, Object?> toJson() => _$ViewParamsToJson(this);

  final int width;
  final int height;
  final int x;
  final int y;
  final double alpha;
}

class DataTransferManager {
  DataTransferManager._();

  static DataTransferManager instance = DataTransferManager._();

  late String currentEntryPointName;

  late BaseDataTransfer currentDataTransfer;

  /// [currentEntryPointName] 必须比 [currentDataTransfer] 更先进行初始化，
  /// 因为 [currentDataTransfer] 需要 [currentEntryPointName]。
  ///
  /// [dataTransfer] 不能用对象传入，而必须用函数传入。
  /// 因为如果用对象传入，则会导致执行 [binding] 前 [BaseDataTransfer] 会先被构造，这时 [currentEntryPointName] 还并未初始化过，从而导致程序出错。
  void binding(String entryName, BaseDataTransfer dataTransfer()) {
    currentEntryPointName = entryName;
    currentDataTransfer = dataTransfer();
  }

  /// 向其他 flutter 引擎发消息，并接收返回值。
  ///
  /// [S] 发送的数据类型。 using the Flutter standard binary encoding.
  ///
  /// [R] 返回的正确数据类型。 using the Flutter standard binary encoding.
  ///
  /// [sendToWhichEngine] 发送消息到哪个引擎上。
  ///   - 固定：[EngineEntryName.MAIN] -> main 引擎，[EngineEntryName.NATIVE] -> 仅原生。
  ///
  /// [operationId] 操作的唯一标识。
  ///
  /// [data] 发送的附带数据。
  ///
  Future<MessageResult<R>> _sendMessageToOtherEngine<S, R extends Object>({
    required String sendToWhichEngine,
    required String operationId,
    required S data,
  }) async {
    R? result;
    Object? exception;
    StackTrace? stackTrace;

    try {
      final Map<String, Object?> messageMap = <String, Object?>{
        'send_to_which_engine': sendToWhichEngine,
        'operation_id': operationId,
        'data': data,
      };
      final Object? resultObj = await currentDataTransfer.basicMessageChannel.send(messageMap);
      if (resultObj == null) {
        throw Exception('''
                
        来自原生的响应数据为 null！
        可能的原因如下：
          1. 消息通道异常。--- 直接返回了 null，而未抛出如何异常，没有错误 log 输出
          2. 原生发生了异常：
            1) 未发现引擎 sendToWhichEngine: $sendToWhichEngine。
            2) 未对 operationId: $operationId 进行处理。
          3. 接收者发生了异常
            1) listenerMessageFormOtherFlutterEngine 内部异常！
            2) 未对 operationId: $operationId 进行处理。
        ''');
      } else {
        result = resultObj as R;
        return MessageResult<R>(resultData: result, exception: null, stackTrace: null);
      }
    } catch (e, st) {
      exception = e;
      stackTrace = st;
      return MessageResult<R>(resultData: null, exception: exception, stackTrace: stackTrace);
    }
  }

  /// 检查对应引擎的第一帧是否已被初始化完成。
  Future<bool> _isPushedEngineFirstFrameInitialized() async {
    bool isDone = false;

    final Future<void> Function() send = () async {
      final MessageResult<bool> messageResult = await _sendMessageToOtherEngine<void, bool>(
        sendToWhichEngine: EngineEntryName.NATIVE,
        operationId: OExecute_FlutterSend.IS_FIRST_FRAME_INITIALIZED,
        data: null,
      );

      await messageResult.handle(
        // 返回 true 已被初始化完成，返回 false 未被初始化完成。
        onSuccess: (bool data) async {
          isDone = data;
        },
        onError: (Object? exception, StackTrace? stackTrace) async {
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

  Future<void> _handleViewAndOperation<S, R extends Object>({
    required MessageResult<R> executeResult,
    required String executeForWhichEngine,
    required String? operationIdIfEngineFirstFrameInitialized,
    required S operationData,
    required ViewParams? startViewParams,
    required ViewParams? endViewParams,
    required int? closeViewAfterSeconds,
  }) async {
    final MessageResult<bool> viewResult = await _sendMessageToOtherEngine<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OExecute_FlutterSend.SET_VIEW,
      data: <String, Object?>{
        'set_which_engine_view': executeForWhichEngine,
        'start_view_params': startViewParams?.toJson(),
        'end_view_params': endViewParams?.toJson(),
        'close_view_after_seconds': closeViewAfterSeconds,
      },
    );
    await viewResult.handle(
      onSuccess: (bool data) async {
        // view set 完成。
        if (data) {
          if (operationIdIfEngineFirstFrameInitialized != null) {
            final MessageResult<R> operationResult = await _sendMessageToOtherEngine<S, R>(
              sendToWhichEngine: executeForWhichEngine,
              operationId: operationIdIfEngineFirstFrameInitialized,
              data: operationData,
            );
            operationResult.cloneTo(executeResult);
          } else {
            executeResult.setAll(resultData: true as R, exception: null, stackTrace: null);
          }
        } else {
          throw Exception('data 不为 true！');
        }
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        executeResult.setAll(resultData: null, exception: exception, stackTrace: stackTrace);
      },
    );
  }

  /// 在当前引擎中对其他引擎进行 operation。
  ///
  /// 若未启动引擎，则先启动引擎。
  ///
  /// 关于 [executeForWhichEngine]：
  ///
  ///   > - 要对哪个引擎进行操作。
  ///
  ///   > - 若为 [EngineEntryName.MAIN]，则 [startViewParams]、[endViewParams]、[closeViewAfterSeconds] 变得没有意义。
  ///
  ///   > - 若为 [EngineEntryName.NATIVE]，则使用 [executeToNative] 代替。
  ///
  /// 关于 [operationIdIfEngineFirstFrameInitialized]：
  ///
  ///   > - 若引擎已启动或已触发启动，且其引擎第一帧被执行完成时，需要进行的 operation 操作。
  ///
  ///   > - 若 [operationIdIfEngineFirstFrameInitialized] 为空，即不传递 operation，则 [R] 必须为 [bool] 类型。
  ///
  /// 关于 [operationData]：
  ///
  ///   > - 当 [operationIdIfEngineFirstFrameInitialized] 不为空时要传递的数据。
  ///
  /// 关于 [startViewParams]：
  ///
  ///   > - 从 [startViewParams] 配置过渡到 [endViewParams] 配置。
  ///
  ///   > - 当 [startViewParams] 为空，[endViewParams] 不为空时，表示从上一次配置过渡到 [endViewParams] 配置。
  ///
  ///   > - 当 [startViewParams] 不为空，[endViewParams] 为空时，表示从 [startViewParams] 配置过渡到上一次配置。
  ///
  ///   > - 当 [startViewParams] 为空，[endViewParams] 为空时，表示保持上一次配置不变。
  ///
  /// 关于 [closeViewAfterSeconds]：
  ///
  ///   > - 一旦 [startViewParams]，多少秒后关闭 view。
  ///
  ///   > - 为空或为负数时，保持现状不关闭。
  ///
  Future<MessageResult<R>> execute<S, R extends Object>({
    required String executeForWhichEngine,
    required String? operationIdIfEngineFirstFrameInitialized,
    required S operationData,
    required ViewParams? startViewParams,
    required ViewParams? endViewParams,
    required int? closeViewAfterSeconds,
  }) async {
    final MessageResult<R> executeResult = MessageResult<R>(resultData: null, exception: Exception('未对初始 executeResult 进行更改！'), stackTrace: null);

    if (executeForWhichEngine == EngineEntryName.NATIVE || executeForWhichEngine == EngineEntryName.MAIN) {
      return executeResult.setAll(
        resultData: null,
        exception: Exception('executeForWhichEngine 不能为 ${EngineEntryName.NATIVE} 或 ${EngineEntryName.MAIN}！'),
        stackTrace: null,
      );
    }

    // 检测是否已启动引擎，若未启动，则启动。
    final MessageResult<bool> messageResult = await _sendMessageToOtherEngine<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OExecute_FlutterSend.START_ENGINE,
      data: <String, Object?>{'start_which_engine': executeForWhichEngine},
    );

    await messageResult.handle(
      // 引擎已启动或已触发启动引擎，则得到 true。
      onSuccess: (bool data) async {
        if (data) {
          final bool isInitialized = await _isPushedEngineFirstFrameInitialized();
          if (isInitialized) {
            await _handleViewAndOperation(
              executeResult: executeResult,
              executeForWhichEngine: executeForWhichEngine,
              operationIdIfEngineFirstFrameInitialized: operationIdIfEngineFirstFrameInitialized,
              operationData: operationData,
              startViewParams: startViewParams,
              endViewParams: endViewParams,
              closeViewAfterSeconds: closeViewAfterSeconds,
            );
          } else {
            throw Exception('启动引擎后的第一帧初始化失败！');
          }
        } else {
          throw Exception('启动引擎时响应的 data 不为 true!');
        }
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        executeResult.setAll(resultData: null, exception: exception, stackTrace: stackTrace);
      },
    );
    return executeResult;
  }

  Future<MessageResult<R>> executeToNative<S, R extends Object>({required String operationId, required S data}) async {
    return await _sendMessageToOtherEngine<S, R>(sendToWhichEngine: EngineEntryName.NATIVE, operationId: operationId, data: data);
  }

  Future<MessageResult<R>> executeToMain<S, R extends Object>({required String operationId, required S data}) async {
    return await _sendMessageToOtherEngine<S, R>(sendToWhichEngine: EngineEntryName.MAIN, operationId: operationId, data: data);
  }

  Future<void> executeSqliteCurd() async {}

  Future<void> executeSqlite() async {}
}
