import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/jianji/controller/RememberingPageGetXController.dart';
import 'package:hybrid/util/SbHelper.dart';

Function? toDoSetState;
Function? reStart;
ViewParams smallViewParams = ViewParams(width: 150, height: 150, x: 100, y: 200, isFocus: false);
ViewParams bigViewParams = ViewParams(width: 1000, height: 800, x: 100, y: 200, isFocus: true);

class RememberingRandomNotRepeatFloatingPage extends StatefulWidget {
  const RememberingRandomNotRepeatFloatingPage({Key? key}) : super(key: key);

  @override
  _RememberingRandomNotRepeatFloatingPageState createState() => _RememberingRandomNotRepeatFloatingPageState();
}

class _RememberingRandomNotRepeatFloatingPageState extends State<RememberingRandomNotRepeatFloatingPage> {
  final List<Fragment> fragments = <Fragment>[];
  int currentIndex = 0;
  bool isQuestion = true;
  String errorMessage = 'default error';
  bool isSizeSmall = false;

  int allCount = 0;
  int completedCount = 0;

  /// 单位 s
  int intervalTime = 5;

  bool isWillNext = false;

  Future<void> _updateCurrentAndNext() async {
    await DriftDb.instance.updateDAO.updateCurrentAndNextRemember(RememberStatus.randomNotRepeatFloating);
    final Fragment? f = await DriftDb.instance.retrieveDAO.getRemembering2FragmentOrNull();
    if (f == null) {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: '任务已完成！',
        okLabel: '完成并退出',
        cancelLabel: '稍后',
        isDestructiveAction: true,
      );
      if (result == OkCancelResult.ok) {
        fragments.clear();
        TransferManager.instance.transferExecutor.executeWithOnlyView(
          executeForWhichEngine: EngineEntryName.SHOW,
          startViewParams: null,
          endViewParams: (ViewParams lastViewParams, SizeInt screenSize) => smallViewParams,
          closeViewAfterSeconds: null,
        );
      }
    } else {
      fragments.add(f);
      currentIndex += 1;
      await _getCount();
    }
    if (mounted) setState(() {});
  }

  Future<void> _getCount() async {
    await DriftDb.instance.retrieveDAO.getAllCompleteRemember2FragmentsCount().then((value) => completedCount = value);
    await DriftDb.instance.retrieveDAO.getAllRemember2FragmentsCount().then((value) => allCount = value);
    if (mounted) setState(() {});
  }

  Future<void> _initGetAndReTimer() async {
    EasyLoading.showToast('长按任意处后，才能自动弹出下一个新内容！\n右上角可设置弹出时间！', duration: const Duration(seconds: 5));
    await DriftDb.instance.updateDAO.updateBeforeInitRemembering();
    await DriftDb.instance.updateDAO.updateInitRandomRemembering(RememberStatus.randomNotRepeatFloating);
    await DriftDb.instance.retrieveDAO.getRemembering2FragmentOrNull().then(
      (value) {
        if (value == null) {
          return;
        }
        fragments.clear();
        fragments.add(value);
        currentIndex = 0;
        if (mounted) setState(() {});
      },
    ).catchError(
      (e) {
        fragments.clear();
        errorMessage = e.toString();
        if (mounted) setState(() {});
      },
    );
    await _getCount();
  }

  /// [isNew] 是否准备下一个新的。
  Future<void> _longPressedToSmall(bool isNew) async {
    final result = await TransferManager.instance.transferExecutor.executeWithOnlyView(
      executeForWhichEngine: EngineEntryName.SHOW,
      startViewParams: null,
      endViewParams: (ViewParams lastViewParams, SizeInt screenSize) => smallViewParams,
      closeViewAfterSeconds: null,
    );
    await result.handle(
      doSuccess: (bool successData) async {
        if (isNew) {
          if (isWillNext) {
            return;
          }
          isWillNext = true;
          Future.delayed(
            Duration(seconds: intervalTime),
            () async {
              await TransferManager.instance.transferExecutor.executeWithOnlyView(
                executeForWhichEngine: EngineEntryName.SHOW,
                startViewParams: null,
                endViewParams: (ViewParams lastViewParams, SizeInt screenSize) => bigViewParams,
                closeViewAfterSeconds: null,
              );
              await _updateCurrentAndNext();
              isWillNext = false;
            },
          );
        }
        if (mounted) setState(() {});
      },
      doError: (SingleResult<bool> errorResult) async {
        EasyLoading.showToast('异常：${errorResult.getRequiredVm()}');
      },
    );
  }

  void _onSizeChanged() {
    final Size size = MediaQueryData.fromWindow(window).size * MediaQueryData.fromWindow(window).devicePixelRatio;
    log('restart $size');
    if (size.height <= 500 || size.width <= 500) {
      if (isSizeSmall) {
        return;
      }
      isSizeSmall = true;
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          if (mounted) setState(() {});
        },
      );
    } else {
      if (!isSizeSmall) {
        return;
      }
      isSizeSmall = false;
      Future.delayed(
        const Duration(milliseconds: 100),
        () {
          if (mounted) setState(() {});
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    toDoSetState = () {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          _onSizeChanged();
        },
      );
    };
    reStart = () {
      _initGetAndReTimer();
      _onSizeChanged();
    };
    _initGetAndReTimer();
    WidgetsBinding.instance!.addPersistentFrameCallback(
      (timeStamp) {
        _onSizeChanged();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSizeSmall) {
      return Scaffold(
        body: Center(
          child: IconButton(
            icon: const Icon(Icons.zoom_out_map),
            onPressed: () async {
              await TransferManager.instance.transferExecutor.executeWithOnlyView(
                executeForWhichEngine: EngineEntryName.SHOW,
                startViewParams: null,
                endViewParams: (ViewParams lastViewParams, SizeInt screenSize) => bigViewParams,
                closeViewAfterSeconds: null,
              );
              EasyLoading.showToast('长按任意处可快速缩小');
            },
          ),
        ),
      );
    }
    if (fragments.isEmpty) {
      return Scaffold(
        body: GestureDetector(
          onLongPress: () async {
            await _longPressedToSmall(false);
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: SizedBox(
              height: MediaQueryData.fromWindow(window).size.height,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('已完成任务，可在应用内重新启动任务！'),
                    SizedBox(height: 10),
                    Text('若要彻底关闭悬浮窗口，请强制关闭应用！', style: TextStyle(color: Colors.grey)),
                    Text('长按悬浮窗口任意处可快速缩小！', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      body: GestureDetector(
        onLongPress: () async {
          await _longPressedToSmall(true);
        },
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.orange, width: 2)),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Center(
                  child: InkWell(
                    child: const SizedBox(height: 1000, width: 50, child: Icon(Icons.keyboard_arrow_left)),
                    onTap: () {
                      // 左
                      if (currentIndex == 0) {
                        EasyLoading.showToast('没有上一个了');
                      } else {
                        currentIndex -= 1;
                        isQuestion = true;
                        if (mounted) setState(() {});
                      }
                    },
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: Content(r: this),
              ),
              Flexible(
                flex: 1,
                child: InkWell(
                  child: const SizedBox(height: 1000, width: 50, child: Icon(Icons.keyboard_arrow_right)),
                  onTap: () async {
                    // 右
                    isQuestion = true;
                    if (currentIndex < fragments.length - 1) {
                      currentIndex += 1;
                      if (mounted) setState(() {});
                    } else {
                      await _updateCurrentAndNext();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Content extends StatefulWidget {
  const Content({Key? key, required this.r}) : super(key: key);
  final _RememberingRandomNotRepeatFloatingPageState r;

  @override
  State<Content> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 10,
          left: 10,
          child: Text(widget.r.completedCount.toString() + '/' + widget.r.allCount.toString()),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Colors.orange), right: BorderSide(color: Colors.orange)),
          ),
          child: () {
            if (widget.r.fragments.isEmpty) {
              return Text(widget.r.errorMessage);
            } else {
              return GestureDetector(
                onTap: () {
                  if (mounted) {
                    widget.r.isQuestion = !widget.r.isQuestion;
                    setState(() {});
                  }
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                  child: SizedBox(
                    height: MediaQueryData.fromWindow(window).size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.r.isQuestion) Row(children: const [Text('问题：')]),
                        if (widget.r.isQuestion) Text(widget.r.fragments[widget.r.currentIndex].question.toString()),
                        if (!widget.r.isQuestion) Row(children: const [Text('答案：')]),
                        if (!widget.r.isQuestion) Text(widget.r.fragments[widget.r.currentIndex].answer.toString()),
                        const Text(' '),
                        if (!widget.r.isQuestion) Row(children: const [Text('描述：')]),
                        if (!widget.r.isQuestion) Text(widget.r.fragments[widget.r.currentIndex].description.toString()),
                        const Text(' '),
                        const Text('轻触任意处显示/隐藏答案', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),
              );
            }
          }(),
        ),
        Positioned(
          right: 0,
          child: Row(
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  EasyLoading.showToast('长按任意处后，才能自动弹出下一个新内容！\n右上角可设置弹出时间！', duration: const Duration(seconds: 5));
                },
                icon: const Icon(Icons.info_outline),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  final List<String>? result = await showTextInputDialog(
                    context: context,
                    message: '当前长按后，经过 ${widget.r.intervalTime}s 会展示一次新内容。将其修改为：',
                    textFields: <DialogTextField>[
                      DialogTextField(
                        initialText: widget.r.intervalTime.toString(),
                        keyboardType: TextInputType.number,
                      ),
                    ],
                    okLabel: '确认',
                    cancelLabel: '取消',
                    isDestructiveAction: true,
                  );
                  if (result != null && result.isNotEmpty && result.first != widget.r.intervalTime.toString()) {
                    try {
                      widget.r.intervalTime = int.parse(result.first);
                    } catch (e, st) {
                      EasyLoading.showToast('必须是纯数字！');
                    }
                  }
                },
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
