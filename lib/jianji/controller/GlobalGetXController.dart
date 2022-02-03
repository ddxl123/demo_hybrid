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

  /// 成组模式下，当前已选的知识点。第一个 key 为 folder_id，第二个 key 为 fragment_id。
  final RxMap<int, RxMap<int, void>> selectedsForGroupModel = <int, RxMap<int, void>>{}.obs;

  /// 成组模式下，当前即将添加知识点的已选记忆组。值为 [MemoryGroup.id]
  final RxSet<int> selectedMemoryGroupsForGroupModel = <int>{}.obs;

  /// 成组模式下，当前已选择的记忆组数量。
  /// 不直接使用 [selectedsForGroupModel.length]，而使用 [selectedCountForGroupModel] 的原因是：
  ///   - [selectedsForGroupModel] 中的 values 才是 count。
  RxInt selectedCountForGroupModel = 0.obs;

  /// 记忆模式下，当前已选择的记忆知识点。key 为 memoryGroup_id，value 为该 memoryGroup 内的 MemoryGroup2Fragment 数量。
  final RxMap<int, int> selectedMemoryGroupsForMemoryModel = <int, int>{}.obs;

  /// 记忆模式下，当前已选择的记忆知识点数量。
  /// 不直接使用 [selectedMemoryGroupsForMemoryModel.length]，而使用 [selectedCountForMemoryModel] 的原因是：
  ///   - [selectedMemoryGroupsForMemoryModel] 中的 values 的总计量才是 count。
  RxInt selectedCountForMemoryModel = 0.obs;

  bool isNoneModel() => selectModel.value == 0;

  bool isGroupModel() => selectModel.value == 1;

  bool isMemoryModel() => selectModel.value == 2;

  void changeSelectModelToNone() => selectModel.value = 0;

  void changeSelectModelToGroup() => selectModel.value = 1;

  void changeSelectModelToMemory() => selectModel.value = 2;

  bool isSelectedForGroupModel(Folder forFolder, Fragment forFragment) {
    return selectedsForGroupModel.containsKey(forFolder.id) && selectedsForGroupModel[forFolder.id]!.containsKey(forFragment.id);
  }

  /// 获取 [selectedsForGroupModel] 全部的 [Fragment.id]。
  List<int> getAllSelectedFragmentIdsForGroupModel() {
    final Map<int, void> fragmentIdMap = <int, void>{};
    selectedsForGroupModel.forEach(
      (key, value) {
        fragmentIdMap.addAll(value);
      },
    );
    return fragmentIdMap.keys.toList();
  }

  void addSelectedSingleForGroupModel(Folder forFolder, Fragment forFragment) {
    if (selectedsForGroupModel.containsKey(forFolder.id)) {
      selectedsForGroupModel[forFolder.id]!.addAll(<int, void>{forFragment.id: null});
    } else {
      selectedsForGroupModel.addAll(
        <int, RxMap<int, void>>{
          forFolder.id: RxMap(<int, void>{forFragment.id: null})
        },
      );
    }
    selectedCountForGroupModel.value += 1;
    refresh();
  }

  Future<void> addSelectedAllForGroupModel(Folder forFolder) async {
    final ids = await DriftDb.instance.retrieveDAO.getFolder2FragmentsIds(forFolder);
    if (!selectedsForGroupModel.containsKey(forFolder.id)) {
      selectedsForGroupModel.addAll(<int, RxMap<int, void>>{forFolder.id: RxMap(<int, void>{})});
    }
    for (var value in ids) {
      selectedsForGroupModel[forFolder.id]!.addAll(<int, void>{value: null});
    }
    selectedCountForGroupModel.value += ids.length;
    refresh();
  }

  void cancelSelectedSingleForGroupModel(Folder forFolder, Fragment forFragment) {
    final selectedFolder = selectedsForGroupModel[forFolder.id];
    if (selectedFolder != null) {
      if (selectedFolder.containsKey(forFragment.id)) {
        selectedFolder.remove(forFragment.id);
        selectedCountForGroupModel.value -= 1;
      }
      if (selectedFolder.isEmpty) {
        selectedsForGroupModel.remove(forFolder.id);
      }
    }
    refresh();
  }

  void cancelSelectedManyForGroupModel(Folder forFolder) {
    selectedCountForGroupModel -= selectedsForGroupModel[forFolder.id]?.length ?? 0;
    selectedsForGroupModel.remove(forFolder.id);
    refresh();
  }

  void cancelSelectedAllForGroupModel() {
    selectedsForGroupModel.clear();
    selectedCountForGroupModel.value = 0;
  }

  void addSelectedSingleForMemoryModel(MemoryGroup forMemoryGroup, int forCount) {
    selectedMemoryGroupsForMemoryModel.addAll({forMemoryGroup.id: forCount});
    selectedCountForMemoryModel.value += forCount;
  }

  void cancelSelectedSingleForMemoryModel(MemoryGroup forMemoryGroup, int forCount) {
    selectedMemoryGroupsForMemoryModel.remove(forMemoryGroup.id);
    selectedCountForMemoryModel.value -= forCount;
  }

  void cancelSelectedAllForMemoryModel() {
    selectedMemoryGroupsForMemoryModel.clear();
    selectedCountForMemoryModel.value = 0;
  }

  Widget groupModelFloatingButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 20, 60),
      child: FloatingActionButton(
        backgroundColor: Colors.orange,
        heroTag: Object().hashCode.toString(),
        child: Obx(
          () => Text(isGroupModel() ? selectedCountForGroupModel.value.toString() : '成组'),
        ),
        onPressed: () async {
          if (isGroupModel()) {
            final int? result = await showModalActionSheet(
              context: context,
              actions: <SheetAction<int>>[
                const SheetAction(key: 2, label: '清空已选知识点', isDestructiveAction: true),
                const SheetAction(key: 1, label: '成组', isDestructiveAction: true),
                const SheetAction(key: 0, label: '退出成组模式'),
              ],
              title: '',
              message: '已选知识点数量 ${selectedCountForGroupModel.value}',
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
                final List<MemoryGroup> getInResult = await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForGroupModel);
                return getInResult.map((e) => e.title).join('\n');
              }();

              final int? doGroupResult = await showAlertDialog<int?>(
                context: context,
                message: message,
                title: '是否将已选知识点（${selectedCountForGroupModel.value}个），\n添加到下列的记忆组中？',
                actions: <AlertDialogAction<int?>>[
                  const AlertDialogAction(key: 0, label: '清空已选记忆组'),
                  const AlertDialogAction(key: 1, label: '选择记忆组'),
                  const AlertDialogAction(key: 2, label: '确认添加', isDestructiveAction: true),
                ],
              );
              if (doGroupResult == 2) {
                if (selectedCountForGroupModel.value == 0) {
                  EasyLoading.showToast('未选择知识点\n请在 知识类别 中选择（点击右侧圆圈）', duration: const Duration(seconds: 5));
                } else {
                  if (selectedMemoryGroupsForGroupModel.isEmpty) {
                    EasyLoading.showToast('请选择记忆组\n请在 记忆组页面 中选择（点击右侧圆圈）');
                    toPage1();
                  } else {
                    EasyLoading.show(status: '添加中...');

                    await DriftDb.instance.insertDAO.insertMemoryGroup2Fragments(
                      memoryGroups: await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForGroupModel),
                      fragments: await DriftDb.instance.retrieveDAO.getFragmentsByIsIn(getAllSelectedFragmentIdsForGroupModel()),
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
            } else if (result == 2) {
              final isOk = await showOkCancelAlertDialog(
                context: context,
                message: '确认清空已选知识点？',
                okLabel: '确认清空',
                cancelLabel: '取消',
                isDestructiveAction: true,
              );
              if (isOk == OkCancelResult.ok) {
                cancelSelectedAllForGroupModel();
                EasyLoading.showToast('清空成功！');
              }
            }
          } else {
            changeSelectModelToGroup();
            EasyLoading.showToast('已切换成组模式！');
          }
        },
      ),
    );
  }
}
