import 'dart:developer';

import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum RememberStatus {
  /// 表示无状态: 本轮结束 或且 用户可随意翻阅。
  none,

  /// 随机不可重复。
  randomNotRepeat,

  /// 随机不可重复（悬浮）。
  randomNotRepeatFloating,
}

class RememberPageGetXController extends GetxController {
  final RefreshController refreshController = RefreshController(initialRefresh: true);
  final RxList<Fragment> fragments = <Fragment>[].obs;

  /// 见 [RememberStatus]。
  RxInt rememberStatusSerialize = 0.obs;

  RxInt rememberingCount = 0.obs;

  RxInt rememberRunCompleteCount = 0.obs;

  RxBool isQuestionAndAnswerExchange = false.obs;

  Future<void> clearAndGetViewFragments() async {
    DriftDb.instance.retrieveDAO.getAllRemember2FragmentsCount().then((value) => rememberingCount.value = value);
    fragments.clear();
    final result = await DriftDb.instance.retrieveDAO.getAllRemember2Fragments();
    fragments.addAll(result);
  }

  /// 点击【随机可重复】或【随机不可重复】时，对其设置初始化 [Remember]。
  Future<void> setInitRemembering(RememberStatus rememberStatus) async {
    log('setInitRemembering: ${rememberStatusSerialize.value}');
    await DriftDb.instance.updateDAO.initRandomRemembering(rememberStatus);
  }

  /// 修改 [fragments] 某个元素的值。
  Future<void> updateSerializeRemembering(Fragment oldFragment, Fragment newFragment) async {
    await DriftDb.instance.updateDAO.updateFragment(newFragment);
    int oldIndex = fragments.indexOf(oldFragment);
    fragments.remove(oldFragment);
    fragments.insert(oldIndex, newFragment);
    // refresh();
  }

  Future<void> reGetRememberRunCompleteCount() async {
    await DriftDb.instance.retrieveDAO.getAllCompleteRemember2FragmentsCount().then((value) => rememberRunCompleteCount.value = value);
  }
}
