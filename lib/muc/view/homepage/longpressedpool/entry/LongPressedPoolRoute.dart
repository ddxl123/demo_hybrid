import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
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
    final SingleResult<MPnFragment> insertResult = await TransferManager.instance.transferExecutor.executeSqliteCurd.insertRow<MPnFragment>(pnFragment);
    await insertResult.handle<void>(
      doSuccess: (MPnFragment successResult) async {
        newModel = successResult;
      },
      doError: (SingleResult<MPnFragment> errorResult) async {
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
    final SingleResult<MPnMemory> insertResult = await TransferManager.instance.transferExecutor.executeSqliteCurd.insertRow<MPnMemory>(pnMemory);
    await insertResult.handle<void>(
      doSuccess: (MPnMemory successResult) async {
        newModel = successResult;
      },
      doError: (SingleResult<MPnMemory> errorResult) async {
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
    final SingleResult<MPnComplete> insertResult = await TransferManager.instance.transferExecutor.executeSqliteCurd.insertRow<MPnComplete>(pnComplete);
    await insertResult.handle<void>(
      doSuccess: (MPnComplete successResult) async {
        newModel = successResult;
      },
      doError: (SingleResult<MPnComplete> errorResult) async {
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
    final SingleResult<MPnRule> insertResult = await TransferManager.instance.transferExecutor.executeSqliteCurd.insertRow<MPnRule>(pnRule);
    await insertResult.handle<void>(
      doSuccess: (MPnRule successResult) async {
        newModel = successResult;
      },
      doError: (SingleResult<MPnRule> errorResult) async {
        SbLogger(
          c: null,
          vm: '添加失败！',
          data: null,
          descp: null,
          e: errorResult.getRequiredE(),
          st: errorResult.stackTrace,
        );
      },
    );
    return newModel == null ? null : PoolNodeModel.from(newModel!);
  }
}
