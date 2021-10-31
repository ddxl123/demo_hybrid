import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxController.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HomePageGetController.dart';

enum PoolType {
  none,
  fragment,
  memory,
  complete,
  rule,
}

extension PoolTypeExt on PoolType {
  String get text {
    switch (index) {
      case 0:
        return 'none';
      case 1:
        return '碎片池';
      case 2:
        return '记忆池';
      case 3:
        return '完成池';
      case 4:
        return '记忆池';
      default:
        return 'err';
    }
  }
}

class PoolNodeModel {
  PoolNodeModel.from(ModelBase model) {
    switch (model.runtimeType) {
      case MPnFragment:
        _currentNodeModel = model;
        break;
      case MPnMemory:
        _currentNodeModel = model;
        break;
      case MPnComplete:
        _currentNodeModel = model;
        break;
      case MPnRule:
        _currentNodeModel = model;
        break;
      default:
        throw 'unknown model: $model';
    }
  }

  late ModelBase _currentNodeModel;

  /// 获取池节点模型，同时转换类型为当前池节点类型。
  ///
  /// [PNM] 池节点模型。
  PNM getCurrentNodeModel<PNM extends ModelBase>() {
    return _currentNodeModel as PNM;
  }
}

class PoolGetController extends GetxController {
  ///

  /// 当前碎片池类型。
  PoolType currentPoolType = PoolType.none;

  /// 当前碎片池的数据。
  final List<PoolNodeModel> currentPoolData = <PoolNodeModel>[];

  /// 全部池的【临时固定相机】。
  ///
  /// 当【临时固定相机】为空时，定位到【持久化存储的固定相机】，若【持久化存储的固定相机】为空时，定位到 zero；
  ///
  /// 当【临时固定相机】不为空时，优先定位到【临时固定相机】。
  final Map<PoolType, FreeBoxCamera> poolTempFixedCameras = <PoolType, FreeBoxCamera>{};

  @override
  void onReady() {
    super.onReady();
    // 初始化后进入默认池。
    to(PoolType.fragment);
  }

  /// 获取当前池的【临时相机】。
  FreeBoxCamera get getCurrentPoolTampFixedCamera {
    if (poolTempFixedCameras.containsKey(currentPoolType) && poolTempFixedCameras[currentPoolType] != null) {
      return poolTempFixedCameras[currentPoolType]!;
    }
    // TODO: 否则获取【持久化存储的固定相机】
    return FreeBoxCamera(easyPosition: Offset.zero, scale: 1);
  }

  T? select<T>({
    required PoolType fragmentPoolType,
    required T? fragmentPoolCallback(),
    required T? memoryPoolCallback(),
    required T? completePoolCallback(),
    required T? rulePoolCallback(),
  }) {
    switch (fragmentPoolType) {
      case PoolType.fragment:
        return fragmentPoolCallback();
      case PoolType.memory:
        return memoryPoolCallback();
      case PoolType.complete:
        return completePoolCallback();
      case PoolType.rule:
        return rulePoolCallback();
      default:
        throw 'unknown fragmentPoolType: $fragmentPoolType';
    }
  }

  Future<T?> selectFuture<T>({
    required PoolType fragmentPoolType,
    required Future<T?> fragmentPoolCallback(),
    required Future<T?> memoryPoolCallback(),
    required Future<T?> completePoolCallback(),
    required Future<T?> rulePoolCallback(),
  }) async {
    switch (fragmentPoolType) {
      case PoolType.fragment:
        return await fragmentPoolCallback();
      case PoolType.memory:
        return await memoryPoolCallback();
      case PoolType.complete:
        return await completePoolCallback();
      case PoolType.rule:
        return await rulePoolCallback();
      default:
        throw 'unknown fragmentPoolType: $fragmentPoolType';
    }
  }

  /// 跳转到指定碎片池。
  ///
  /// 若当前池就是 [toPoolType]，则会重新进入当前池。
  ///
  /// 若 [toPoolType] 为空则默认为当前池。
  Future<void> to([PoolType? toPoolType]) async {
    toPoolType ??= currentPoolType;

    // 设置 [toPoolType] 前的临时相机。
    final HomePageGetController homePageGetController = Get.find<HomePageGetController>();
    if (poolTempFixedCameras.containsKey(currentPoolType)) {
      /// 为什么临时存储的对象必须新建？因为可能还是引用的地址是控制器中的对象。
      poolTempFixedCameras[currentPoolType] = FreeBoxCamera(
        easyPosition: homePageGetController.sbFreeBoxController.freeBoxCamera.easyPosition,
        scale: homePageGetController.sbFreeBoxController.freeBoxCamera.scale,
      );
    } else {
      poolTempFixedCameras.addAll(<PoolType, FreeBoxCamera>{
        currentPoolType: FreeBoxCamera(
          easyPosition: homePageGetController.sbFreeBoxController.freeBoxCamera.easyPosition,
          scale: homePageGetController.sbFreeBoxController.freeBoxCamera.scale,
        )
      });
    }

    // 设置 [currentPoolData]。
    currentPoolData.clear();
    currentPoolData.addAll(await queryAll(toPoolType));

    // 全部成功后，设置 [currentPoolType]。
    currentPoolType = toPoolType;

    // to [getCurrentPoolTampFixedCamera]
    homePageGetController.sbFreeBoxController.targetSlide(targetCamera: getCurrentPoolTampFixedCamera, rightNow: true);

    // setState 池。
    update();
  }

  Future<List<PoolNodeModel>> queryAll(PoolType poolType) async {
    Future<List<ModelBase>> query(String tableName) async {
      final SingleResult<List<ModelBase>> queryResult =
          await DataTransferManager.instance.transfer.executeSqliteCurd.queryRowsAsModels(QueryWrapper(tableName: tableName));
      return await queryResult.handle<List<ModelBase>>(
        onSuccess: (List<ModelBase> successResult) async {
          return successResult;
        },
        onError: (Object? exception, StackTrace? stackTrace) async {
          SbLogger(
            c: null,
            vm: '加载数据失败！',
            data: null,
            descp: Description('读取数据时发生异常'),
            e: queryResult.exception,
            st: queryResult.stackTrace,
          ).withToast(false);
          return <ModelBase>[];
        },
      );
    }

    @override
    List<PoolNodeModel> froms(List<ModelBase> models) {
      final List<PoolNodeModel> poolNodeModels = <PoolNodeModel>[];
      for (final ModelBase model in models) {
        // 必须用类调用来构建新对象。
        poolNodeModels.add(PoolNodeModel.from(model));
      }
      return poolNodeModels;
    }

    return (await selectFuture<List<PoolNodeModel>>(
          fragmentPoolType: poolType,
          fragmentPoolCallback: () async {
            return froms(await query(MPnFragment().tableName));
          },
          memoryPoolCallback: () async {
            return froms(await query(MPnMemory().tableName));
          },
          completePoolCallback: () async {
            return froms(await query(MPnComplete().tableName));
          },
          rulePoolCallback: () async {
            return froms(await query(MPnRule().tableName));
          },
        )) ??
        <PoolNodeModel>[];
  }

  /// 给当前池添加新节点。
  void insertNewNode(PoolNodeModel poolNodeModel) {
    currentPoolData.add(poolNodeModel);
    update();
  }

  /// 删除当前池的指定节点。
  Future<void> deleteNode(PoolNodeModel poolNodeModel) async {
    currentPoolData.removeWhere((PoolNodeModel element) => element == poolNodeModel);
    update();
  }

  ///
}
