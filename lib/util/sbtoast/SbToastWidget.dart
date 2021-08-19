import 'dart:math';

import 'package:flutter/material.dart';

/// [SbToastWidget] 全局的 toast，一个提示条工具。
class SbToastWidget extends StatelessWidget {
  SbToastWidget({required this.text});

  final String text;

  final List<Color> colors = <Color>[
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.amber,
    Colors.blue,
    Colors.cyan,
    Colors.indigo
  ];

  @override
  Widget build(BuildContext context) {
    final Random random = Random();
    return Container(
      padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).padding.top, 0, 0),
      alignment: Alignment.topCenter,
      child: Material(
        child: Container(
          color: colors[random.nextInt(colors.length)],
          child: Text(text, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
