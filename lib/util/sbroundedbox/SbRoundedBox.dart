import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/main.dart';
import 'package:hybrid/util/SbHelper.dart';

class SbRoundedBox extends StatelessWidget {
  const SbRoundedBox({
    this.width,
    this.height,
    this.padding,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isScrollable = true,
    required this.whenSizeChanged,
  });

  /// [width] 最大值为屏幕宽度值，为 null 时按照子 widget 的宽值。
  final double? width;

  /// [height] 最大值为屏幕高度值，为 null 时按照子 widget 的高值。
  final double? height;

  /// 整个 box 的 padding。
  final EdgeInsetsGeometry? padding;

  /// [mainAxisAlignment]：[children] 整体的纵轴对齐。
  final MainAxisAlignment mainAxisAlignment;

  /// [crossAxisAlignment]：[children] 整体的横轴对齐。
  final CrossAxisAlignment crossAxisAlignment;

  /// 是否可滚动
  final bool isScrollable;

  final List<Widget> children;

  /// 当 [SbRoundedBoxBody] size 发生改变时触发。
  final Function(SizeInt newSizeInt) whenSizeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 如果不 alignment，SingleChildScrollView/Column 宽度默认是展开到父容器那么大，alignment 后会以 children 最大的宽度为准
      alignment: Alignment.center,
      child: SbRoundedBoxBody(this),
    );
  }
}

/// column 类型的圆角框。
///
/// 应用于简单弹出框，或简单的非弹出框。
class SbRoundedBoxBody extends StatefulWidget {
  const SbRoundedBoxBody(this.sbRoundedBox);

  final SbRoundedBox sbRoundedBox;

  @override
  _SbRoundedBoxBodyState createState() => _SbRoundedBoxBodyState();
}

class _SbRoundedBoxBodyState extends State<SbRoundedBoxBody> with WidgetsBindingObserver {
  SizeInt currentSize = const SizeInt(-1, -1);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) {
        final SizeInt newSizeInt = SizeInt.fromSizeDouble(context.size! * MediaQuery.of(context).devicePixelRatio);
        if (currentSize != newSizeInt && hadSentSetFirstFrameInitialized) {
          currentSize = newSizeInt;
          widget.sbRoundedBox.whenSizeChanged(newSizeInt);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.sbRoundedBox.width,
      height: widget.sbRoundedBox.height,
      constraints: BoxConstraints(
        minWidth: 0,
        maxWidth: MediaQueryData.fromWindow(window).size.width,
        minHeight: 0,
        maxHeight: MediaQueryData.fromWindow(window).size.height,
      ),
      padding: widget.sbRoundedBox.padding,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const <BoxShadow>[
          // BoxShadow(offset: Offset(10, 10), blurRadius: 10, spreadRadius: -10),
        ],
      ),
      child: () {
        if (widget.sbRoundedBox.isScrollable) {
          return SingleChildScrollView(
            padding: EdgeInsets.zero,
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            child: Column(
              mainAxisAlignment: widget.sbRoundedBox.mainAxisAlignment,
              crossAxisAlignment: widget.sbRoundedBox.crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[...widget.sbRoundedBox.children],
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: widget.sbRoundedBox.mainAxisAlignment,
            crossAxisAlignment: widget.sbRoundedBox.crossAxisAlignment,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[...widget.sbRoundedBox.children],
          );
        }
      }(),
    );
  }
}
