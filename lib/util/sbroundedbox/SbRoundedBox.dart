import 'package:flutter/material.dart';

/// column 类型的圆角框。
///
/// 应用于简单弹出框，或简单的非弹出框。
class SbRoundedBox extends StatelessWidget {
  const SbRoundedBox({
    this.width,
    this.height,
    this.padding,
    required this.children,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.isScrollable = true,
  });

  /// [width] 最大值为屏幕宽度值，为 null 时按照子 widget 的宽值。
  final double? width;

  /// [height] 最大值为屏幕高度值，为 null 时按照子 widget 的高值。
  final double? height;

  /// 整个 box 的 padding。
  final EdgeInsetsGeometry? padding;

  /// [crossAxisAlignment]：[children] 整体的横轴对齐。
  final CrossAxisAlignment crossAxisAlignment;

  /// 是否可滚动
  final bool isScrollable;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      // 如果不 alignment，SingleChildScrollView/Column 宽度默认是展开到父容器那么大，alignment 后会以 children 最大的宽度为准
      alignment: Alignment.center,
      child: Container(
        width: width,
        height: height,
        constraints: BoxConstraints(
          minWidth: 0,
          maxWidth: MediaQuery.of(context).size.width,
          minHeight: 0,
          maxHeight: MediaQuery.of(context).size.height,
        ),
        padding: padding,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
                offset: Offset(10, 10), blurRadius: 10, spreadRadius: -10),
          ],
        ),
        child: () {
          if (isScrollable) {
            return SingleChildScrollView(
              padding: EdgeInsets.zero,
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              child: Column(
                crossAxisAlignment: crossAxisAlignment,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[...children],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: crossAxisAlignment,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[...children],
            );
          }
        }(),
      ),
    );
  }
}
