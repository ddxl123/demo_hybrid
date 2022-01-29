import 'package:flutter/material.dart';

/// 自动设置 child 在屏幕中的位置
///
/// 要注意 child 高度不能大于屏幕高度的一半，否则溢出部分无法显示
class FollowPositioned extends StatelessWidget {
  const FollowPositioned({required this.child, required this.touchPosition, Key? key}) : super(key: key);

  final Widget child;
  final Offset touchPosition;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Size halfScreenSize = MediaQuery.of(context).size / 2;
    double? left;
    double? right;
    double? top;
    double? button;

    if (touchPosition.dx < halfScreenSize.width && touchPosition.dy < halfScreenSize.height) {
      left = touchPosition.dx;
      top = touchPosition.dy;
    } else if (touchPosition.dx < halfScreenSize.width && touchPosition.dy > halfScreenSize.height) {
      left = touchPosition.dx;
      button = screenSize.height - touchPosition.dy;
    } else if (touchPosition.dx > halfScreenSize.width && touchPosition.dy < halfScreenSize.height) {
      right = screenSize.width - touchPosition.dx;
      top = touchPosition.dy;
    } else if (touchPosition.dx > halfScreenSize.width && touchPosition.dy > halfScreenSize.height) {
      right = screenSize.width - touchPosition.dx;
      button = screenSize.height - touchPosition.dy;
    } else {
      left = touchPosition.dx;
      top = touchPosition.dy;
    }

    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: button,
      child: child,
    );
  }
}
