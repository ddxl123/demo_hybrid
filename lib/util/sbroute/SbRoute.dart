import 'package:flutter/material.dart';

import 'SbPopResult.dart';
import 'SbRouteWidget.dart';

/// [SbRoute] 具有触发返回功能的 toast。
///
/// [SbPopResult] 触发 pop 时的传参，用来识别是什么类型的 pop (物理键返回？点击背景返回？)，并根据识别结果进行对应的逻辑操作。
abstract class SbRoute extends OverlayRoute<SbPopResult> {
  ///

  SbRoute({this.triggerRect});

  // ==============================================================================
  //
  // 需实现的部分
  //

  /// [whenPop]：
  /// - 若返回 true，则异步完后整个 route 被 pop,；
  /// - 若返回 false，则异步完后 route 不进行 pop，只有等待页面被 pop。
  ///
  /// 参数值 [popResult]：
  /// - 若参数值的 [SbPopResult] 为 null，则代表(或充当)'物理返回'。
  /// - 若参数值的 [PopResultSelect] 为 [PopResultSelect.clickBackground]，则代表点击了背景。
  ///
  /// 已经被设定多次触发时只会执行第一次。
  Future<bool> whenPop(SbPopResult? popResult);

  /// [whenPop] 发生异常时的回调。
  ///
  /// [return] 返回 true，则表示 pop。
  bool whenException(Object? exception, StackTrace? stackTrace);

  ///初始化。
  void onInit() {}

  /// 初始化完成。
  void onRead() {}

  /// 会先执行 [build] 函数，后返回 widget。
  void onBuild() {}

  /// Widget 为 [Positioned] 或 [AutoPositioned]
  List<Widget> body();

  /// 背景不透明度
  double get backgroundOpacity => 0;

  /// 背景颜色
  Color get backgroundColor => Colors.transparent;

  /// 使该 route 弹出的 widget 的 rect。
  Rect? triggerRect;

  // ==============================================================================
  //
  // 非实现部分
  //

  /// 当前 route 顶层 Widget 的 setState
  late Function sbRouteSetState;

  /// 是否显示 popWaiting
  bool isPopWaiting = false;

  /// 是否 pop
  bool isPop = false;

  /// 是否正在 pop 中
  bool isPopping = false;

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return <OverlayEntry>[
      OverlayEntry(
        builder: (_) {
          return SbRouteWidget(this);
        },
      ),
    ];
  }

  /// 触发 pop。
  @override
  bool didPop(SbPopResult? result) {
    if (isPop == true) {
      super.didPop(result);
      return true;
    } else {
      // 这里 [toPop] 是异步的，先 return false，后完成 toPop 再次触发 didPop。
      toPop(result);
      return false;
    }
  }

  /// pop 的结果处理。
  Future<void> toPop(SbPopResult? result) async {
    try {
      if (isPopping) {
        return;
      }
      isPopping = true;
      isPopWaiting = true;
      sbRouteSetState();

      final bool popResult = await whenPop(result);
      if (popResult) {
        isPop = true;
        didPop(result);
      } else {
        isPopping = false;
        isPopWaiting = false;
        sbRouteSetState();
      }
    } catch (e, st) {
      isPopping = false;
      isPopWaiting = false;
      sbRouteSetState();
    }
  }

  /// 对 [whenPop] 的快捷使用。
  ///
  /// 当触发点击背景或物理返回时，直接返回。
  Future<bool> quickWhenPop(SbPopResult? popResult, Future<bool> callback(SbPopResult quickPopResult)) async {
    if (popResult == null || popResult.popResultSelect == PopResultSelect.clickBackground) {
      return true;
    }
    return await callback(popResult);
  }

  ///
}
