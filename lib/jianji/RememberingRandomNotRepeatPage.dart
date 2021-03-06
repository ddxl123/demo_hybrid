import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/controller/RememberingRunPageGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'controller/RememberingPageGetXController.dart';

class RememberingRandomNotRepeatPage extends StatefulWidget {
  const RememberingRandomNotRepeatPage({Key? key}) : super(key: key);

  @override
  _RememberingRandomNotRepeatPageState createState() => _RememberingRandomNotRepeatPageState();
}

class _RememberingRandomNotRepeatPageState extends State<RememberingRandomNotRepeatPage> {
  final RememberPageGetXController _rememberPageGetXController = Get.find<RememberPageGetXController>();
  final RememberingRunPageGetXController _rememberingRunPageGetXController = Get.find<RememberingRunPageGetXController>();

  @override
  void initState() {
    super.initState();
    _rememberPageGetXController.reGetRememberRunCompleteCount();
  }

  @override
  Widget build(BuildContext context) {
    _rememberingRunPageGetXController.fragmentSnapshotPageController
        ?.refreshFragment(_rememberingRunPageGetXController.currentFragment ?? Fragment(id: -1, createdAt: DateTime.now(), updatedAt: DateTime.now()));
    return Stack(
      children: [
        SmartRefresher(
          controller: _rememberingRunPageGetXController.refreshController,
          child: FragmentSnapshotPage(
            putFragmentSnapshotPageController: (controller) {
              _rememberingRunPageGetXController.fragmentSnapshotPageController = controller;
            },
            initEnterFragment: Fragment(id: -1, createdAt: DateTime.now(), updatedAt: DateTime.now()),
            isEnableEdit: false,
            pageTurningFragments: null,
            isSecret: true,
            isRelyOnQuestionAndAnswerExchange: true,
            onUpdateSerialize: (Fragment oldFragment, Fragment newFragment) async {
              /// isEnableEdit: false
            },
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: const BackButton(color: Colors.blue),
              title: Text(
                '??????????????????${_rememberPageGetXController.rememberRunCompleteCount}/${_rememberPageGetXController.rememberingCount}???',
                style: const TextStyle(color: Colors.blue),
                textScaleFactor: 0.8,
              ),
              actions: [
                MaterialButton(
                  child: const Text('????????????', style: TextStyle(color: Colors.red)),
                  onPressed: () {
                    _rememberingRunPageGetXController.resetButtonHandle(context, true);
                  },
                )
              ],
            ),
            body: _rememberingRunPageGetXController.currentFragment == null ? const Text('????????????', textAlign: TextAlign.center) : null,
          ),
          onRefresh: () async {
            // ??????????????????????????????
            await _rememberingRunPageGetXController.getInitFragment(this);
            _rememberingRunPageGetXController.refreshController.refreshCompleted();
          },
        ),
        Positioned(
          bottom: 50,
          left: 100,
          child: Transform.scale(
            scale: 2,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.chevron_left, color: Colors.blue),
              heroTag: 'left',
              onPressed: () {
                _rememberingRunPageGetXController.fragmentSnapshotPageController?.refreshHide(true);
                if (_rememberingRunPageGetXController.currentFragment == null) {
                  EasyLoading.showToast('_currentFragment ??? null');
                } else {
                  final int currentIndex = _rememberingRunPageGetXController.recordFragments.indexOf(_rememberingRunPageGetXController.currentFragment!);
                  if (currentIndex == 0) {
                    EasyLoading.showToast('??????????????????');
                  }
                  _rememberingRunPageGetXController.currentFragment =
                      _rememberingRunPageGetXController.recordFragments[currentIndex == 0 ? currentIndex : currentIndex - 1];
                  setState(() {});
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 100,
          child: Transform.scale(
            scale: 2,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              child: const Icon(Icons.chevron_right, color: Colors.blue),
              heroTag: 'right',
              onPressed: () async {
                _rememberingRunPageGetXController.fragmentSnapshotPageController?.refreshHide(true);
                if (_rememberingRunPageGetXController.currentFragment == null) {
                } else {
                  final int currentIndex = _rememberingRunPageGetXController.recordFragments.indexOf(_rememberingRunPageGetXController.currentFragment!);
                  if (currentIndex == _rememberingRunPageGetXController.recordFragments.length - 1) {
                    log('message');
                    final bool haveNext = await _rememberingRunPageGetXController.getNextFragment(this);
                    if (!haveNext) {
                      final result = await showOkCancelAlertDialog(
                        context: context,
                        title: '????????????????????????',
                        okLabel: '????????????',
                        cancelLabel: '??????',
                        isDestructiveAction: true,
                      );
                      if (result == OkCancelResult.ok) {
                        Get.back();
                      }
                    }
                  } else {
                    _rememberingRunPageGetXController.currentFragment = _rememberingRunPageGetXController.recordFragments[currentIndex + 1];
                    setState(() {});
                  }
                }
                _rememberPageGetXController.reGetRememberRunCompleteCount();
              },
            ),
          ),
        ),
      ],
    );
  }
}
