// ignore_for_file: camel_case_types

/// 专门传递操作给原生的常量
class OToNative {
  /// 启动引擎。
  static const String START_ENGINE = 'start_engine';

  /// 设置窗口的 [ViewParams] 属性。
  static const String SET_VIEW_PARAMS = 'set_view_params';

  /// 获取屏幕大小（非窗口大小）。
  static const String GET_SCREEN_SIZE = 'get_screen_size';

  /// 获取当前引擎的 window 物理像素大小
  static const String GET_NATIVE_WINDOW_VIEW_PARAMS = 'get_native_window_view_params';

  /// 检查是否已允许悬浮窗权限。
  static const String check_floating_window_permission = 'check_floating_window_permission';

  /// 检查是否已允许悬浮窗权限，如果未允许，则弹出悬浮窗权限设置页面。
  static const String check_and_push_page_floating_window_permission = 'check_and_push_page_floating_window_permission';
}
