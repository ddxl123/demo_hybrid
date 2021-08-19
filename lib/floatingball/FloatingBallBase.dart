import 'package:flutter/material.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';

abstract class FloatingBallBase {
  FloatingBallBase() {
    _position = initPosition;

    overlayEntry = OverlayEntry(
      maintainState: true, // TODO: 重点！！！
      builder: (BuildContext floatingBallContext) {
        return Positioned(
          top: _position.dy,
          left: _position.dx,
          child: Material(
            type: MaterialType.transparency,
            child: SbButton(
              onUp: (PointerUpEvent pointerUpEvent) => onUp(pointerUpEvent),
              onMove: (PointerMoveEvent pointerMoveEvent) {
                _position += pointerMoveEvent.delta;
                overlayEntry.markNeedsBuild();
              },
              child: Container(
                width: radius,
                height: radius,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.red,
                ),
                child: Text(floatingBallName),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 悬浮球的当前位置。
  late Offset _position;

  /// 提供给 [OverlayState] insert。
  late final OverlayEntry overlayEntry;

  /// 悬浮球的名称。
  String get floatingBallName;

  /// 悬浮球的初始化位置。
  Offset get initPosition;

  /// 悬浮球的半径。
  double get radius;

  bool get isHideAfterOnUp => true;

  /// 点击了悬浮球，
  void onUp(PointerUpEvent pointerUpEvent);
}
