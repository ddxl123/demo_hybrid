import 'dart:ui';

import 'package:flutter/material.dart';

import 'Global.dart';

class SbFreeBoxStack extends StatefulWidget {
  const SbFreeBoxStack({required this.builder});

  final List<Widget> Function(
    BuildContext context,
    void Function(void Function()) bSetState,
  ) builder;

  @override
  _SbFreeBoxStackState createState() => _SbFreeBoxStackState();
}

class _SbFreeBoxStackState extends State<SbFreeBoxStack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.builder(context, setState),
    );
  }
}

/// 元素在盒子中的定位
///
/// 加上 [sbFreeBoxBodyOffset] 目的之一是为了复原存储前被减去的偏移。
class SbFreeBoxPositioned extends StatelessWidget {
  const SbFreeBoxPositioned({required this.easyPosition, required this.child});

  final Offset easyPosition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: easyPosition.dy + sbFreeBoxBodyOffset.dy,
      left: easyPosition.dx + sbFreeBoxBodyOffset.dy,
      child: child,
    );
  }
}
