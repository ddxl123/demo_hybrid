import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MemoryGroupListGetXController extends GetxController {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final RxList<MemoryGroup> memoryGroups = <MemoryGroup>[].obs;

  /// 不包含 offset 本身。
  int offset = 0;

  Future<void> insertSerializeMemoryGroup(MemoryGroupsCompanion memoryGroupsCompanion) async {
    final MemoryGroup result = await DriftDb.instance.insertDAO.insertMemoryGroup(memoryGroupsCompanion);
    memoryGroups.add(result);
    offset += 1;
  }

  Future<void> getSerializeMemoryGroups() async {
    final List<MemoryGroup> result = await DriftDb.instance.retrieveDAO.getMemoryGroups(offset, 9999);
    memoryGroups.addAll(result);
    offset += result.length;
  }

  void clearViewMemoryGroups() {
    offset -= memoryGroups.length;
    memoryGroups.clear();
  }

  Future<void> deleteSerializeMemoryGroup(MemoryGroup memoryGroup) async {
    // 删除该记忆组的本地持久化。
    await DriftDb.instance.deleteDAO.deleteMemoryGroupWith(memoryGroup);
    // 取消成组模式该记忆组的选择。
    _globalGetXController.selectedMemoryGroupsForGroupModel.remove(memoryGroup.id);
    // 移除 widget。
    memoryGroups.remove(memoryGroup);
    offset -= 1;
  }
}
