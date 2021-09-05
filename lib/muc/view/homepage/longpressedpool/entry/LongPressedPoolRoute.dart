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
  Future<PoolNodeModel?> createNewNode(String easyPosition) async {
    final MPnFragment pnFragment = MPnFragment.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper.newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper.randomString(10),
      rule_aiid: null,
      rule_uuid: null,
    );
    MPnFragment? newModel;
    await SqliteCurd.insertRow<MPnFragment>(
      model: pnFragment,
      transactionMark: null,
      onSuccess: (MPnFragment nm) async {
        newModel = nm;
      },
      onError: (Object? exception, StackTrace? stackTrace) async {},
    );
    return newModel == null ? null : PoolNodeModel.from(newModel!);
  }
}

class LongPressedPoolRouteForMemory extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel?> createNewNode(String easyPosition) async {
    final MPnMemory pnMemory = MPnMemory.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper.newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper.randomString(10),
      rule_aiid: null,
      rule_uuid: null,
    );

    MPnMemory? newModel;
    await SqliteCurd.insertRow<MPnMemory>(
      model: pnMemory,
      transactionMark: null,
      onSuccess: (MPnMemory nm) async {
        newModel = nm;
      },
      onError: (Object? exception, StackTrace? stackTrace) async {},
    );
    return newModel == null ? null : PoolNodeModel.from(newModel!);
  }
}

class LongPressedPoolRouteForComplete extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel?> createNewNode(String easyPosition) async {
    final MPnComplete pnComplete = MPnComplete.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper.newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper.randomString(10),
      rule_aiid: null,
      rule_uuid: null,
    );

    MPnComplete? newModel;
    await SqliteCurd.insertRow<MPnComplete>(
      model: pnComplete,
      transactionMark: null,
      onSuccess: (MPnComplete nm) async {
        newModel = nm;
      },
      onError: (Object? exception, StackTrace? stackTrace) async {},
    );
    return newModel == null ? null : PoolNodeModel.from(newModel!);
  }
}

class LongPressedPoolRouteForRule extends AbstractLongPressedPoolRoute {
  @override
  Future<PoolNodeModel?> createNewNode(String easyPosition) async {
    final MPnRule pnRule = MPnRule.createModel(
      id: null,
      aiid: null,
      uuid: SbHelper.newUuid,
      created_at: null,
      updated_at: null,
      easy_position: easyPosition,
      title: SbHelper.randomString(10),
    );

    MPnRule? newModel;
    await SqliteCurd.insertRow<MPnRule>(
      model: pnRule,
      transactionMark: null,
      onSuccess: (MPnRule nm) async {
        newModel = nm;
      },
      onError: (Object? exception, StackTrace? stackTrace) async {},
    );
    return newModel == null ? null : PoolNodeModel.from(newModel!);
  }
}
