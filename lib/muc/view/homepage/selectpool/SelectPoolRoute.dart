
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/global/Global.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';

class SelectPoolRoute extends SbRoute {
  SelectPoolRoute({required Rect triggerRect}) : super(triggerRect: triggerRect);

  @override
  List<Widget> body() {
    return <Widget>[
      Positioned(
        bottom: screenSize.height - triggerRect!.top,
        right: 0,
        left: 0,
        child: SbRoundedBox(
          whenSizeChanged: (Size newSize) {  },
          children: <Widget>[
            TextButton(
              child: const Text('碎片池'),
              onPressed: () {
                Get.back<SbPopResult>(result: SbPopResult(popResultSelect: PopResultSelect.one, value: PoolType.fragment));
              },
            ),
            TextButton(
              child: const Text('记忆池'),
              onPressed: () {
                Get.back<SbPopResult>(result: SbPopResult(popResultSelect: PopResultSelect.one, value: PoolType.memory));
              },
            ),
            TextButton(
              child: const Text('完成池'),
              onPressed: () {
                Get.back<SbPopResult>(result: SbPopResult(popResultSelect: PopResultSelect.one, value: PoolType.complete));
              },
            ),
            TextButton(
              child: const Text('规则池'),
              onPressed: () {
                Get.back<SbPopResult>(result: SbPopResult(popResultSelect: PopResultSelect.one, value: PoolType.rule));
              },
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(
      popResult,
      (SbPopResult quickPopResult) async {
        if (quickPopResult.popResultSelect == PopResultSelect.one) {
          final PoolGetController fragmentPoolGetController = Get.find<PoolGetController>();
          if (quickPopResult.value is PoolType) {
            await fragmentPoolGetController.updateLogic.to(quickPopResult.value! as PoolType);
            return true;
          }
        }
        return false;
      },
    );
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
}
