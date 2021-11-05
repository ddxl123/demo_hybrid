import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/MFRule.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/longpressedfragment/LongPressedFragment.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/more/AbstractMoreRoute.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/more/MoreRoute.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sheetroute/SbSheetRouteController.dart';

import 'AbstractNodeSheetRoute.dart';

class NodeSheetRouteForRule extends AbstractNodeSheetRoute<MFRule> {
  NodeSheetRouteForRule(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Future<void> bodyDataFuture(List<MFRule> bodyData, Mark mark) async {
    const int limit = 10;

    if (bodyData.isNotEmpty) {
      mark.value = bodyData.last.get_id!;
    } else {
      mark.value = 0;
    }
    final MFRule forKey = MFRule();
    final SingleResult<List<MFRule>> queryResult = await DataTransferManager.instance.transfer.executeSqliteCurd.queryRowsAsModels<MFRule>(
      QueryWrapper(
        tableName: forKey.tableName,
        limit: limit,
        offset: mark.value,
        byTwoId: TwoId(
          uuidKey: forKey.node_uuid,
          aiidKey: forKey.node_aiid,
          uuidValue: poolNodeModel.getCurrentNodeModel().get_uuid,
          aiidValue: poolNodeModel.getCurrentNodeModel().get_aiid,
        ),
      ),
    );
    await queryResult.handle<void>(
      doSuccess: (List<MFRule> successResult) async {
        bodyData.addAll(successResult);
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        SbLogger(
          c: null,
          vm: '获取失败！',
          data: null,
          descp: null,
          e: exception,
          st: stackTrace,
        );
      },
    );
  }

  @override
  void bodyDataException(Object? exception, StackTrace? stackTrace) {
    SbLogger(
      c: -1,
      vm: null,
      data: null,
      descp: null,
      e: exception,
      st: stackTrace,
    ).withAll(true);
  }

  @override
  Widget? bodyBuilder(BuildContext context, int index) => Container(
        color: Colors.white,
        child: SbButton(
          child: Text(sheetPageController.bodyData[index].get_title ?? ''),
          onLongPressed: (PointerDownEvent event) {
            SbHelper.getNavigator!.push(LongPressedFragmentForRule(this, sheetPageController.bodyData[index]));
          },
        ),
      );

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnRule>().get_title ?? 'unknown';

  @override
  AbstractMoreRoute<MFRule> get moreRoute => MoreRouteForRule(this);
}
