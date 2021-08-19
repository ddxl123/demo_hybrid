import 'package:flutter/material.dart';

import 'SbFreeBoxController.dart';
import 'SbFreeBoxWidget.dart';

class SbFreeBox extends StatefulWidget {
  const SbFreeBox({
    required this.sbFreeBoxController,
    this.boxBodyBackgroundColor = Colors.green,
    this.boxOutsideBackgroundColor = Colors.red,
    required this.boxSize,
    this.alignment = Alignment.topLeft,
    required this.freeMoveScaleLayerWidgets,
    required this.fixedLayerWidgets,
  });

  /// 控制器
  final SbFreeBoxController sbFreeBoxController;

  /// 整体内容物的背景颜色
  final Color boxBodyBackgroundColor;

  /// 内容物外的背景颜色
  final Color boxOutsideBackgroundColor;

  /// 视口高度尺寸
  /// [boxSize]：不能为 [double.infinity] 或 [double.maxFinite]
  final Size boxSize;

  /// alignment
  final Alignment alignment;

  /// 自由缩放层。必须使用 [SbFreeBoxStack]。
  ///
  /// setState box，不会同时 setState 这个。
  final Widget freeMoveScaleLayerWidgets;

  /// 固定层。必须使用 Stack + Position。
  ///
  /// setState box，不会同时 setState 这个。
  final Stack fixedLayerWidgets;

  @override
  State<StatefulWidget> createState() {
    return _FreeBox();
  }
}

class _FreeBox extends State<SbFreeBox> with TickerProviderStateMixin {
  ///

  @override
  void initState() {
    super.initState();

    initSliding();
  }

  @override
  void dispose() {
    widget.sbFreeBoxController.dispose();
    super.dispose();
  }

  void initSliding() {
    widget.sbFreeBoxController.inertialSlideAnimationController = AnimationController(vsync: this);
    widget.sbFreeBoxController.targetSlideAnimationController = AnimationController(vsync: this);
    // 内容物是 widget 对象，而返回值为 widget 对象的函数，因此，对 box 进行 setState，不会同时 setState 内容物的 widget 对象。
    widget.sbFreeBoxController.sbFreeBoxSetState = setState;
  }

  @override
  Widget build(BuildContext context) {
    return _box();
  }

  Widget _box() {
    return Container(
      alignment: widget.alignment,
      child: Container(
        alignment: Alignment.topLeft,
        // 整个 box 的大小
        width: widget.boxSize.width,
        height: widget.boxSize.height,
        color: widget.boxOutsideBackgroundColor,
        //整个 box 的背景颜色
        child: Stack(
          children: <Positioned>[
            /// 自由移动缩放层
            _freeMoveScaleLayer(),
            _fixedLayer(),
          ],
        ),
      ),
    );
  }

  Positioned _freeMoveScaleLayer() {
    return Positioned(
      top: 0,
      child: Container(
        // 自由缩放触发区从 box 的左上角开始
        alignment: Alignment.topLeft,
        // 可触发自由缩放的区域的大小。若比 box 小，则内容物会溢出显示但无法触发；若比 box 大，则会收容内容物。
        // 若内容物位置处于该大小区域外，则该内容物会消失。
        width: widget.boxSize.width + 1000000,
        height: widget.boxSize.height + 1000000,
        // 因为触发区始终比整个 box 大，因此颜色会覆盖掉 box 的背景颜色
        color: widget.boxOutsideBackgroundColor,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          // 让透明部分也能触发事件
          onScaleStart: widget.sbFreeBoxController.onScaleStart,
          onScaleUpdate: widget.sbFreeBoxController.onScaleUpdate,
          onScaleEnd: widget.sbFreeBoxController.onScaleEnd,
          child: Transform.translate(
            offset: widget.sbFreeBoxController.freeBoxCamera.getActualPosition(),
            child: Transform.scale(
              alignment: Alignment.topLeft,
              scale: widget.sbFreeBoxController.freeBoxCamera.scale,
              // [内容物s]
              child: StatefulBuilder(
                builder: (BuildContext context, void Function(void Function()) nrwSetState) {
                  return Container(
                    color: widget.boxBodyBackgroundColor,
                    child: widget.freeMoveScaleLayerWidgets,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Positioned _fixedLayer() {
    return Positioned(
      top: 0,
      width: widget.boxSize.width,
      height: widget.boxSize.height,
      child: StatefulBuilder(
        builder: (BuildContext context, void Function(void Function()) flSetState) {
          return widget.fixedLayerWidgets;
        },
      ),
    );
  }
}
