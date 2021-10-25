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

abstract class AbstractMoreRoute<FDM extends ModelBase> extends AbstractPoolEntryRoute {
  AbstractMoreRoute(this.fatherRoute) : super(fatherRoute.poolNodeModel);

  late final AbstractNodeSheetRoute<FDM> fatherRoute;

  @override
  List<Widget> body() {
    return <Widget>[
      AutoPositioned(
        child: SbRoundedBox(
          children: <Widget>[
            TextButton(
              child: const Text('添加碎片'),
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
      description: null,
      exception: exception,
      stackTrace: stackTrace,
    ).withAll(true);
    return true;
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    return await quickWhenPop(
      popResult,
      (SbPopResult quickPopResult) async {
        if (quickPopResult.popResultSelect == PopResultSelect.one) {
          final SingleResult<FDM> insertResult = await DataTransferManager.instance.transfer.executeSqliteCurd.insertRow(insertModel);
          await insertResult.handle<void>(
            onSuccess: (FDM successResult) async {
              fatherRoute.sheetPageController.bodyData.add(successResult);
            },
            onError: (Object? exception, StackTrace? stackTrace) async {
              SbLogger(
                code: null,
                viewMessage: '添加失败！',
                data: null,
                description: Description('添加失败！'),
                exception: insertResult.exception,
                stackTrace: insertResult.stackTrace,
              );
            },
          );
          return true;
        }
        return false;
      },
    );
  }

  /// 创建新碎片需要的模型。
  FDM get insertModel;
}
