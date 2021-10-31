import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/poolentry/AbstractPoolEntry.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/Global.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/AutoPosition.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';

abstract class LongPressedNodeRouteBase extends AbstractPoolEntryRoute {
  LongPressedNodeRouteBase(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  List<Widget> body() {
    return <Widget>[
      AutoPositioned(
        touchPosition: touchPosition,
        child: SbRoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('删除节点'),
              onPressed: () async {
                SbHelper.getNavigator!.pop(SbPopResult(popResultSelect: PopResultSelect.one, value: null));
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
    return await quickWhenPop(popResult, (SbPopResult quickPopResult) async {
      if (quickPopResult.popResultSelect == PopResultSelect.one) {
        final SingleResult<bool> deleteResult = await DataTransferManager.instance.transfer.executeSqliteCurd.deleteRow(
          modelTableName: poolNodeModel.getCurrentNodeModel().tableName,
          modelId: poolNodeModel.getCurrentNodeModel().get_id,
        );
        await deleteResult.handle<void>(
          onSuccess: (bool successResult) async {
            Get.find<PoolGetController>().deleteNode(poolNodeModel);
          },
          onError: (Object? exception, StackTrace? stackTrace) async {
            SbLogger(
              c: null,
              vm: '删除失败！',
              data: null,
              descp: Description('删除失败！'),
              e: deleteResult.exception,
              st: deleteResult.stackTrace,
            );
          },
        );
        return true;
      }
      return false;
    });
  }
}

class LongPressedNodeRouteForFragment extends LongPressedNodeRouteBase {
  LongPressedNodeRouteForFragment(PoolNodeModel poolNodeModel) : super(poolNodeModel);
}

class LongPressedNodeRouteForMemory extends LongPressedNodeRouteBase {
  LongPressedNodeRouteForMemory(PoolNodeModel poolNodeModel) : super(poolNodeModel);
}

class LongPressedNodeRouteForComplete extends LongPressedNodeRouteBase {
  LongPressedNodeRouteForComplete(PoolNodeModel poolNodeModel) : super(poolNodeModel);
}

class LongPressedNodeRouteForRule extends LongPressedNodeRouteBase {
  LongPressedNodeRouteForRule(PoolNodeModel poolNodeModel) : super(poolNodeModel);
}
