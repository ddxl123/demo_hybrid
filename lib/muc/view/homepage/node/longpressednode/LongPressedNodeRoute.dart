
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
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
    return await quickWhenPop(popResult, (SbPopResult quickPopResult) async {
      if (quickPopResult.popResultSelect == PopResultSelect.one) {
        await SqliteCurd<ModelBase>().deleteRow(
          modelTableName: poolNodeModel.getCurrentNodeModel().tableName,
          modelId: poolNodeModel.getCurrentNodeModel().get_id,
          transactionMark: null,
        );
        Get.find<PoolGetController>().updateLogic.deleteNode(poolNodeModel);
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
