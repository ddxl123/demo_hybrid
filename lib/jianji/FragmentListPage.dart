import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/DefaultAsset.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/controller/FragmentListPageGetXController.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sheetroute/Helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'FragmentCreatePage.dart';
import 'controller/GlobalGetXController.dart';

class FragmentListPage extends StatefulWidget {
  const FragmentListPage({Key? key, required this.folder}) : super(key: key);

  final Folder folder;

  @override
  _FragmentListPageState createState() => _FragmentListPageState();
}

class _FragmentListPageState extends State<FragmentListPage> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  late final FragmentListPageGetXController _fragmentListPageGetXController;

  String defaultWordMeaningAnalysisContent = '';
  String defaultWordMeaningContent = '';

  @override
  void initState() {
    super.initState();
    _fragmentListPageGetXController = Get.find<FragmentListPageGetXController>(tag: widget.folder.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('知识类别：' + widget.folder.title.toString()),
        actions: <Widget>[
          Obx(
            () {
              if (_globalGetXController.isGroupModel()) {
                return ObxValue<RxBool>(
                  (data) {
                    return MaterialButton(
                      child: Text(
                        data.value ? '全选' : '全不选',
                        style: const TextStyle(color: Colors.greenAccent),
                      ),
                      onPressed: () async {
                        if (data.value) {
                          // 若触发了全选
                          await _globalGetXController.addSelectedAllForGroupModel(widget.folder);
                        } else {
                          // 若触发了全不选
                          _globalGetXController.cancelSelectedManyForGroupModel(widget.folder);
                        }
                        data.value = !data.value;
                      },
                    );
                  },
                  true.obs,
                );
              } else {
                return Container();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              int? result = await showModalActionSheet(
                context: context,
                actions: [
                  const SheetAction(label: "批量创建单词/词组（大文本导入）", key: 3),
                  const SheetAction(label: "批量创建词义辨析（大文本导入）", key: 2),
                  const SheetAction(label: "批量创建任意知识点", key: 1),
                  const SheetAction(label: "从预设中创建", key: 0),
                ],
              );
              if (result == 0) {
                String two = "语文寒假作业200道判断题";
                String one = '语文寒假作业200道古诗词填空题';
                String zero = "语文寒假作业360道选择题";
                int? defaultAssetsResult = await showModalActionSheet(
                  context: context,
                  actions: [
                    SheetAction(label: two, key: 2),
                    SheetAction(label: one, key: 1),
                    SheetAction(label: zero, key: 0),
                  ],
                );
                String selectedResult = 'null';
                if (defaultAssetsResult == 0) {
                  selectedResult = zero;
                }
                if (defaultAssetsResult == 1) {
                  selectedResult = one;
                }
                if (defaultAssetsResult == 2) {
                  selectedResult = two;
                }

                if (defaultAssetsResult != null) {
                  bool answerResult = await showTextAnswerDialog(
                    context: context,
                    keyword: '1',
                    message: '将会把「$selectedResult」添加到该文件夹中（不会覆盖原有的，且无法撤销）。确定请输入1',
                    okLabel: '确定',
                    cancelLabel: '取消',
                    isDestructiveAction: true,
                    retryMessage: '输入有误！',
                    retryCancelLabel: '返回',
                    retryOkLabel: '重新输入',
                  );
                  if (answerResult) {
                    await EasyLoading.show(status: '正在添加...');
                    if (defaultAssetsResult == 0) {
                      await _fragmentListPageGetXController.insertSerializeFragments(
                        widget.folder,
                        await defaultAssetChoice360(
                          single: (String question, String answer) async {
                            return FragmentsCompanion(question: question.toValue(), answer: answer.toValue());
                          },
                        ),
                      );
                    }
                    if (defaultAssetsResult == 1) {
                      await _fragmentListPageGetXController.insertSerializeFragments(
                        widget.folder,
                        await defaultAssetAncientPoems200(
                          single: (String question) async {
                            return FragmentsCompanion(question: question.toValue(), answer: ''.toValue());
                          },
                        ),
                      );
                    }
                    if (defaultAssetsResult == 2) {
                      await _fragmentListPageGetXController.insertSerializeFragments(
                        widget.folder,
                        await defaultAssetJudge200(
                          single: (String question) async {
                            return FragmentsCompanion(question: question.toValue(), answer: ''.toValue());
                          },
                        ),
                      );
                    }
                    await EasyLoading.showSuccess('添加成功');
                  }
                }
              } else if (result == 1) {
                Get.to(FragmentCreatePage(folder: widget.folder));
              } else if (result == 2) {
                List<String>? bigTextAnalysisResult = await showTextInputDialog(
                  context: context,
                  cancelLabel: '取消',
                  okLabel: '解析',
                  isDestructiveAction: true,
                  title: '''组之间用 '|' 分割\n单词与意思用 '-' 分割\n每对英汉后必须换一次行\n例如：''',
                  message: '''
at heart - 内心里
in person - 亲自
on purpose - 故意地（purpose 意图；计划）
by nature - 天生地
|
postpone - 使延期
refuse - 拒绝
delay - 推迟；延期
cancel - 取消
|
conservative - 保守的
content to - 满足于（content 内容；目录）
confident - 自信的
generous - 慷慨的
''',
                  textFields: [
                    DialogTextField(
                      hintText: '在此输入大文本',
                      initialText: defaultWordMeaningAnalysisContent == '' ? null : defaultWordMeaningAnalysisContent,
                      maxLines: 6,
                      minLines: 1,
                    ),
                  ],
                );
                if (bigTextAnalysisResult != null && bigTextAnalysisResult.isNotEmpty) {
                  EasyLoading.show(status: '正在解析...');
                  defaultWordMeaningAnalysisContent = bigTextAnalysisResult.first;
                  late List<FragmentsCompanion> fs;
                  try {
                    fs = await wordMeaningAnalysis(
                      content: defaultWordMeaningAnalysisContent,
                      single: (String question, String answer) async => FragmentsCompanion(
                        question: question.toValue(),
                        answer: answer.toValue(),
                      ),
                    );
                    EasyLoading.dismiss();
                  } catch (e, st) {
                    EasyLoading.showError('解析失败：${e.toString()}');
                  }
                  OkCancelResult ocr = await showOkCancelAlertDialog(
                    context: context,
                    message: '确定要将 ${fs.length} 个词义辨析添加该目录下？',
                    okLabel: '确定',
                    cancelLabel: '取消',
                    isDestructiveAction: true,
                  );
                  if (ocr == OkCancelResult.ok) {
                    EasyLoading.show(status: '正在添加');
                    await _fragmentListPageGetXController.insertSerializeFragments(widget.folder, fs);
                    EasyLoading.showSuccess('添加成功！');
                  }
                }
              } else if (result == 3) {
                List<String>? bigTextResult = await showTextInputDialog(
                  context: context,
                  cancelLabel: '取消',
                  okLabel: '解析',
                  isDestructiveAction: true,
                  title: '''单词与意思用 '-' 分割\n每对英汉后必须换一次行\n例如：''',
                  message: '''
dog - 狗
be named after - 以...命名
''',
                  textFields: [
                    DialogTextField(
                      hintText: '在此输入大文本',
                      initialText: defaultWordMeaningContent == '' ? null : defaultWordMeaningContent,
                      maxLines: 6,
                      minLines: 1,
                    ),
                  ],
                );
                if (bigTextResult != null && bigTextResult.isNotEmpty) {
                  EasyLoading.show(status: '正在解析...');
                  defaultWordMeaningContent = bigTextResult.first;
                  late List<FragmentsCompanion> fs;
                  try {
                    fs = await wordMeaning(
                      content: defaultWordMeaningContent,
                      single: (String question, String answer) async => FragmentsCompanion(
                        question: question.toValue(),
                        answer: answer.toValue(),
                      ),
                    );
                    EasyLoading.dismiss();
                  } catch (e, st) {
                    EasyLoading.showError('解析失败：${e.toString()}');
                  }
                  OkCancelResult ocr = await showOkCancelAlertDialog(
                    context: context,
                    message: '确定要将 ${fs.length} 个单词/词组添加该目录下？',
                    okLabel: '确定',
                    cancelLabel: '取消',
                    isDestructiveAction: true,
                  );
                  if (ocr == OkCancelResult.ok) {
                    EasyLoading.show(status: '正在添加');
                    await _fragmentListPageGetXController.insertSerializeFragments(widget.folder, fs);
                    EasyLoading.showSuccess('添加成功！');
                  }
                }
              }
            },
          )
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          footer: const ClassicFooter(
            height: 120,
            loadingText: '获取中...',
            idleText: '上拉刷新',
            canLoadingText: '可以松手了',
            failedText: '刷新失败！',
            noDataText: '没有更多数据',
          ),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: _fragmentListPageGetXController.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _fragmentListPageGetXController.fragments.isEmpty ? 1 : _fragmentListPageGetXController.fragments.length,
            itemBuilder: (BuildContext context, int index) {
              if (_fragmentListPageGetXController.fragments.isEmpty) {
                return const Text('还没有创建过知识点！', textAlign: TextAlign.center);
              }
              return FragmentButton(fragment: _fragmentListPageGetXController.fragments[index], folder: widget.folder);
            },
          ),
          onRefresh: () async {
            await _fragmentListPageGetXController.clearViewAndReGetSerializeFragments(widget.folder);
            _fragmentListPageGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            await _fragmentListPageGetXController.getSerializeFragments(widget.folder);
            _fragmentListPageGetXController.refreshController.loadComplete();
          },
        ),
      ),
      floatingActionButton: _globalGetXController.groupModelFloatingButton(context),
    );
  }
}

class FragmentButton extends StatefulWidget {
  const FragmentButton({Key? key, required this.fragment, required this.folder}) : super(key: key);
  final Fragment fragment;
  final Folder folder;

  @override
  _FragmentButtonState createState() => _FragmentButtonState();
}

class _FragmentButtonState extends State<FragmentButton> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  late final FragmentListPageGetXController _fragmentListPageGetXController;

  @override
  void initState() {
    super.initState();
    _fragmentListPageGetXController = Get.find<FragmentListPageGetXController>(tag: widget.folder.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextButton(
              child: Text(widget.fragment.question.toString()),
              style: const ButtonStyle(alignment: Alignment.centerLeft),
              onPressed: () {
                Get.to(
                  () => FragmentSnapshotPage(
                    initEnterFragment: widget.fragment,
                    pageTurningFragments: _fragmentListPageGetXController.fragments,
                    isEnableEdit: true,
                    isSecret: true,
                    onUpdateSerialize: (Fragment oldFragment, Fragment newFragment) async {
                      await _fragmentListPageGetXController.updateSerializeFragment(oldFragment, newFragment);
                    },
                  ),
                );
              },
              onLongPress: () async {
                final OkCancelResult result = await showOkCancelAlertDialog(
                  context: context,
                  title: '确定删除？',
                  okLabel: '确定',
                  cancelLabel: '取消',
                  isDestructiveAction: true,
                );
                if (result == OkCancelResult.ok) {
                  if (_globalGetXController.isRemembering.value) {
                    EasyLoading.showToast('当前已有正在执行的记忆任务，只能新增不能删除！');
                  } else {
                    if (_globalGetXController.isMemoryModel()) {
                      EasyLoading.showToast('记忆模式下不能进行删除');
                    } else {
                      EasyLoading.show();
                      await _fragmentListPageGetXController.deleteSerializeFragment(widget.folder, widget.fragment);
                      EasyLoading.showSuccess('删除成功！');
                    }
                  }
                }
              },
            ),
          ),
          Obx(
            () {
              if (_globalGetXController.isGroupModel()) {
                return StatefulInitBuilder<bool>(
                  initValue: false,
                  init: (StatefulInitBuilderState<bool> state) {
                    _fragmentListPageGetXController.isExistInMemoryGroup(widget.fragment).then(
                      (value) {
                        state.value = value;
                        state.refresh();
                      },
                    );
                  },
                  builder: (StatefulInitBuilderState<bool> state) {
                    if (state.value) {
                      return IconButton(
                        icon: const Icon(Icons.circle, size: 15, color: Colors.green),
                        onPressed: () {},
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          ),
          Obx(
            () {
              if (_globalGetXController.isGroupModel()) {
                return IconButton(
                  icon: Icon(
                    Icons.circle,
                    size: 15,
                    color: _globalGetXController.isSelectedForGroupModel(widget.folder, widget.fragment) ? Colors.orange : Colors.grey,
                  ),
                  onPressed: () {
                    if (_globalGetXController.isSelectedForGroupModel(widget.folder, widget.fragment)) {
                      _globalGetXController.cancelSelectedSingleForGroupModel(widget.folder, widget.fragment);
                    } else {
                      _globalGetXController.addSelectedSingleForGroupModel(widget.folder, widget.fragment);
                    }
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
