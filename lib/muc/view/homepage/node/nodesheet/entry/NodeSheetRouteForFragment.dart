import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/MFFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/fragment/FragmentPage.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/longpressedfragment/LongPressedFragment.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/more/AbstractMoreRoute.dart';
import 'package:hybrid/muc/view/homepage/node/nodesheet/more/MoreRoute.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sheetroute/SbSheetRouteController.dart';

import 'AbstractNodeSheetRoute.dart';

class NodeSheetRouteForFragment extends AbstractNodeSheetRoute<MFFragment> {
  NodeSheetRouteForFragment(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Future<void> bodyDataFuture(List<MFFragment> bodyData, Mark mark) async {
    const int limit = 10;

    if (bodyData.isNotEmpty) {
      mark.value = bodyData.last.get_id!;
    } else {
      mark.value = 0;
    }

    final MFFragment forKey = MFFragment();
    final SingleResult<List<MFFragment>> queryResult = await DataTransferManager.instance.transferTool.executeSqliteCurd.queryRowsAsModels<MFFragment>(
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
      doSuccess: (List<MFFragment> successResult) async {
        bodyData.addAll(successResult);
      },
      doError: (SingleResult<List<MFFragment>> errorResult) async {
        SbLogger(
          c: null,
          vm: errorResult.getRequiredVm(),
          data: null,
          descp: errorResult.getRequiredDescp(),
          e: errorResult.getRequiredE(),
          st: errorResult.stackTrace,
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
          onUp: (PointerUpEvent event) async {
            final MFFragment model = sheetPageController.bodyData[index];
            SbHelper.getNavigator!.push(MaterialPageRoute<void>(builder: (_) => FragmentPage(model.get_aiid, model.get_uuid)));
          },
          onLongPressed: (PointerDownEvent event) {
            SbHelper.getNavigator!.push(LongPressedFragmentForFragment(this, sheetPageController.bodyData[index]));
          },
        ),
      );

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnFragment>().get_title ?? 'unknown';

  @override
  AbstractMoreRoute<MFFragment> get moreRoute => MoreRouteForFragment(this);
}
