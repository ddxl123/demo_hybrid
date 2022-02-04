import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentMemoryListPage.dart';
import 'package:hybrid/jianji/RememberingPage.dart';
import 'package:hybrid/jianji/controller/JianJiHomeGetXController.dart';
import 'package:hybrid/jianji/controller/MemoryGroupListGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'controller/FragmentMemoryListPageGetXController.dart';
import 'controller/GlobalGetXController.dart';

class MemoryGroupListPage extends StatefulWidget {
  const MemoryGroupListPage({Key? key}) : super(key: key);

  @override
  _MemoryGroupListPageState createState() => _MemoryGroupListPageState();
}

class _MemoryGroupListPageState extends State<MemoryGroupListPage> with AutomaticKeepAliveClientMixin {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final MemoryGroupListGetXController _memoryGroupListGetXController = Get.find<MemoryGroupListGetXController>();
  final JianJiHomeGetXController _jianJiHomeGetXController = Get.find<JianJiHomeGetXController>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('记忆组'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final List<String>? result = await showTextInputDialog(
                context: context,
                title: '创建记忆组：',
                textFields: <DialogTextField>[
                  const DialogTextField(hintText: '请输入名称'),
                ],
                okLabel: '创建',
                cancelLabel: '取消',
                isDestructiveAction: true,
              );
              if (result != null) {
                if (result.isNotEmpty && result.first != '') {
                  EasyLoading.show();
                  await _memoryGroupListGetXController.insertSerializeMemoryGroup(MemoryGroupsCompanion.insert(title: drift.Value(result.first)));
                  EasyLoading.showSuccess('创建成功！');
                } else {
                  EasyLoading.showToast('未输入名称');
                }
              }
            },
          ),
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          footer: ClassicFooter(
            height: 120,
            loadingText: '获取中...',
            idleText: '上拉刷新',
            canLoadingText: '可以松手了',
            failedText: '刷新失败！',
            noDataText: '没有更多数据',
            outerBuilder: (child) {
              return Padding(padding: const EdgeInsets.fromLTRB(0, 0, 0, 100), child: child);
            },
          ),
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: _memoryGroupListGetXController.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _memoryGroupListGetXController.memoryGroups.isEmpty ? 1 : _memoryGroupListGetXController.memoryGroups.length,
            itemBuilder: (BuildContext context, int index) {
              if (_memoryGroupListGetXController.memoryGroups.isEmpty) {
                return const Text('还没有创建过记忆组！', textAlign: TextAlign.center);
              }
              return MemoryGroupButton(memoryGroup: _memoryGroupListGetXController.memoryGroups[index]);
            },
          ),
          onRefresh: () async {
            _memoryGroupListGetXController.clearViewMemoryGroups();
            await _memoryGroupListGetXController.getSerializeMemoryGroups();
            _memoryGroupListGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            await _memoryGroupListGetXController.getSerializeMemoryGroups();
            _memoryGroupListGetXController.refreshController.loadComplete();
          },
        ),
      ),
      floatingActionButton: Obx(
        () {
          if (_globalGetXController.isGroupModel()) {
            return _globalGetXController.groupModelFloatingButton(context);
          } else {
            return Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 20, 60),
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                child: Text(_globalGetXController.isMemoryModel() ? _globalGetXController.selectedCountForMemoryModel().toString() : '记'),
                heroTag: Object().hashCode.toString(),
                onPressed: () async {
                  if (_globalGetXController.isRemembering.value) {
                    EasyLoading.showToast('当前已有正在执行的记忆任务！');
                    return;
                  }
                  if (_memoryGroupListGetXController.memoryGroups.isEmpty) {
                    EasyLoading.showToast('请先创建记忆组！');
                  } else {
                    if (_globalGetXController.isMemoryModel()) {
                      final int? result = await showModalActionSheet(
                        context: context,
                        actions: <SheetAction<int>>[
                          const SheetAction(key: 2, label: '清空已选记忆组', isDestructiveAction: true),
                          const SheetAction(key: 1, label: '开始记忆', isDestructiveAction: true),
                          const SheetAction(key: 0, label: '退出记忆模式'),
                        ],
                        title: '',
                        message: '即将记忆的知识点数量 ${_globalGetXController.selectedCountForMemoryModel.value}',
                        cancelLabel: '取消',
                      );
                      if (result == 0) {
                        _globalGetXController.changeSelectModelToNone();
                        EasyLoading.showToast('已退出记忆模式！');
                      } else if (result == 1) {
                        // 开始记忆
                        if (_globalGetXController.selectedCountForMemoryModel.value == 0) {
                          EasyLoading.showToast('选择知识点数量为0\n（在 记忆组 中选择）');
                        } else {
                          // 启动记忆。
                          EasyLoading.showToast('已开始记忆！返回或重启应用不会影响记忆进度！');
                          _globalGetXController.writeRemembers();
                          Get.to(() => const RememberingPage());
                        }
                      } else if (result == 2) {
                        _globalGetXController.cancelSelectedAllForMemoryModel();
                        EasyLoading.showToast('已清空已选记忆组！');
                      }
                    } else {
                      _globalGetXController.changeSelectModelToMemory();
                      // 重置记忆模式，以防知识点被删除，导致数量不正确。
                      _globalGetXController.cancelSelectedAllForMemoryModel();
                      EasyLoading.showToast('已切换记忆模式！');
                    }
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MemoryGroupButton extends StatefulWidget {
  const MemoryGroupButton({Key? key, required this.memoryGroup}) : super(key: key);
  final MemoryGroup memoryGroup;

  @override
  _MemoryGroupButtonState createState() => _MemoryGroupButtonState();
}

class _MemoryGroupButtonState extends State<MemoryGroupButton> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final MemoryGroupListGetXController _memoryGroupListGetXController = Get.find<MemoryGroupListGetXController>();
  late final FragmentMemoryListPageGetXController _fragmentMemoryListPageGetXController;

  @override
  void initState() {
    super.initState();
    _fragmentMemoryListPageGetXController = Get.put(FragmentMemoryListPageGetXController(), tag: widget.memoryGroup.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Container(
          child: TextButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text(widget.memoryGroup.title.toString())),
                Text(_fragmentMemoryListPageGetXController.serializeFragmentMemorysCount.value.toString()),
                () {
                  if (_globalGetXController.isGroupModel()) {
                    return IconButton(
                      icon: Icon(
                        Icons.circle,
                        color: _globalGetXController.selectedMemoryGroupsForGroupModel.contains(widget.memoryGroup.id) ? Colors.orange : Colors.grey,
                      ),
                      iconSize: 15,
                      onPressed: () {
                        if (_globalGetXController.selectedMemoryGroupsForGroupModel.contains(widget.memoryGroup.id)) {
                          _globalGetXController.selectedMemoryGroupsForGroupModel.remove(widget.memoryGroup.id);
                        } else {
                          _globalGetXController.selectedMemoryGroupsForGroupModel.add(widget.memoryGroup.id);
                        }
                      },
                    );
                  } else if (_globalGetXController.isMemoryModel()) {
                    return IconButton(
                      icon: Icon(
                        Icons.circle,
                        color: _globalGetXController.selectedMemoryGroupsForMemoryModel.containsKey(widget.memoryGroup.id) ? Colors.green : Colors.grey,
                      ),
                      iconSize: 15,
                      onPressed: () {
                        if (_globalGetXController.selectedMemoryGroupsForMemoryModel.containsKey(widget.memoryGroup.id)) {
                          _globalGetXController.cancelSelectedSingleForMemoryModel(
                            widget.memoryGroup,
                            _fragmentMemoryListPageGetXController.serializeFragmentMemorysCount.value,
                          );
                        } else {
                          _globalGetXController.addSelectedSingleForMemoryModel(
                            widget.memoryGroup,
                            _fragmentMemoryListPageGetXController.serializeFragmentMemorysCount.value,
                          );
                        }
                      },
                    );
                  } else {
                    return Container();
                  }
                }(),
              ],
            ),
            style: const ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () async {
              Get.to(() => FragmentMemoryListPage(memoryGroup: widget.memoryGroup));
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
                  EasyLoading.showToast('记忆模式下不能进行删除！');
                } else {
                  EasyLoading.show();
                  await _memoryGroupListGetXController.deleteSerializeMemoryGroup(widget.memoryGroup);
                  EasyLoading.showSuccess('删除成功！');
                }
              }
            },
          ),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
        );
      },
    );
  }
}
