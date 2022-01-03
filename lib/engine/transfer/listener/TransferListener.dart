import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';

/// 需在引擎入口执行前创建该 [TransferListener] 实例，之后使用 [TransferManager.instance] 对该实例进行操作。
abstract class TransferListener {
  TransferListener() {
    _listenerMessageFromOtherFlutterEngine();
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
  /// 响应 null 表示失败，即正确的响应不能为空。
  ///
  /// {@endtemplate}
  void _listenerMessageFromOtherFlutterEngine() {
    basicMessageChannel.setMessageHandler(
      (Object? message) async {
        final SingleResult<Object?> returnResult = SingleResult<Object?>();
        try {
          final Map<String, Object?> messageMap = message!.quickCast();
          final String operationId = messageMap['operation_id']! as String;
          final Object? data = messageMap['data'];
          // TODO: 对 SingleResult 增加异常消息叠加机制。
          SbLogger(c: null, vm: null, data: null, descp: Description(operationId), e: null, st: null);
          await _listenerMessageFormOtherFlutterEngineUniformBasic(returnResult, operationId, data);
        } catch (e, st) {
          returnResult.setError(vm: 'listener 异常！', descp: Description('_listenerMessageFromOtherFlutterEngine 发送异常！'), e: e, st: st);
        }
        return returnResult.toJson();
      },
    );
  }

  /// {@macro BaseDataTransfer._listenerMessageFromOtherEngine}
  ///
  /// 内部异常已交给 [_listenerMessageFromOtherFlutterEngine] 捕获。
  Future<SingleResult<Object?>> _listenerMessageFormOtherFlutterEngineUniformBasic(
    SingleResult<Object?> returnResult,
    String operationId,
    Object? operationData,
  ) async {
    if (operationId == OUniform.IS_ENGINE_ON_READY) {
      return returnResult.setSuccess(putData: () => TransferManager.instance.isCurrentFlutterEngineOnReady);
    } else if (operationId == OUniform.SQLITE_CURD_TRANSACTION_CREATE_RESULT) {
      return _sqliteCurdTransactionCreateResult(returnResult, operationData);
    } else {
      return await listenerMessageFormOtherFlutterEngine(returnResult, operationId, operationData);
    }
  }

  Future<SingleResult<Object?>> _sqliteCurdTransactionCreateResult(
    SingleResult<Object?> returnResult,
    Object? operationData,
  ) async {
    try {
      final String chainId = operationData! as String;
      if (!TransferManager.instance.sqliteCurdTransactionsInRequester.containsKey(chainId)) {
        throw 'chainId 不存在！';
      }
      return await TransferManager.instance.sqliteCurdTransactionsInRequester[chainId]!.executeCurdRequestFunction(returnResult);
    } catch (e, st) {
      return returnResult.setError(vm: '事务函数执行异常！', descp: Description(''), e: e, st: st);
    }
  }

  Future<SingleResult<Object?>> listenerMessageFormOtherFlutterEngine(
    SingleResult<Object?> returnResult,
    String operationId,
    Object? operationData,
  );
}
