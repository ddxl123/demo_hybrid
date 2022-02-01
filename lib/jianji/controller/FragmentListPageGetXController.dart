import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FragmentListPageGetXController extends GetxController {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();

  final RefreshController refreshController = RefreshController(initialRefresh: true);

  final RxList<Fragment> fragments = <Fragment>[].obs;

  /// 不包含 offset 本身。
  int offset = 0;

  void removeFragment(Folder folder, Fragment fragment) {
    _globalGetXController.cancelSelected(folder, fragment);
    fragments.remove(fragment);
    offset -= 1;
  }

  void addFragments(Folder folder, List<Fragment> newFragments) {
    fragments.addAll(newFragments);
    offset += fragments.length;
  }
}
