import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/muc/update/homepage/PoolUpdate.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxController.dart';

import '../GetControllerBase.dart';

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

class PoolGetController extends GetControllerBase<PoolGetController, PoolUpdate> {
  ///

  PoolGetController() : super(PoolUpdate());

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
    updateLogic.to(PoolType.fragment);
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

  ///
}
