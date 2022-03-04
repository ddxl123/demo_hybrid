import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../FragmentSnapshotPage.dart';
import '../RememberingRandomNotRepeatPage.dart';
import 'RememberingPageGetXController.dart';

class RememberingRunPageGetXController extends GetxController {
  final RememberPageGetXController rememberPageGetXController = Get.find<RememberPageGetXController>();
  FragmentSnapshotPageController? fragmentSnapshotPageController;
  final RefreshController refreshController = RefreshController(initialRefresh: true);
  final List<Fragment> recordFragments = <Fragment>[];
  Fragment? currentFragment;

  RememberStatus runRememberStatus = RememberStatus.none;

  Future<void> backToInit() async {
    // 恢复到初始化前。
    await DriftDb.instance.updateDAO.updateBeforeInitRemembering();
    await rememberPageGetXController.reGetRememberRunCompleteCount();
    rememberPageGetXController.rememberStatusSerialize.value = RememberStatus.none.index;
  }

  Future<void> resetButtonHandle(BuildContext context, bool isBack) async {
    final result = await showOkCancelAlertDialog(context: context, title: '确定要重置任务？', okLabel: '确认重置', cancelLabel: '继续任务', isDestructiveAction: true);
    if (result == OkCancelResult.ok) {
      await backToInit();
      recordFragments.clear();
      if (isBack) Get.back();
      EasyLoading.showToast('重置成功！可点击浮动按钮重新开始！');
    }
  }

  /// 没有下一个时：返回 false，不进行刷新。
  /// 存在下一个时：将 [currentFragment] 替换为新的，并添加至 [recordFragments]，并刷新且返回 true。
  Future<bool> getNextFragment(State<RememberingRandomNotRepeatPage> state) async {
    // 仅序列化当前和下一个。
    await DriftDb.instance.updateDAO.updateCurrentAndNextRemember(runRememberStatus);
    // 获取刚序列化的下一个。
    final Fragment? rfn = await DriftDb.instance.retrieveDAO.getRemembering2FragmentOrNull();
    if (rfn == null) {
      await backToInit();
      return false;
    } else {
      currentFragment = rfn;
      recordFragments.add(rfn);
      state.setState(() {});
      return true;
    }
  }

  Future<void> getInitFragment(State<RememberingRandomNotRepeatPage> state) async {
    final result = await DriftDb.instance.retrieveDAO.getRememberingOrNull();
    if (result == null) {
      EasyLoading.showToast('_getNextFragment 结果为 null, 但是仍然进入了 RememberingRunPage！');
      Get.back(result: true);
    } else {
      runRememberStatus = RememberStatus.values[result.status];
      // 这里说明，在正在记忆时，不能对 fragment 进行删除。
      currentFragment = await DriftDb.instance.retrieveDAO.getRemembering2FragmentOrNull();
      if (currentFragment == null) {
        EasyLoading.showToast('_currentFragment 结果为 null, 但是仍然进入了 RememberingRunPage！');
        Get.back(result: true);
      }
      // 防止返回后重进导致重新被添加一遍。
      if (recordFragments.isNotEmpty && recordFragments.last != currentFragment) {
        recordFragments.add(currentFragment!);
      }
    }
    state.setState(() {});
  }
}
