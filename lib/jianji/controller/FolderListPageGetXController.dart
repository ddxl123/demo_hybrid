import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'GlobalGetXController.dart';

class FolderListPageGetXController extends GetxController {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final RxList<Folder> folders = <Folder>[].obs;

  /// 不包含 offset 本身。
  int offset = 0;

  Future<void> deleteSerializeFolder(Folder forFolder) async {
    // 删除该文件夹本地持久化。
    await DriftDb.instance.deleteDAO.deleteFolderWith(forFolder);
    // 取消成组模式该文件夹中全部的碎片的选择。
    _globalGetXController.cancelSelectedManyForGroupModel(forFolder);
    // 移除 widget。
    folders.remove(forFolder);
    offset -= 1;
  }

  Future<void> getSerializeFolders() async {
    // 获取持久化数据。
    final List<Folder> result = await DriftDb.instance.retrieveDAO.getFoldersBySort(offset, 9999);
    // 插入到 widget 中。
    folders.addAll(result);
    offset += result.length;
  }

  /// [upOrDown] 0表示向上移动，1表示向下移动
  Future<void> sortSerializeFolder(Folder currentFolder, int upOrDown) async {
    final int? exchangedFolderId = await DriftDb.instance.updateDAO.updateSortFolder(currentFolder.sort!, upOrDown);
    final currentIndex = folders.indexOf(currentFolder);
    if (upOrDown == 0) {
      if (currentIndex == 0) {
        // 没有上一个。
        return;
      }
      final afterPreviousFolder = await DriftDb.instance.retrieveDAO.getFolderById(exchangedFolderId!);
      final afterCurrentFolder = await DriftDb.instance.retrieveDAO.getFolderById(currentFolder.id);
      final previousIndex = currentIndex - 1;
      folders.replaceRange(previousIndex, previousIndex + 2, [afterCurrentFolder!, afterPreviousFolder!]);
      folders.refresh();
    } else if (upOrDown == 1) {
      if (currentIndex == folders.length - 1) {
        // 没有下一个。
        return;
      }
      final afterCurrentFolder = await DriftDb.instance.retrieveDAO.getFolderById(currentFolder.id);
      final afterNextFolder = await DriftDb.instance.retrieveDAO.getFolderById(exchangedFolderId!);
      folders.replaceRange(currentIndex, currentIndex + 2, [afterNextFolder!, afterCurrentFolder!]);
      folders.refresh();
    } else {
      throw '未知 upOrDown: $upOrDown';
    }
  }

  Future<void> insertSerializeFolder(FoldersCompanion newFoldersCompanion) async {
    // 持久化数据。
    final Folder result = await DriftDb.instance.insertDAO.insertFolder(newFoldersCompanion);
    // 插入到 widget 中。
    folders.add(result);
    offset += 1;
  }

  void clearViewFolders() {
    offset -= folders.length;
    folders.clear();
  }
}
