// ignore_for_file: camel_case_types
class OExecute_FlutterSend {
  /// 检查引擎是否已被启动，若未启动则启动。
  static const String START_ENGINE = 'start_engine';

  /// 获取屏幕大小。
  static const String GET_SCREEN_SIZE = 'get_screen_size';

  /// 当引擎第一帧被初始化完成时，需要发送消息给原生。
  static const String SET_FIRST_FRAME_INITIALIZED = 'set_first_frame_initialized';

  /// 检查对应的引擎第一帧是否已被初始化完成。
  static const String IS_FIRST_FRAME_INITIALIZED = 'is_first_frame_initialized';

  /// set view。
  static const String SET_VIEW = 'set_view';

  /// sqlite query row - queryRowsAsJsons
  static const String SQLITE_QUERY_ROW_AS_JSONS = 'sqlite_query_row_as_jsons';

  /// sqlite query row - queryRowsAsModels
  static const String SQLITE_QUERY_ROW_AS_MODELS = 'sqlite_query_row_as_models';

  /// sqlite insert row。
  static const String SQLITE_INSERT_ROW = 'sqlite_insert_row';

  /// sqlite update row。
  static const String SQLITE_UPDATE_ROW = 'sqlite_update_row';

  /// sqlite delete row。
  static const String SQLITE_DELETE_ROW = 'sqlite_delete_row';

  /// 获取当前引擎的 window 大小(非 flutter 实际大小)
  static const String GET_NATIVE_WINDOW_VIEW_PARAMS = 'get_native_window_view_params';
}

class OExecute_FlutterListen {}
