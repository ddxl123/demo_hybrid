
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/muc/getcontroller/homepage/HomePageGetController.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/util/sbbutton/Global.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/AutoPosition.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';

abstract class AbstractLongPressedPoolRoute extends SbRoute {
  @override
  List<Widget> body() {
    final Offset position = touchPosition;
    return <AutoPositioned>[
      AutoPositioned(
        touchPosition: position,
        child: SbRoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('创建节点'),
              onPressed: () async {
                final Offset offset = Get.find<HomePageGetController>().sbFreeBoxController.screenToBoxActual(position);
                final String easyPosition = '${offset.dx},${offset.dy}';
                final PoolNodeModel poolNodeModel = await createNewNode(easyPosition);
                Get.find<PoolGetController>().updateLogic.insertNewNode(poolNodeModel);
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  bool whenException(Object? exception, StackTrace? stackTrace) {
    SbLogger(
      code: -1,
      viewMessage: null,
      data: null,
      description: null,
      exception: exception,
      stackTrace: stackTrace,
    ).withAll(true);
    return false;
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(popResult, (SbPopResult quickPopResult) async => false);
  }

  Future<PoolNodeModel> createNewNode(String easyPosition);
}
