import 'dart:async';

import 'package:flutter/services.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

/// 需在引擎入口执行前创建该 [BaseDataTransfer] 实例，之后使用 [DataTransferManager.instance] 对该实例进行操作。
abstract class BaseDataTransfer {
  BaseDataTransfer() {
    _listenerMessageFromOtherFlutterEngine();

    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('${DataTransferManager.instance.currentEntryPointName} 入口的 BaseDataTransfer 初始化成功。'),
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
  /// 响应 null 表示失败，即正确的响应不能为空。
  ///
  /// {@endtemplate}
  void _listenerMessageFromOtherFlutterEngine() {
    basicMessageChannel.setMessageHandler(
      (Object? message) async {
        try {
          final Map<Object?, Object?> messageMap = message! as Map<Object?, Object?>;
          return await listenerMessageFormOtherFlutterEngineUniform(messageMap['operation_id']! as String, messageMap['data']);
        } catch (e, st) {
          SbLogger(code: null, viewMessage: null, data: null, description: Description('接收的引擎发生了异常！'), exception: e, stackTrace: st);
          return null;
        }
      },
    );
  }

  /// {@macro BaseDataTransfer._listenerMessageFromOtherEngine}
  ///
  /// 内部异常已交给 [_listenerMessageFromOtherFlutterEngine] 捕获。
  Future<Object?> listenerMessageFormOtherFlutterEngineUniform(String operationId, Object? data) async {
    if (operationId == OUniform.IS_ENGINE_ON_READY) {
      return DataTransferManager.instance.isCurrentFlutterEngineOnReady;
    }
    return await listenerMessageFormOtherFlutterEngine(operationId, data);
  }

  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data);
}
