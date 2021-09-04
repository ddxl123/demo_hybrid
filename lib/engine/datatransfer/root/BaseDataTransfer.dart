import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

/// 之所以不为 [R extends Object?]，是因为正确的响应结果不能为空。
class MessageResult<R extends Object> {
  MessageResult({required this.resultData, required this.exception, required this.stackTrace});

  /// 响应的数据。
  ///
  /// 当 [exception] 不为空时，[resultData] 可为空。
  R? resultData;
  Object? exception;
  StackTrace? stackTrace;

  /// 是否存在异常。
  bool get _hasErr => exception != null;

  /// 一次性设置全部。
  MessageResult<R> setAll({required R? resultData, required Object? exception, required StackTrace? stackTrace}) {
    this.resultData = resultData;
    this.exception = exception;
    this.stackTrace = stackTrace;
    return this;
  }

  /// 将当前对象克隆到指定对象上。
  void cloneTo(MessageResult<R> otherMessageResult) {
    otherMessageResult.setAll(resultData: resultData, exception: exception, stackTrace: stackTrace);
  }

  /// 已对 [onSuccess] 内部进行异常捕获，若捕获到异常，则会转发给 [onError]。
  Future<void> handle({required Future<void> onSuccess(R data), required Future<void> onError(Object? exception, StackTrace? stackTrace)}) async {
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
      description: Description('${DataTransferManager.instance.currentEntryPointName} 入口的 BaseDataTransfer 已被初始化。'),
      exception: null,
      stackTrace: null,
    );
  }

  /// 统一使用 data_channel 通道。
  ///
  /// 必须在 [ServicesBinding] 绑定之后才能执行，即这个类必须在初始化之前进行 [WidgetsFlutterBinding.ensureInitialized] 的绑定。
  final BasicMessageChannel<Object?> basicMessageChannel = const BasicMessageChannel<Object?>('data_channel', StandardMessageCodec());

  /// {@template BaseDataTransfer._listenerMessageFromOtherEngine}
  ///
  /// 监听其他引擎发来的消息，并响应返回值。
  ///
  /// 不监听 native 单独传递过来。
  ///
  /// {@endtemplate}
  void _listenerMessageFromOtherFlutterEngine() {
    basicMessageChannel.setMessageHandler(
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
