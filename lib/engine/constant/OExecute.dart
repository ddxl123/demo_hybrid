// ignore_for_file: camel_case_types
class OExecute_FlutterSend {
  /// 检查引擎是否已被启动，若未启动则启动。
  static const String START_ENGINE = 'start_engine';

  /// 当引擎第一帧被初始化完成时，需要发送消息给原生。
  static const String SET_FIRST_FRAME_INITIALIZED = 'set_first_frame_initialized';

  /// 检查对应的引擎第一帧是否已被初始化完成。
  static const String IS_FIRST_FRAME_INITIALIZED = 'is_first_frame_initialized';

  /// set view。
  static const String SET_VIEW = 'set_view';
}

class OExecute_FlutterListen {}
