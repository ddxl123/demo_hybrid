import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/floatingball/route/sqlitedata/SqliteDataRoute.dart';

import '../FloatingBallBase.dart';

class SqliteDataFloatingBall extends FloatingBallBase {
  @override
  String get floatingBallName => 'SqliteData';

  @override
  Offset get initPosition => const Offset(100, 100);

  @override
  double get radius => 70;

  @override
  void onUp(PointerUpEvent pointerUpEvent) {
    // TODO: 临时使用 Get.context。
    Navigator.push<dynamic>(Get.context!, SqliteDataRoute());
  }
}
