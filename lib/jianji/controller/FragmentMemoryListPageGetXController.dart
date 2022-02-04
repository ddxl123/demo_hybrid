import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'GlobalGetXController.dart';

class FragmentMemoryListPageGetXController extends GetxController {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final RxList<Fragment> fragmentMemorys = <Fragment>[].obs;

  RxInt serializeFragmentMemorysCount = 0.obs;

  /// 不包含 offset 本身。
  int offset = 0;

  Future<void> deleteSingleSerializeFragmentMemory(MemoryGroup forMemoryGroup, Fragment forFragment) async {
    // 删除本地持久化。
    await DriftDb.instance.deleteDAO.deleteMemoryGroup2FragmentWith(forMemoryGroup, forFragment);
    // 记忆模式下，已选记忆知识点数量变化。
    _globalGetXController.selectedCountForMemoryModel.value -= 1;
    // 记忆模式下，已选单个记忆组内的知识点数量变化。
    _globalGetXController.selectedMemoryGroupsForMemoryModel[forMemoryGroup.id] =
        _globalGetXController.selectedMemoryGroupsForMemoryModel[forMemoryGroup.id]! - 1;

    // 移除 widget。
    fragmentMemorys.remove(forFragment);
    offset -= 1;
    serializeFragmentMemorysCount.value -= 1;
  }

  Future<void> getManySerializeFragmentMemorys(MemoryGroup forMemoryGroup) async {
    final List<Fragment> newFragments = await DriftDb.instance.retrieveDAO.getMemoryGroup2Fragments(forMemoryGroup, offset, 5);
    // 插入到 widget 中。
    fragmentMemorys.addAll(newFragments);
    offset += newFragments.length;
  }

  Future<void> clearViewAndReGetSerializeFragmentMemorys(MemoryGroup forMemoryGroup) async {
    offset -= fragmentMemorys.length;
    fragmentMemorys.clear();
    await getManySerializeFragmentMemorys(forMemoryGroup);
    serializeFragmentMemorysCount.value = await DriftDb.instance.retrieveDAO.getMemoryGroup2FragmentCount(forMemoryGroup);
    refresh();
  }

  Future<void> updateSerializeFragment(Fragment oldFragment, Fragment newFragment) async {
    await DriftDb.instance.updateDAO.updateFragment(newFragment);
    late int oldIndex;
    for (int i = 0; i < fragmentMemorys.length; i++) {
      if (fragmentMemorys[i] == oldFragment) {
        oldIndex = i;
        break;
      }
    }
    fragmentMemorys.remove(oldFragment);
    fragmentMemorys.insert(oldIndex, newFragment);
  }
}
