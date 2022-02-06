import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';

class FragmentEdit {
  String? question = '';
  String? answer = '';
  String? description = '';

  @override
  String toString() {
    return '(question: $question, answer: $answer, description: $description)';
  }
}

class FragmentEditPage extends StatefulWidget {
  /// 返回会传递 Get.back(after-edit_Fragment)
  const FragmentEditPage({Key? key, required this.fragment}) : super(key: key);

  // final Folder? folder;
  // final MemoryGroup? memoryGroup;
  final Fragment fragment;

  @override
  _FragmentEditPageState createState() => _FragmentEditPageState();
}

class _FragmentEditPageState extends State<FragmentEditPage> {
  // late final FragmentListPageGetXController _fragmentListPageGetXController;
  // late final FragmentMemoryListPageGetXController _fragmentMemoryListPageGetXController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FragmentEdit _fragmentEdit = FragmentEdit();

  late Fragment _fragment;

  @override
  void initState() {
    super.initState();
    _fragment = widget.fragment;

    // if (widget.folder != null) {
    //   _fragmentListPageGetXController = Get.find<FragmentListPageGetXController>(tag: widget.folder.hashCode.toString());
    // }
    // if (widget.memoryGroup != null) {
    //   _fragmentMemoryListPageGetXController = Get.find<FragmentMemoryListPageGetXController>(tag: widget.memoryGroup.hashCode.toString());
    // }
  }

  bool isEdited() {
    // 无论提交，还是修改、取消，都要 save。
    _formKey.currentState?.save();

    if (_fragmentEdit.question == _fragment.question && _fragmentEdit.answer == _fragment.answer && _fragmentEdit.description == _fragment.description) {
      return false;
    }
    return true;
  }

  /// 无编辑时，会显示 '无修改' 并返回。
  /// 有编辑时，会显示 '确定要放弃编辑' 不返回。
  Future<bool> checkAndIsBack() async {
    if (isEdited()) {
      final result = await showOkCancelAlertDialog(
        context: context,
        title: '确定要放弃编辑？',
        okLabel: '放弃',
        cancelLabel: '继续编辑',
        isDestructiveAction: true,
      );
      if (result == OkCancelResult.ok) {
        EasyLoading.showToast('已放弃编辑！');
        return true;
      }
      return false;
    }
    EasyLoading.showToast('无修改！');
    return true;
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
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.close),
            color: Colors.red,
            onPressed: () async {
              if (await checkAndIsBack()) {
                Get.back(result: _fragment);
              }
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.check, color: Colors.green),
              onPressed: () async {
                EasyLoading.show();
                if (!isEdited()) {
                  EasyLoading.showToast('无修改！');
                  Get.back(result: _fragment);
                } else {
                  final newFragment = _fragment.copyWith(
                    question: _fragmentEdit.question,
                    answer: _fragmentEdit.answer,
                    description: _fragmentEdit.description,
                  );
                  // if (widget.folder != null) {
                  //   await _fragmentListPageGetXController.updateSerializeFragment(_fragment, newFragment);
                  // } else if (widget.memoryGroup != null) {
                  //   await _fragmentMemoryListPageGetXController.updateSerializeFragment(_fragment, newFragment);
                  // } else {
                  //   throw '发送异常: folder: ${widget.folder.toString()}, memoryGroup: ${widget.memoryGroup.toString()}';
                  // }
                  _fragment = newFragment;
                  Get.back(result: _fragment);
                  EasyLoading.showSuccess('修改成功！');
                }
              },
            )
          ],
        ),
        body: Form(
          key: _formKey,
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
              child: Card(
                margin: const EdgeInsets.all(10),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text('问题：'),
                          Expanded(
                            child: TextFormField(
                              minLines: 5,
                              maxLines: 5,
                              initialValue: _fragment.question,
                              decoration: const InputDecoration(
                                filled: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(5),
                                hintText: '请输入问题',
                                border: InputBorder.none,
                              ),
                              onSaved: (String? value) {
                                _fragmentEdit.question = value;
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
                              minLines: 5,
                              maxLines: 5,
                              initialValue: _fragment.answer,
                              decoration: const InputDecoration(
                                filled: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(5),
                                hintText: '请输入答案',
                                border: InputBorder.none,
                              ),
                              onSaved: (String? value) {
                                _fragmentEdit.answer = value;
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
                              minLines: 5,
                              maxLines: 5,
                              initialValue: _fragment.description,
                              decoration: const InputDecoration(
                                filled: true,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.all(5),
                                hintText: '请输入描述',
                                border: InputBorder.none,
                              ),
                              onSaved: (String? value) {
                                _fragmentEdit.description = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
