import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/FragmentListPageGetXController.dart';

class FragmentCard {
  String? question = '';
  String? answer = '';
  String? description = '';

  bool isRemovedInListView = false;

  @override
  String toString() {
    return '(question: $question, answer: $answer, description: $description)';
  }
}

class FragmentCreatePage extends StatefulWidget {
  const FragmentCreatePage({Key? key, required this.folder}) : super(key: key);
  final Folder folder;

  @override
  _FragmentCreatePageState createState() => _FragmentCreatePageState();
}

class _FragmentCreatePageState extends State<FragmentCreatePage> {
  late final FragmentListPageGetXController _fragmentListPageGetXController;

  final List<FragmentCard> _fragmentCard = <FragmentCard>[];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// 检查单个 [FragmentCard] 是否为空。
  bool isFragmentCardEmpty(FragmentCard fragmentCard) {
    return (fragmentCard.description == null || fragmentCard.description == '') &&
            (fragmentCard.question == null || fragmentCard.question == '') &&
            (fragmentCard.description == null || fragmentCard.description == '') ||
        fragmentCard.isRemovedInListView;
  }

  /// 检查全部 [FragmentCard] 是否为空。
  bool haveUnSubmittedFragmentCard() {
    for (var value in _fragmentCard) {
      if (!isFragmentCardEmpty(value)) {
        return true;
      }
    }
    return false;
  }

  /// 若全部 [FragmentCard] 都为空，才返回 true。
  ///
  /// 若为 false，则将 [showOkCancelAlertDialog]。
  Future<bool> checkAndIsBack() async {
    if (haveUnSubmittedFragmentCard()) {
      final result = await showTextAnswerDialog(
        context: context,
        title: '确定要放弃全部编辑？\n确定请输入：1',
        okLabel: '放弃全部',
        cancelLabel: '继续编辑',
        isDestructiveAction: true,
        keyword: '1',
        retryMessage: '输入有误！',
        retryOkLabel: '重新输入',
        retryCancelLabel: '继续编辑',
      );
      if (result) {
        EasyLoading.showToast('已放弃全部编辑！');
        return true;
      }
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _fragmentListPageGetXController = Get.find<FragmentListPageGetXController>(tag: widget.folder.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await checkAndIsBack();
      },
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.red,
            onPressed: () async {
              if (await checkAndIsBack()) {
                Get.back();
              }
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.check, color: Colors.lightGreenAccent),
              onPressed: () async {
                EasyLoading.show(indicator: const CircularProgressIndicator(), maskType: EasyLoadingMaskType.black, dismissOnTap: false);
                final List<FragmentsCompanion> fragmentsCompanions = <FragmentsCompanion>[];
                for (var element in _fragmentCard) {
                  if (!isFragmentCardEmpty(element)) {
                    fragmentsCompanions.add(
                      FragmentsCompanion.insert(
                        question: drift.Value(element.question),
                        answer: drift.Value(element.answer),
                        description: drift.Value(element.description),
                      ),
                    );
                  }
                }
                final List<Fragment> result = await DriftDb.instance.insertDAO.insertFragments(fragmentsCompanions, widget.folder);
                if (fragmentsCompanions.isEmpty) {
                  EasyLoading.showToast('没有可添加项');
                  Get.back();
                } else {
                  EasyLoading.showSuccess('添加成功');
                  _fragmentListPageGetXController.addFragments(widget.folder, result);
                  Get.back();
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: _fragmentCard.length + 1,
            itemBuilder: (BuildContext context, int index) {
              if (index == _fragmentCard.length) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  elevation: 3,
                  child: TextButton(
                    child: const Text('点击增加'),
                    onPressed: () {
                      _fragmentCard.add(FragmentCard());
                      if (mounted) setState(() {});
                    },
                  ),
                );
              }
              if (_fragmentCard[index].isRemovedInListView) {
                return Container();
              }
              return Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Text('问题：'),
                                Expanded(
                                  child: TextFormField(
                                      minLines: 1,
                                      maxLines: 3,
                                      decoration: const InputDecoration(
                                        filled: true,
                                        isCollapsed: true,
                                        contentPadding: EdgeInsets.all(5),
                                        hintText: '请输入问题',
                                        border: InputBorder.none,
                                      ),
                                      onSaved: (String? value) {
                                        _fragmentCard[index].question = value;
                                      }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                const Text('答案：'),
                                Expanded(
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.all(5),
                                      hintText: '请输入答案',
                                      border: InputBorder.none,
                                    ),
                                    onSaved: (String? value) {
                                      _fragmentCard[index].answer = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                const Text('描述：'),
                                Expanded(
                                  child: TextFormField(
                                    minLines: 1,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.all(5),
                                      hintText: '请输入描述',
                                      border: InputBorder.none,
                                    ),
                                    onSaved: (String? value) {
                                      _fragmentCard[index].description = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear, color: Colors.red),
                        onPressed: () {
                          _fragmentCard[index].isRemovedInListView = true;
                          if (mounted) setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          onChanged: () {
            _formKey.currentState?.save();
          },
        ),
      ),
    );
  }
}
