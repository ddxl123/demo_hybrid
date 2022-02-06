import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:hybrid/jianji/controller/RememberingPageGetXController.dart';
import 'package:hybrid/jianji/controller/RememberingRunPageGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RememberingPage extends StatefulWidget {
  const RememberingPage({Key? key}) : super(key: key);

  @override
  _RememberingPageState createState() => _RememberingPageState();
}

class _RememberingPageState extends State<RememberingPage> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final RememberPageGetXController _rememberPageGetXController = Get.find<RememberPageGetXController>();
  final RememberingRunPageGetXController _rememberingRunPageGetXController = Get.find<RememberingRunPageGetXController>();

  @override
  void initState() {
    super.initState();
    DriftDb.instance.retrieveDAO.getRememberingOrNull().then(
      (value) {
        if (value == null) {
          _rememberPageGetXController.rememberStatusSerialize.value = RememberStatus.none.index;
        } else {
          _rememberPageGetXController.rememberStatusSerialize.value = value.status;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          leading: const BackButton(color: Colors.blue),
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text('任务列表（${_rememberPageGetXController.rememberingCount.value}）', style: const TextStyle(color: Colors.blue)),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              color: Colors.grey,
              onPressed: () {
                EasyLoading.showToast('返回或重启应用不会影响记忆进度！\n已自动过滤掉重复内容', duration: const Duration(seconds: 5));
              },
            ),
            MaterialButton(
              child: const Text('取消任务', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final result = await showOkCancelAlertDialog(
                  context: context,
                  title: '确定取消任务？',
                  okLabel: '确定取消',
                  cancelLabel: '继续任务',
                  isDestructiveAction: true,
                );
                if (result == OkCancelResult.ok) {
                  await DriftDb.instance.deleteDAO.deleteRememberAll();
                  _globalGetXController.isRemembering.value = false;
                  Get.back();
                  EasyLoading.showToast('取消成功！可轻触’记‘浮动按钮创建新任务！', duration: const Duration(seconds: 5));
                }
              },
            ),
          ],
        ),
        body: SmartRefresher(
          footer: const ClassicFooter(
            height: 120,
            loadingText: '获取中...',
            idleText: '上拉刷新',
            canLoadingText: '可以松手了',
            failedText: '刷新失败！',
            noDataText: '没有更多数据',
          ),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: _rememberPageGetXController.refreshController,
          enablePullUp: false,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _rememberPageGetXController.fragments.length,
            itemBuilder: (BuildContext context, int index) {
              return RememberingPageFragmentButton(fragment: _rememberPageGetXController.fragments[index]);
            },
          ),
          onRefresh: () async {
            await _rememberPageGetXController.clearAndGetViewFragments();
            _rememberPageGetXController.refreshController.refreshCompleted();
          },
        ),
        floatingActionButton: () {
          if (_rememberPageGetXController.rememberStatusSerialize.value == RememberStatus.none.index) {
            return FloatingActionButton(
              backgroundColor: Colors.orangeAccent,
              child: const Text('未开始'),
              onPressed: () async {
                final int? result = await showModalActionSheet<int>(
                  context: context,
                  title: '请选择一种方式：',
                  actions: [
                    SheetAction(
                      key: 2,
                      label: '问答翻转（${_rememberPageGetXController.isQuestionAndAnswerExchange.value ? '已翻转' : '未翻转'}）',
                      isDestructiveAction: true,
                    ),
                    const SheetAction(key: 1, label: '随机可重复', isDestructiveAction: true),
                    const SheetAction(key: 0, label: '随机不可重复', isDestructiveAction: true),
                  ],
                );
                if (result == 0) {
                  _rememberPageGetXController.rememberStatusSerialize.value = RememberStatus.randomNotRepeat.index;
                  _rememberingRunPageGetXController.recordFragments.clear();
                  await _rememberPageGetXController.setInitRemembering();
                  await _rememberPageGetXController.toRunPage();
                } else if (result == 1) {
                  // _rememberPageGetXController.rememberStatusSerialize.value = RememberStatus.randomRepeat.index;
                  // _rememberingRunPageGetXController.recordFragments.clear();
                  // await _rememberPageGetXController.setInitRemembering();
                  // await _rememberPageGetXController.toRunPage();
                  EasyLoading.showToast('该选项有bug未解决，请选择 随机不可重复');
                } else if (result == 2) {
                  final isExchange = await showOkCancelAlertDialog(
                    context: context,
                    message: '${_rememberPageGetXController.isQuestionAndAnswerExchange.value ? '确定取消翻转问题和答案？' : '确定翻转问题和答案？'}\n单词记忆可进行尝试翻转！',
                    okLabel: '确定',
                    cancelLabel: '否定',
                    isDestructiveAction: true,
                  );
                  if (isExchange == OkCancelResult.ok) {
                    _rememberPageGetXController.isQuestionAndAnswerExchange.value = !_rememberPageGetXController.isQuestionAndAnswerExchange.value;
                  }
                }
              },
            );
          } else if (_rememberPageGetXController.rememberStatusSerialize.value == RememberStatus.randomNotRepeat.index) {
            return FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Text('继续'),
              onPressed: () async {
                await _rememberPageGetXController.toRunPage();
              },
            );
          } else if (_rememberPageGetXController.rememberStatusSerialize.value == RememberStatus.randomRepeat.index) {
            return FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Text('继续'),
              onPressed: () async {
                await _rememberPageGetXController.toRunPage();
              },
            );
          } else {
            throw '未知 _rememberStatus: ${_rememberPageGetXController.rememberStatusSerialize.toString()}';
          }
        }(),
      );
    });
  }
}

class RememberingPageFragmentButton extends StatefulWidget {
  const RememberingPageFragmentButton({Key? key, required this.fragment}) : super(key: key);
  final Fragment fragment;

  @override
  _RememberingPageFragmentButtonState createState() => _RememberingPageFragmentButtonState();
}

class _RememberingPageFragmentButtonState extends State<RememberingPageFragmentButton> {
  final RememberPageGetXController _rememberPageGetXController = Get.find<RememberPageGetXController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
      child: TextButton(
        child: Text(widget.fragment.question.toString()),
        onPressed: () {
          Get.to(
            () => FragmentSnapshotPage(
              initEnterFragment: widget.fragment,
              isEnableEdit: true,
              pageTurningFragments: _rememberPageGetXController.fragments,
              isSecret: true,
              onUpdateSerialize: (Fragment oldFragment, Fragment newFragment) async {
                await _rememberPageGetXController.updateSerializeRemembering(oldFragment, newFragment);
              },
            ),
          );
        },
      ),
    );
  }
}
