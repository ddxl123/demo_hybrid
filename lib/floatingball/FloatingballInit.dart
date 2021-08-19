import 'package:flutter/material.dart';

import 'floatingball/SqliteDataFloatingBall.dart';

/// 把所有要启动的悬浮球放在这里面
final List<OverlayEntry> overlayEntries = <OverlayEntry>[
  SqliteDataFloatingBall().overlayEntry,
];

class FloatingBallInit {
  void init(BuildContext context) {
    final NavigatorState _navigatorState = Navigator.of(context);
    _navigatorState.overlay!.insertAll(overlayEntries);
  }
}
