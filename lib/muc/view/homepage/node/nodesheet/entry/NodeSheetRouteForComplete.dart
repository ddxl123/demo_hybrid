
import 'package:flutter/material.dart';
import 'package:hybrid/data/sqlite/mmodel/MFComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
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

class NodeSheetRouteForComplete extends AbstractNodeSheetRoute<MFComplete> {
  NodeSheetRouteForComplete(PoolNodeModel poolNodeModel) : super(poolNodeModel);

  @override
  Future<void> bodyDataFuture(List<MFComplete> bodyData, Mark mark) async {
    const int limit = 10;

    if (bodyData.isNotEmpty) {
      mark.value = bodyData.last.get_id!;
    } else {
      mark.value = 0;
    }

    final MFComplete forKey = MFComplete();
    final List<MFComplete> models = await ModelManager.queryRowsAsModels(
      connectTransaction: null,
      tableName: forKey.tableName,
      limit: limit,
      offset: mark.value,
      byTwoId: TwoId(
        uuidKey: forKey.node_uuid,
        aiidKey: forKey.node_aiid,
        uuidValue: poolNodeModel.getCurrentNodeModel().get_uuid,
        aiidValue: poolNodeModel.getCurrentNodeModel().get_aiid,
      ),
    );
    bodyData.addAll(models);
  }

  @override
  void bodyDataException(Object? exception, StackTrace? stackTrace) {
    SbLogger(
      code: -1,
      viewMessage: null,
      data: null,
      description: null,
      exception: exception,
      stackTrace: stackTrace,
    ).withAll(true);
  }

  @override
  Widget? bodyBuilder(BuildContext context, int index) => Container(
        color: Colors.white,
        child: SbButton(
          child: Text(sheetPageController.bodyData[index].get_title ?? ''),
          onUp: (PointerUpEvent event) {
            final MFComplete model = sheetPageController.bodyData[index];
            SbHelper().getNavigator!.push(MaterialPageRoute<void>(builder: (_) => FragmentPage(model.get_fragment_aiid, model.get_fragment_uuid)));
          },
          onLongPressed: (PointerDownEvent event) {
            SbHelper().getNavigator!.push(LongPressedFragmentForComplete(this, sheetPageController.bodyData[index]));
          },
        ),
      );

  @override
  String get nodeTitle => poolNodeModel.getCurrentNodeModel<MPnComplete>().get_title ?? 'unknown';

  @override
  AbstractMoreRoute<MFComplete> get moreRoute => MoreRouteForComplete(this);
}
