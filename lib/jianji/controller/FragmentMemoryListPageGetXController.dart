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

// Future<void> deleteSerializeFragment(Folder forFolder, Fragment forFragment) async {
//   // 删除该碎片本地持久化。
//   await DriftDb.instance.deleteDAO.deleteFragmentWith(forFragment);
//   // 取消成组模式该碎片的选择。
//   _globalGetXController.cancelSelectedForGroupModel(forFolder, forFragment);
//   // 移除 widget。
//   fragments.remove(forFragment);
//   offset -= 1;
//   serializeFragmentsCount.value -= 1;
// }
//

//
// Future<void> insertSerializeFragments(Folder folder, List<FragmentsCompanion> fragmentsCompanions) async {
//   // 持久化数据。
//   final List<Fragment> result = await DriftDb.instance.insertDAO.insertFragments(fragmentsCompanions, folder);
//   // 插入到 widget 中。
//   fragments.addAll(result);
//   offset += result.length;
//   serializeFragmentsCount.value += result.length;
// }
//

  Future<void> getSerializeFragmentMemorys(MemoryGroup forMemoryGroup) async {
    final List<Fragment> newFragments = await DriftDb.instance.retrieveDAO.getMemoryGroup2Fragments(forMemoryGroup, offset, 5);
    // 插入到 widget 中。
    fragmentMemorys.addAll(newFragments);
    offset += newFragments.length;
  }

  Future<void> clearViewAndReGetSerializeFragmentMemorys(MemoryGroup forMemoryGroup) async {
    offset -= fragmentMemorys.length;
    fragmentMemorys.clear();
    await getSerializeFragmentMemorys(forMemoryGroup);
    serializeFragmentMemorysCount.value = await DriftDb.instance.retrieveDAO.getMemoryGroup2FragmentCount(forMemoryGroup);
  }
}
