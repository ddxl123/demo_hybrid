import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/RememberingRandomNotRepeatFloatingPage.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:hybrid/jianji/controller/RememberingPageGetXController.dart';
import 'package:hybrid/jianji/controller/RememberingRunPageGetXController.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'RememberingRandomNotRepeatPage.dart';

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
          title: Text('???????????????${_rememberPageGetXController.rememberingCount.value}???', style: const TextStyle(color: Colors.blue,fontSize: 14)),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              color: Colors.grey,
              onPressed: () {
                EasyLoading.showToast('????????????????????????????????????????????????\n??????????????????????????????', duration: const Duration(seconds: 5));
              },
            ),
            MaterialButton(
              child: const Text('????????????', style: TextStyle(color: Colors.red)),
              onPressed: () async {
                final result = await showOkCancelAlertDialog(
                  context: context,
                  title: '?????????????????????',
                  okLabel: '????????????',
                  cancelLabel: '????????????',
                  isDestructiveAction: true,
                );
                if (result == OkCancelResult.ok) {
                  await DriftDb.instance.deleteDAO.deleteRememberAll();
                  _globalGetXController.isRemembering.value = false;
                  Get.back();
                  EasyLoading.showToast('???????????????????????????????????????????????????????????????', duration: const Duration(seconds: 5));
                }
              },
            ),
          ],
        ),
        body: SmartRefresher(
          footer: const ClassicFooter(
            height: 120,
            loadingText: '?????????...',
            idleText: '????????????',
            canLoadingText: '???????????????',
            failedText: '???????????????',
            noDataText: '??????????????????',
          ),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: _rememberPageGetXController.refreshController,
          enablePullUp: false,
          enablePullDown: true,
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
              child: const Text('?????????'),
              onPressed: () async {
                final int? result = await showModalActionSheet<int>(
                  context: context,
                  title: '????????????????????????',
                  actions: [
                    SheetAction(
                      key: 2,
                      label: '???????????????${_rememberPageGetXController.isQuestionAndAnswerExchange.value ? '?????????' : '?????????'}???',
                      isDestructiveAction: true,
                    ),
                    const SheetAction(key: 1, label: '??????????????????????????????', isDestructiveAction: true),
                    const SheetAction(key: 0, label: '??????????????????', isDestructiveAction: true),
                  ],
                );
                if (result == 0) {
                  _rememberPageGetXController.rememberStatusSerialize.value = RememberStatus.randomNotRepeat.index;
                  _rememberingRunPageGetXController.recordFragments.clear();
                  await _rememberPageGetXController.setInitRemembering(RememberStatus.randomNotRepeat);
                  await Get.to(() => const RememberingRandomNotRepeatPage());
                } else if (result == 1) {
                  await _rememberPageGetXController.setInitRemembering(RememberStatus.randomNotRepeatFloating);
                  final result = await TransferManager.instance.transferExecutor.executeWithViewAndOperation<void, bool>(
                    executeForWhichEngine: EngineEntryName.SHOW,
                    closeViewAfterSeconds: null,
                    endViewParams: (ViewParams lastViewParams, SizeInt screenSize) => bigViewParams,
                    startViewParams: null,
                    operationId: OUniform.SHOW_START,
                    resultDataCast: (Object resultData) => resultData as bool,
                    startEngineWhenClose: true,
                    setOperationData: () {},
                  );
                  await result.handle(
                    doSuccess: (bool successData) async {
                      if (successData) {
                        _rememberPageGetXController.rememberStatusSerialize.value = RememberStatus.randomNotRepeatFloating.index;
                        _rememberingRunPageGetXController.recordFragments.clear();
                        // await _rememberPageGetXController.setInitRemembering();
                        await EasyLoading.showToast('????????????????????????');
                      } else {
                        throw 'successData: $successData';
                      }
                    },
                    doError: (SingleResult<bool> errorResult) async {
                      EasyLoading.showToast('????????????????????????\n${errorResult.getRequiredVm()}\n????????????????????????????????????');
                    },
                  );
                } else if (result == 2) {
                  final isExchange = await showOkCancelAlertDialog(
                    context: context,
                    message: '${_rememberPageGetXController.isQuestionAndAnswerExchange.value ? '????????????????????????????????????' : '??????????????????????????????'}\n????????????????????????????????????\n????????????????????????????????????',
                    okLabel: '??????',
                    cancelLabel: '??????',
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
              child: const Text('??????'),
              onPressed: () async {
                await Get.to(() => const RememberingRandomNotRepeatPage());
              },
            );
          } else if (_rememberPageGetXController.rememberStatusSerialize.value == RememberStatus.randomNotRepeatFloating.index) {
            return FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Text('??????'),
              onPressed: () async {
                await _rememberingRunPageGetXController.resetButtonHandle(context, false);
              },
            );
          } else {
            throw '?????? _rememberStatus: ${_rememberPageGetXController.rememberStatusSerialize.toString()}';
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
