import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/FragmentMemoryListPageGetXController.dart';
import 'package:hybrid/jianji/controller/JianJiHomeGetXController.dart';

class GlobalGetXController extends GetxController {
  ///

  /// 0 --- 无模式。
  /// 1 --- 成组模式。
  /// 2 --- 记忆模式。
  /// 分别对应 [SelectModel.index]。
  RxInt selectModel = 0.obs;

  /// 当前已选知识点。第一个 key 为 folder_id，第二个 key 为 fragment_id。
  final RxMap<int, Map<int, void>> selectedsForGroupModel = <int, Map<int, void>>{}.obs;

  /// 当前即将添加知识点的已选记忆组。值为 [MemoryGroup.id]
  final RxSet<int> selectedMemoryGroupsForGroupModel = <int>{}.obs;

  /// 不直接使用 [selectedsForGroupModel.length]，而使用 [selectedCount] 的原因是：
  ///   - [selectedsForGroupModel] 中的 values 才是 count。
  RxInt selectedCount = 0.obs;

  bool isNoneModel() => selectModel.value == 0;

  bool isGroupModel() => selectModel.value == 1;

  bool isMemoryModel() => selectModel.value == 2;

  void changeSelectModelToNone() => selectModel.value = 0;

  void changeSelectModelToGroup() => selectModel.value = 1;

  void changeSelectModelToMemory() => selectModel.value = 2;

  bool isSelectedForGroupModel(Folder folder, Fragment fragment) {
    return selectedsForGroupModel.containsKey(folder.id) && selectedsForGroupModel[folder.id]!.containsKey(fragment.id);
  }

  /// 获取 [selectedsForGroupModel] 全部的 [Fragment.id]。
  List<int> getAllSelectedFragmentIdForGroupModel() {
    final Map<int, void> fragmentIdMap = <int, void>{};
    selectedsForGroupModel.forEach(
      (key, value) {
        fragmentIdMap.addAll(value);
      },
    );
    return fragmentIdMap.keys.toList();
  }

  void addSelectedForGroupModel(Folder folder, Fragment fragment) {
    if (selectedsForGroupModel.containsKey(folder.id)) {
      selectedsForGroupModel[folder.id]!.addAll(<int, void>{fragment.id: null});
    } else {
      selectedsForGroupModel.addAll(
        <int, Map<int, void>>{
          folder.id: <int, void>{fragment.id: null}
        },
      );
    }
    selectedCount += 1;
    selectedsForGroupModel.refresh();
  }

  void cancelSelectedForGroupModel(Folder folder, Fragment fragment) {
    final selectedFolder = selectedsForGroupModel[folder.id];
    if (selectedFolder != null) {
      if (selectedFolder.containsKey(fragment.id)) {
        selectedFolder.remove(fragment.id);
        selectedCount -= 1;
        selectedsForGroupModel.refresh();
      }
      if (selectedFolder.isEmpty) {
        selectedsForGroupModel.remove(folder.id);
      }
    }
  }

  void cancelSelectedManyForGroupModel(Folder folder) {
    selectedCount -= selectedsForGroupModel[folder.id]?.length ?? 0;
    selectedsForGroupModel.remove(folder.id);
    selectedsForGroupModel.refresh();
  }

  void cancelSelectedAllForGroupModel() {
    final fragmentsResult = <int, void>{};
    selectedsForGroupModel.forEach(
      (key, value) {
        fragmentsResult.addAll(value);
      },
    );
    selectedCount -= fragmentsResult.length;
    selectedsForGroupModel.clear();
    selectedsForGroupModel.refresh();
  }

  Widget groupModelFloatingButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.orange,
      heroTag: Object().hashCode.toString(),
      child: Obx(
        () => Text(isGroupModel() ? selectedCount.value.toString() : '成组'),
      ),
      onPressed: () async {
        if (isGroupModel()) {
          final int? result = await showModalActionSheet(
            context: context,
            actions: <SheetAction<int>>[
              const SheetAction(key: 1, label: '成组', isDestructiveAction: true),
              const SheetAction(key: 0, label: '退出成组模式'),
            ],
            title: '',
            message: '已选知识点数量 ${selectedCount.value}',
            cancelLabel: '取消',
          );
          if (result == 0) {
            changeSelectModelToNone();
            EasyLoading.showToast('已退出成组模式！');
          } else if (result == 1) {
            void toPage1() {
              final JianJiHomeGetXController jianJiHomeGetXController = Get.find<JianJiHomeGetXController>();
              jianJiHomeGetXController.animateToPage1();
              Get.back();
            }

            final message = await () async {
              final List<MemoryGroup> getInResult = await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForGroupModel.toSet());
              return getInResult.map((e) => e.title).join('\n');
            }();

            final int? doGroupResult = await showAlertDialog<int?>(
              context: context,
              message: message,
              title: '是否将已选知识点（${selectedCount.value}个），\n添加到下列的记忆组中？',
              actions: <AlertDialogAction<int?>>[
                const AlertDialogAction(key: 0, label: '清空已选记忆组'),
                const AlertDialogAction(key: 1, label: '选择记忆组'),
                const AlertDialogAction(key: 2, label: '确认添加', isDestructiveAction: true),
              ],
            );
            if (doGroupResult == 2) {
              if (selectedCount.value == 0) {
                EasyLoading.showToast('未选择知识点\n请在 知识类别 中选择（点击右侧圆圈）', duration: const Duration(seconds: 5));
              } else {
                if (selectedMemoryGroupsForGroupModel.isEmpty) {
                  EasyLoading.showToast('请选择记忆组\n请在 记忆组页面 中选择（点击右侧圆圈）');
                  toPage1();
                } else {
                  EasyLoading.show(status: '添加中...');

                  await DriftDb.instance.insertDAO.insertMemoryGroup2Fragments(
                    memoryGroups: await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForGroupModel.toSet()),
                    fragments: await DriftDb.instance.retrieveDAO.getFragmentsByIsIn(getAllSelectedFragmentIdForGroupModel()),
                    filtered: (MemoryGroup filteredMemoryGroup, List<Fragment> filteredFragments) async {
                      final FragmentMemoryListPageGetXController fragmentMemoryListPageGetXController =
                          Get.find<FragmentMemoryListPageGetXController>(tag: filteredMemoryGroup.hashCode.toString());
                      fragmentMemoryListPageGetXController.serializeFragmentMemorysCount.value += filteredFragments.length;
                    },
                  );

                  cancelSelectedAllForGroupModel();
                  selectedMemoryGroupsForGroupModel.clear();
                  changeSelectModelToNone();
                  EasyLoading.showSuccess('添加成功！');
                }
              }
            } else if (doGroupResult == 1) {
              toPage1();
            } else if (doGroupResult == 0) {
              selectedMemoryGroupsForGroupModel.clear();
              EasyLoading.showToast('清空已选记忆组成功！');
            }
          }
        } else {
          changeSelectModelToGroup();
          EasyLoading.showToast('已切换成组模式！');
        }
      },
    );
  }
}
