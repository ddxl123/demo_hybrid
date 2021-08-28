import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/muc/view/loginpage/LoginPage.dart';
import 'package:hybrid/util/SbHelper.dart';

/// 屏幕宽高。
/// TODO: 未测试应用外悬浮框的大小是否为这个大小。
final Size screenSize = MediaQueryData.fromWindow(window).size;

/// 快捷 setState 类型。
typedef SetState = void Function(void Function());

/// 直接获取当前 widget 的 rect。
class SbRectWidget extends StatelessWidget {
  const SbRectWidget({required this.builder});

  final Widget Function(Rect Function() getRect) builder;

  @override
  Widget build(BuildContext context) {
    Rect getRect() {
      final RenderBox rb = context.findRenderObject()! as RenderBox;
      final Offset ltPosition = rb.localToGlobal(Offset.zero);
      final Rect rect = Rect.fromPoints(
        ltPosition,
        ltPosition + Offset(context.size!.width, context.size!.height),
      );
      return rect;
    }

    return builder(getRect);
  }
}

void toLoginPage() {
  SbHelper.getNavigator!.push(LoginPage());
}
