


import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/util/SbHelper.dart';

import 'AbstractLongPressedPoolRoute.dart';

class LongPressedPoolRouteForFragment extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel> createNewNode(String easyPosition) async {
    final MPnFragment pnFragment = MPnFragment.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper().newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper().randomString(10),
      rule_aiid: null,
      rule_uuid: null,
    );
    final MPnFragment newModel = await SqliteCurd<MPnFragment>().insertRow(model: pnFragment, transactionMark: null);
    return PoolNodeModel.from(newModel);
  }
}

class LongPressedPoolRouteForMemory extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel> createNewNode(String easyPosition) async {
    final MPnMemory pnMemory = MPnMemory.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper().newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper().randomString(10),
      rule_aiid: null,
      rule_uuid: null,
    );
    final MPnMemory newModel = await SqliteCurd<MPnMemory>().insertRow(model: pnMemory, transactionMark: null);
    return PoolNodeModel.from(newModel);
  }
}

class LongPressedPoolRouteForComplete extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel> createNewNode(String easyPosition) async {
    final MPnComplete pnComplete = MPnComplete.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper().newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper().randomString(10),
      rule_aiid: null,
      rule_uuid: null,
    );
    final MPnComplete newModel = await SqliteCurd<MPnComplete>().insertRow(model: pnComplete, transactionMark: null);
    return PoolNodeModel.from(newModel);
  }
}

class LongPressedPoolRouteForRule extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel> createNewNode(String easyPosition) async {
    final MPnRule pnRule = MPnRule.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper().newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper().randomString(10),
    );
    final MPnRule newModel = await SqliteCurd<MPnRule>().insertRow(model: pnRule, transactionMark: null);
    return PoolNodeModel.from(newModel);
  }
}
