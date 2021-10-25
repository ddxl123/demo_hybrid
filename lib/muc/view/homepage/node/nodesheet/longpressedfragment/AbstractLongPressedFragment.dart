import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/entry/AbstractNodeSheetRoute.dart';
import 'package:hybrid/muc/view/homepage/poolentry/AbstractPoolEntry.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/Global.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/AutoPosition.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';

abstract class AbstractLongPressedFragment<FDM extends ModelBase> extends AbstractPoolEntryRoute {
  AbstractLongPressedFragment(this.fatherRoute, this.currentFragmentModel) : super(fatherRoute.poolNodeModel);

  final AbstractNodeSheetRoute<FDM> fatherRoute;

  final FDM currentFragmentModel;

  @override
  List<Widget> body() {
    return <Widget>[
      AutoPositioned(
        child: SbRoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('删除碎片'),
              onPressed: () {
                SbHelper.getNavigator!.pop(SbPopResult(popResultSelect: PopResultSelect.one, value: null));
              },
            ),
          ],
        ),
        touchPosition: touchPosition,
      ),
    ];
  }

  @override
  bool whenException(Object? exception, StackTrace? stackTrace) {
    SbLogger(
      code: -1,
      viewMessage: null,
      data: null,
      description: Description('pop err'),
      exception: exception,
      stackTrace: stackTrace,
    ).withAll(true);
    return false;
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(
      popResult,
      (SbPopResult quickPopResult) async {
        if (quickPopResult.popResultSelect == PopResultSelect.one) {
          final SingleResult<bool> deleteResult = await DataTransferManager.instance.transfer.executeSqliteCurd.deleteRow(
            modelTableName: currentFragmentModel.tableName,
            modelId: currentFragmentModel.get_id,
          );
          await deleteResult.handle<void>(
            onSuccess: (bool successResult) async {
              fatherRoute.sheetPageController.bodyData.remove(currentFragmentModel);
            },
            onError: (Object? exception, StackTrace? stackTrace) async {
              SbLogger(
                code: null,
                viewMessage: '删除失败！',
                data: null,
                description: Description('删除失败！'),
                exception: deleteResult.exception,
                stackTrace: deleteResult.stackTrace,
              );
            },
          );
          return true;
        }
        return false;
      },
    );
  }
}
