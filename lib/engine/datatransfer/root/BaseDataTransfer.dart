import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class MessageResult<R extends Object> {
  MessageResult({required this.resultData, required this.exception, required this.stackTrace});

  /// 响应的数据。
  R? resultData;
  Object? exception;
  StackTrace? stackTrace;

  /// 是否存在异常。
  bool get _hasErr => exception != null;

  /// 一次性设置全部。
  void setAll({required R? resultData, required Object? exception, required StackTrace? stackTrace}) {
    this.resultData = resultData;
    this.exception = exception;
    this.stackTrace = stackTrace;
  }

  /// 将当前对象克隆到指定对象上。
  void cloneTo(MessageResult<R> otherMessageResult) {
    otherMessageResult.setAll(resultData: resultData, exception: exception, stackTrace: stackTrace);
  }

  /// 已对 [onSuccess] 内部进行异常捕获，若捕获到异常，则会转发给 [onError]。
  Future<void> handle(Future<void> onSuccess(R data), Future<void> onError(Object? exception, StackTrace? stackTrace)) async {
    if (!_hasErr) {
      try {
        // 成功时，data 不能为 null。
        await onSuccess(resultData!);
      } catch (e, st) {
        await onError(e, st);
      }
    } else {
      await onError(exception, stackTrace);
    }
  }
}

/// 需在引擎入口执行前创建该 [BaseDataTransfer] 实例，之后使用 [DataTransferManager.instance] 对该实例进行操作。
abstract class BaseDataTransfer {
  BaseDataTransfer() {
    _listenerMessageFromOtherFlutterEngine();

    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('${DataTransferManager.instance.currentEntryName} 入口的 BaseDataTransfer 已被初始化。'),
      exception: null,
      stackTrace: null,
    );
  }

  /// 统一使用 data_channel 通道。
  ///
  /// 必须在 [ServicesBinding] 绑定之后才能执行，即这个类必须在初始化之前进行 [WidgetsFlutterBinding.ensureInitialized] 的绑定。
  final BasicMessageChannel<Object?> _basicMessageChannel = const BasicMessageChannel<Object?>('data_channel', StandardMessageCodec());

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
  Future<MessageResult<R>> sendMessageToOtherEngine<S, R extends Object>({
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
      final Object? resultObj = await _basicMessageChannel.send(messageMap);
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

  /// {@template BaseDataTransfer._listenerMessageFromOtherEngine}
  ///
  /// 监听其他引擎发来的消息，并响应返回值。
  ///
  /// 不监听 native 单独传递过来。
  ///
  /// {@endtemplate}
  void _listenerMessageFromOtherFlutterEngine() {
    _basicMessageChannel.setMessageHandler(
      (Object? message) async {
        try {
          final Map<Object?, Object?> messageMap = message! as Map<Object?, Object?>;
          return await listenerMessageFormOtherFlutterEngine(messageMap['operation_id']! as String, messageMap['data']);
        } catch (e, st) {
          SbLogger(code: null, viewMessage: null, data: null, description: Description('接收者发生了异常！'), exception: e, stackTrace: st);
          return null;
        }
      },
    );
  }

  /// {@macro BaseDataTransfer._listenerMessageFromOtherEngine}
  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data);

  Exception throwUnhandledOperationIdException(String currentOperationId) {
    return Exception('Unhandled $currentOperationId');
  }
}
