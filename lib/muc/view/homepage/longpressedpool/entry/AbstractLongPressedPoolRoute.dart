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
    return <FollowPositioned>[
      FollowPositioned(
        touchPosition: position,
        child: SbRoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('创建节点'),
              onPressed: () async {
                final Offset offset = Get.find<HomePageGetController>().sbFreeBoxController.screenToBoxActual(position);
                final String easyPosition = '${offset.dx},${offset.dy}';
                final PoolNodeModel? poolNodeModel = await createNewNode(easyPosition);
                if (poolNodeModel != null) {
                  Get.find<PoolGetController>().insertNewNode(poolNodeModel);
                } else {
                  SbLogger(c: null, vm: '添加节点失败！', data: null, descp: Description('添加节点失败！'), e: null, st: null);
                }
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
      c: -1,
      vm: null,
      data: null,
      descp: null,
      e: exception,
      st: stackTrace,
    ).withAll(true);
    return false;
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(popResult, (SbPopResult quickPopResult) async => false);
  }

  Future<PoolNodeModel?> createNewNode(String easyPosition);
}
