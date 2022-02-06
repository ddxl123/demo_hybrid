import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FragmentListPageGetXController extends GetxController {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final RxList<Fragment> fragments = <Fragment>[].obs;

  RxInt serializeFragmentsCount = 0.obs;

  RxBool isLongPress = false.obs;

  /// 不包含 offset 本身。
  int offset = 0;

  Future<void> deleteSerializeFragment(Folder forFolder, Fragment forFragment) async {
    // 删除该碎片本地持久化。
    await DriftDb.instance.deleteDAO.deleteFragmentWith(forFragment);
    // 取消成组模式该碎片的选择。
    _globalGetXController.cancelSelectedSingleForGroupModel(forFolder, forFragment);
    // 移除 widget。
    fragments.remove(forFragment);
    offset -= 1;
    serializeFragmentsCount.value -= 1;
  }

  Future<void> getSerializeFragments(Folder forFolder) async {
    // 获取持久化数据。
    final List<Fragment> newFragments = await DriftDb.instance.retrieveDAO.getFolder2Fragments(forFolder, offset, 50);
    // 插入到 widget 中。
    fragments.addAll(newFragments);
    offset += newFragments.length;
  }

  Future<void> insertSerializeFragments(Folder folder, List<FragmentsCompanion> fragmentsCompanions) async {
    // 持久化数据。
    final List<Fragment> result = await DriftDb.instance.insertDAO.insertFragments(fragmentsCompanions, folder);
    // 插入到 widget 中。
    fragments.addAll(result);
    offset += result.length;
    serializeFragmentsCount.value += result.length;
  }

  Future<void> clearViewAndReGetSerializeFragments(Folder forFolder) async {
    offset -= fragments.length;
    fragments.clear();
    await getSerializeFragments(forFolder);
    serializeFragmentsCount.value = await DriftDb.instance.retrieveDAO.getFolder2FragmentCount(forFolder);
  }

  Future<void> updateSerializeFragment(Fragment oldFragment, Fragment newFragment) async {
    await DriftDb.instance.updateDAO.updateFragment(newFragment);
    int oldIndex = fragments.indexOf(oldFragment);
    fragments.remove(oldFragment);
    fragments.insert(oldIndex, newFragment);
    // refresh();
  }

  Future<bool> isExistInMemoryGroup(Fragment fragment) async {
    return await DriftDb.instance.retrieveDAO.getIsExistMemoryGroup(fragment);
  }
}
