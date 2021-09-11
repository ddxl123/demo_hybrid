import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

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
    final SingleResult<MPnFragment> insertResult = await DataTransferManager.instance.executeSqliteCurd.insertRow<MPnFragment>(pnFragment);
    if (!insertResult.hasError) {
      newModel = insertResult.result!;
    } else {
      SbLogger(
        code: null,
        viewMessage: '添加失败！',
        data: null,
        description: null,
        exception: insertResult.exception,
        stackTrace: insertResult.stackTrace,
      );
    }
    return newModel == null ? null : PoolNodeModel.from(newModel);
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
    final SingleResult<MPnMemory> insertResult = await DataTransferManager.instance.executeSqliteCurd.insertRow<MPnMemory>(pnMemory);
    if (!insertResult.hasError) {
      newModel = insertResult.result!;
    } else {
      SbLogger(
        code: null,
        viewMessage: '添加失败！',
        data: null,
        description: null,
        exception: insertResult.exception,
        stackTrace: insertResult.stackTrace,
      );
    }
    return newModel == null ? null : PoolNodeModel.from(newModel);
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
    final SingleResult<MPnComplete> insertResult = await DataTransferManager.instance.executeSqliteCurd.insertRow<MPnComplete>(pnComplete);
    if (!insertResult.hasError) {
      newModel = insertResult.result!;
    } else {
      SbLogger(
        code: null,
        viewMessage: '添加失败！',
        data: null,
        description: null,
        exception: insertResult.exception,
        stackTrace: insertResult.stackTrace,
      );
    }
    return newModel == null ? null : PoolNodeModel.from(newModel);
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
    final SingleResult<MPnRule> insertResult = await DataTransferManager.instance.executeSqliteCurd.insertRow<MPnRule>(pnRule);
    if (!insertResult.hasError) {
      newModel = insertResult.result!;
    } else {
      SbLogger(
        code: null,
        viewMessage: '添加失败！',
        data: null,
        description: null,
        exception: insertResult.exception,
        stackTrace: insertResult.stackTrace,
      );
    }
    return newModel == null ? null : PoolNodeModel.from(newModel);
  }
}
