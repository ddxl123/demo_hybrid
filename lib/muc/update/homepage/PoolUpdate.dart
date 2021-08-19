
import 'package:get/get.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnComplete.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnFragment.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnMemory.dart';
import 'package:hybrid/data/sqlite/mmodel/MPnRule.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/muc/getcontroller/homepage/HomePageGetController.dart';
import 'package:hybrid/muc/getcontroller/homepage/PoolGetController.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxController.dart';

import '../UpdateBase.dart';

class PoolUpdate extends UpdateBase<PoolGetController> {
  /// 跳转到指定碎片池。
  ///
  /// 若当前池就是 [toPoolType]，则会重新进入当前池。
  ///
  /// 若 [toPoolType] 为空则默认为当前池。
  Future<void> to([PoolType? toPoolType]) async {
    toPoolType ??= getxController.currentPoolType;

    // 设置 [toPoolType] 前的临时相机。
    final HomePageGetController homePageGetController = Get.find<HomePageGetController>();
    if (getxController.poolTempFixedCameras.containsKey(getxController.currentPoolType)) {
      /// 为什么临时存储的对象必须新建？因为可能还是引用的地址是控制器中的对象。
      getxController.poolTempFixedCameras[getxController.currentPoolType] = FreeBoxCamera(
        easyPosition: homePageGetController.sbFreeBoxController.freeBoxCamera.easyPosition,
        scale: homePageGetController.sbFreeBoxController.freeBoxCamera.scale,
      );
    } else {
      getxController.poolTempFixedCameras.addAll(<PoolType, FreeBoxCamera>{
        getxController.currentPoolType: FreeBoxCamera(
          easyPosition: homePageGetController.sbFreeBoxController.freeBoxCamera.easyPosition,
          scale: homePageGetController.sbFreeBoxController.freeBoxCamera.scale,
        )
      });
    }

    // 设置 [currentPoolData]。
    getxController.currentPoolData.clear();
    getxController.currentPoolData.addAll(await queryAll(toPoolType));

    // 全部成功后，设置 [currentPoolType]。
    getxController.currentPoolType = toPoolType;

    // to [getCurrentPoolTampFixedCamera]
    homePageGetController.sbFreeBoxController.targetSlide(targetCamera: getxController.getCurrentPoolTampFixedCamera, rightNow: true);

    // setState 池。
    getxController.update();
  }

  Future<List<PoolNodeModel>> queryAll(PoolType poolType) async {
    Future<List<ModelBase>> query(String tableName) async {
      return await ModelManager.queryRowsAsModels(connectTransaction: null, tableName: tableName);
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

    return (await getxController.selectFuture<List<PoolNodeModel>>(
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
    getxController.currentPoolData.add(poolNodeModel);
    getxController.update();
  }

  /// 删除当前池的指定节点。
  Future<void> deleteNode(PoolNodeModel poolNodeModel) async {
    getxController.currentPoolData.removeWhere((PoolNodeModel element) => element == poolNodeModel);
    getxController.update();
  }
}
