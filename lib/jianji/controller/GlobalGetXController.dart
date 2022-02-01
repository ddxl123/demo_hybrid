import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';

class GlobalGetXController extends GetxController {
  /// 当前是否为选择模式。
  RxBool isSelectModel = false.obs;

  /// 当前已选。第一个 key 为 folder_id，第二个 key 为 fragment_id。
  final RxMap<int, Map<int, void>> selecteds = <int, Map<int, void>>{}.obs;

  RxInt selectedCount = 0.obs;

  bool isSelected(Folder folder, Fragment fragment) {
    return selecteds.containsKey(folder.id) && selecteds[folder.id]!.containsKey(fragment.id);
  }

  void addSelected(Folder folder, Fragment fragment) {
    if (selecteds.containsKey(folder.id)) {
      selecteds[folder.id]!.addAll(<int, void>{fragment.id: null});
    } else {
      selecteds.addAll(
        <int, Map<int, void>>{
          folder.id: <int, void>{fragment.id: null}
        },
      );
    }
    selectedCount += 1;
    selecteds.refresh();
  }

  void cancelSelected(Folder folder, Fragment fragment) {
    final selectedFolder = selecteds[folder.id];
    if (selectedFolder != null) {
      if (selectedFolder.containsKey(fragment.id)) {
        selectedFolder.remove(fragment.id);
        selectedCount -= 1;
        selecteds.refresh();
      }
      if (selectedFolder.isEmpty) {
        selecteds.remove(folder.id);
      }
    }
  }

  void cancelSelectedMany(Folder folder) {
    selectedCount -= selecteds[folder.id]?.length ?? 0;
    selecteds.remove(folder.id);
    selecteds.refresh();
  }

  Widget putGroupWidget(BuildContext context) {
    return FloatingActionButton(
      child: Obx(
        () => Text(isSelectModel.value ? selectedCount.value.toString() : '成组'),
      ),
      onPressed: () async {
        if (isSelectModel.value) {
          final int? result = await showModalActionSheet(
            context: context,
            actions: <SheetAction<int>>[
              const SheetAction(key: 1, label: '成组', isDestructiveAction: true),
              const SheetAction(key: 0, label: '退出成组模式'),
            ],
            title: '',
            message: '已选 ${selectedCount.value}',
            cancelLabel: '取消',
          );
          if (result == 0) {
            isSelectModel.value = false;
            EasyLoading.showToast('已退出成组模式！');
          }
        } else {
          isSelectModel.value = true;
          EasyLoading.showToast('已切换成组模式！');
        }
      },
    );
  }
}
