import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';

/// 需在引擎入口执行前创建该 [TransferListener] 实例，之后使用 [DataTransferManager.instance] 对该实例进行操作。
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
        final SingleResult<Object?> listenerResult = SingleResult<Object?>();
        try {
          final Map<String, Object?> messageMap = message!.quickCast();
          return (await listenerMessageFormOtherFlutterEngineUniform(listenerResult, messageMap['operation_id']! as String, messageMap['data']))!.toJson();
        } catch (e, st) {
          return listenerResult.setError(vm: 'listener 异常！', descp: Description('_listenerMessageFromOtherFlutterEngine 发送异常！'), e: e, st: st).toJson();
        }
      },
    );
  }

  /// {@macro BaseDataTransfer._listenerMessageFromOtherEngine}
  ///
  /// 内部异常已交给 [_listenerMessageFromOtherFlutterEngine] 捕获。
  Future<SingleResult<Object?>?> listenerMessageFormOtherFlutterEngineUniform(SingleResult<Object?> listenerResult, String operationId, Object? data) async {
    if (operationId == OUniform.IS_ENGINE_ON_READY) {
      return listenerResult.setSuccess(putData: () => DataTransferManager.instance.isCurrentFlutterEngineOnReady);
    }
    return await listenerMessageFormOtherFlutterEngine(listenerResult, operationId, data);
  }

  Future<SingleResult<Object?>?> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> listenerResult, String operationId, Object? data);
}
