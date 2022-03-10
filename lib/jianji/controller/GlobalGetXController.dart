import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FolderListPage.dart';
import 'package:hybrid/jianji/controller/FragmentMemoryListPageGetXController.dart';
import 'package:hybrid/jianji/controller/JianJiHomeGetXController.dart';

class GlobalGetXController extends GetxController {
  ///

  /// 0 --- 无模式。
  /// 1 --- 成组模式。
  /// 2 --- 记忆模式。
  /// 分别对应 [SelectModel.index]。
  RxInt selectModel = 0.obs;

  /// 是否正在记忆。
  RxBool isRemembering = false.obs;

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

  Future<void> writeRemembers() async {
    // 记忆模式下，获取全部的已选记忆组。
    final mgs = await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForMemoryModel.keys);
    // 记忆模式下，整理并获取每个已选记忆组的全部记忆知识点。
    final rs = await DriftDb.instance.retrieveDAO.getMemoryGroup2FragmentsByTidyUpForRemember(mgs);
    // 插入已获取的全部记忆知识点。
    await DriftDb.instance.insertDAO.insertRemembers(rs);
    changeSelectModelToNone();
    isRemembering.value = true;
  }

  Future<void> writeSelectedManyForGroupModelToRemember() async {
    final List<int> ids = getAllSelectedFragmentIdsForGroupModel();
    final List<Fragment> frgs = await DriftDb.instance.retrieveDAO.getFragmentsByIsIn(ids);
    await DriftDb.instance.insertDAO.insertRemembers(frgs);
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
              actions: () {
                if (isRemembering.value) {
                  return <SheetAction<int>>[
                    const SheetAction(key: 3, label: '添加到正在执行的记忆任务中', isDestructiveAction: true),
                    const SheetAction(key: 2, label: '清空已选知识点', isDestructiveAction: true),
                    const SheetAction(key: 1, label: '成组', isDestructiveAction: true),
                    const SheetAction(key: 0, label: '退出成组模式'),
                  ];
                } else {
                  return <SheetAction<int>>[
                    const SheetAction(key: 2, label: '清空已选知识点', isDestructiveAction: true),
                    const SheetAction(key: 1, label: '成组', isDestructiveAction: true),
                    const SheetAction(key: 0, label: '退出成组模式'),
                  ];
                }
              }(),
              title: '',
              message: '已选知识点数量 ${selectedCountForGroupModel.value}',
              cancelLabel: '取消',
            );
            if (result == 0) {
              changeSelectModelToNone();
              EasyLoading.showToast('已退出成组模式！');
            } else if (result == 1) {
              void toPage(int index) {
                final JianJiHomeGetXController jianJiHomeGetXController = Get.find<JianJiHomeGetXController>();
                if (index == 0) {
                  jianJiHomeGetXController.animateToPage0();
                } else if (index == 1) {
                  jianJiHomeGetXController.animateToPage1();
                } else {
                  throw '未知 index: $index';
                }
                Get.back();
              }

              final message = await () async {
                final List<MemoryGroup> getInResult = await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForGroupModel);
                return getInResult.map((e) => e.title).join('\n');
              }();

              if (selectedCountForGroupModel.value == 0) {
                EasyLoading.showToast('未选择知识点\n请在知识类别中选择（点击右侧圆圈）', duration: const Duration(seconds: 5));
              } else {
                if (selectedMemoryGroupsForGroupModel.isEmpty) {
                  final OkCancelResult noSelectedMemoryGroupResult = await showOkCancelAlertDialog(
                    context: context,
                    message: '还没有选择记忆组,\n请在记忆组中进行选择！',
                    isDestructiveAction: true,
                    okLabel: '选择记忆组',
                    cancelLabel: '返回',
                  );
                  if (noSelectedMemoryGroupResult == OkCancelResult.ok) {
                    toPage(1);
                  }
                } else {
                  final int? doGroupResult = await showAlertDialog<int?>(
                    context: context,
                    message: message,
                    title: '是否将已选知识点（${selectedCountForGroupModel.value}个），\n添加到下列的记忆组中？',
                    actions: <AlertDialogAction<int?>>[
                      const AlertDialogAction(key: 0, label: '选择记忆组'),
                      const AlertDialogAction(key: 1, label: '选择知识点'),
                      const AlertDialogAction(key: 2, label: '确认添加', isDestructiveAction: true),
                    ],
                  );
                  if (doGroupResult == 0) {
                    toPage(1);
                  } else if (doGroupResult == 1) {
                    toPage(0);
                  } else {
                    EasyLoading.show(status: '添加中...');
                    await DriftDb.instance.insertDAO.insertMemoryGroup2Fragments(
                      forMemoryGroups: await DriftDb.instance.retrieveDAO.getMemoryGroupsByIsIn(selectedMemoryGroupsForGroupModel),
                      forFragments: await DriftDb.instance.retrieveDAO.getFragmentsByIsIn(getAllSelectedFragmentIdsForGroupModel()),
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
            } else if (result == 3) {
              if (selectedCountForGroupModel.value == 0) {
                EasyLoading.showToast('没有可添加项！');
              } else {
                final isOk = await showOkCancelAlertDialog(
                  context: context,
                  message: '确认添加到正在执行的记忆任务中？',
                  okLabel: '确认',
                  cancelLabel: '取消',
                  isDestructiveAction: true,
                );
                if (isOk == OkCancelResult.ok) {
                  EasyLoading.showToast('正在添加...');
                  await writeSelectedManyForGroupModelToRemember();
                  EasyLoading.showToast('已添加成功！');
                }
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

  @override
  void onReady() {
    DriftDb.instance.retrieveDAO.getCurrentStatus().then(
      (value) {
        addLog('getCurrentStatus: ${value.toString()}');
        if (value == null) {
          isRemembering.value = false;
        } else {
          isRemembering.value = true;
          selectModel.value = value.status;
        }
        refresh();
      },
    );
  }
}
