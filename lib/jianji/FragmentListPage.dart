import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentCreatePage.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/controller/FragmentListPageGetXController.dart';
import 'package:hybrid/util/sheetroute/Helper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(FragmentCreatePage(folder: widget.folder));
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
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextButton(
              child: Text(widget.fragment.question.toString()),
              style: const ButtonStyle(alignment: Alignment.centerLeft),
              onPressed: () {
                Get.to(() => FragmentSnapshotPage(folder: widget.folder, fragment: widget.fragment));
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
                  }
                  if (_globalGetXController.isMemoryModel()) {
                    EasyLoading.showToast('记忆模式下不能进行删除');
                  } else {
                    EasyLoading.show();
                    await _fragmentListPageGetXController.deleteSerializeFragment(widget.folder, widget.fragment);
                    EasyLoading.showSuccess('删除成功！');
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
                        onPressed: () {

                        },
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
