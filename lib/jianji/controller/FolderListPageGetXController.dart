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

  void removeFolder(Folder folder) {
    _globalGetXController.cancelSelectedMany(folder);
    folders.remove(folder);
    offset -= 1;
  }

  void addFolder(Folder folder) {
    folders.add(folder);
    offset += 1;
  }
}
