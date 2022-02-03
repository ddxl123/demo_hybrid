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

  final Map<String, FocusNode> _focusNodes = <String, FocusNode>{};

  String _nextFocusNode = '';

  /// 检查单个 [FragmentCard] 是否为空。
  bool haveValueSingle(FragmentCard fragmentCard) {
    // 无论提交，还是修改、取消，都要 save。
    _formKey.currentState?.save();

    return (fragmentCard.description == null || fragmentCard.description == '') &&
            (fragmentCard.question == null || fragmentCard.question == '') &&
            (fragmentCard.description == null || fragmentCard.description == '') ||
        fragmentCard.isRemovedInListView;
  }

  /// 检查全部 [FragmentCard] 是否为空。
  bool haveValueAll() {
    for (var value in _fragmentCard) {
      if (!haveValueSingle(value)) {
        return true;
      }
    }
    return false;
  }

  /// 无 Value 时，会显示 '没有添加项！' 并返回。
  /// 有 Value 时，会显示 '确定要放弃全部编辑？' 不返回。
  Future<bool> checkAndIsBack() async {
    if (haveValueAll()) {
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
    EasyLoading.showToast('没有添加项！');
    return true;
  }

  @override
  void initState() {
    super.initState();
    _fragmentListPageGetXController = Get.find<FragmentListPageGetXController>(tag: widget.folder.hashCode.toString());
  }

  @override
  void dispose() {
    _focusNodes.forEach((key, value) {
      value.dispose();
    });
    _focusNodes.clear();
    super.dispose();
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
                EasyLoading.show();
                final List<FragmentsCompanion> fragmentsCompanions = <FragmentsCompanion>[];
                for (var element in _fragmentCard) {
                  if (!haveValueSingle(element)) {
                    fragmentsCompanions.add(
                      FragmentsCompanion.insert(
                        question: drift.Value(element.question),
                        answer: drift.Value(element.answer),
                        description: drift.Value(element.description),
                      ),
                    );
                  }
                }
                if (fragmentsCompanions.isEmpty) {
                  EasyLoading.showToast('没有可添加项');
                  Get.back();
                } else {
                  await _fragmentListPageGetXController.insertSerializeFragments(widget.folder, fragmentsCompanions);
                  EasyLoading.showSuccess('添加成功');
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
            itemBuilder: (BuildContext formContext, int index) {
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
                                    autofocus: true,
                                    focusNode: () {
                                      final key = index.toString() + '-one';
                                      if (!_focusNodes.containsKey(key)) {
                                        _focusNodes.addAll({key: FocusNode()});
                                      }
                                      return _focusNodes[key];
                                    }(),
                                    minLines: 3,
                                    maxLines: 5,
                                    decoration: const InputDecoration(
                                      filled: true,
                                      isCollapsed: true,
                                      contentPadding: EdgeInsets.all(5),
                                      hintText: '请输入问题',
                                      border: InputBorder.none,
                                    ),
                                    onSaved: (String? value) {
                                      _fragmentCard[index].question = value;
                                    },
                                    onTap: () {
                                      _nextFocusNode = index.toString() + '-two';
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: <Widget>[
                                const Text('答案：'),
                                Expanded(
                                  child: TextFormField(
                                    focusNode: () {
                                      final key = index.toString() + '-two';
                                      if (!_focusNodes.containsKey(key)) {
                                        _focusNodes.addAll({key: FocusNode()});
                                      }
                                      return _focusNodes[key];
                                    }(),
                                    minLines: 3,
                                    maxLines: 5,
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
                                    onTap: () {
                                      _nextFocusNode = index.toString() + '-three';
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
                                    autofocus: true,
                                    focusNode: () {
                                      final key = index.toString() + '-three';
                                      if (!_focusNodes.containsKey(key)) {
                                        _focusNodes.addAll({key: FocusNode()});
                                      }
                                      return _focusNodes[key];
                                    }(),
                                    minLines: 3,
                                    maxLines: 5,
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
                                    onTap: () {
                                      _nextFocusNode = (index + 1).toString() + '-one';
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.clear, color: Colors.red),
                            onPressed: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              final isOk = await showOkCancelAlertDialog(
                                context: context,
                                message: '确认移除此卡片？',
                                okLabel: '确认',
                                cancelLabel: '取消',
                                isDestructiveAction: true,
                              );
                              if (isOk == OkCancelResult.ok) {
                                _fragmentCard[index].isRemovedInListView = true;
                                final one = index.toString() + '-one';
                                final two = index.toString() + '-two';
                                final three = index.toString() + '-three';
                                _focusNodes.remove(one);
                                _focusNodes.remove(two);
                                _focusNodes.remove(three);
                                if (mounted) setState(() {});
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.arrow_downward, color: Colors.white),
          backgroundColor: Colors.green,
          onPressed: () {
            if (_nextFocusNode == '') {
              _nextFocusNode = '0-two';
            }
            FocusScope.of(context).requestFocus(_focusNodes[_nextFocusNode]);
            final sps = _nextFocusNode.split('-');
            String en = '';
            String num = '';
            if (sps.last == 'one') {
              en = 'two';
              num = sps.first;
            } else if (sps.last == 'two') {
              en = 'three';
              num = sps.first;
            } else {
              en = 'one';
              num = (int.parse(sps.first) + 1).toString();
            }
            _nextFocusNode = '$num-$en';
            if (!_focusNodes.containsKey(_nextFocusNode)) {
              _fragmentCard.add(FragmentCard());
              if (mounted) setState(() {});
            }
          },
        ),
      ),
    );
  }
}
