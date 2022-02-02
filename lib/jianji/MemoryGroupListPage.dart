import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentMemoryListPage.dart';
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
            return FloatingActionButton(
              backgroundColor: Colors.green,
              child: const Text('记'),
              heroTag: Object().hashCode.toString(),
              onPressed: () {
                if (_memoryGroupListGetXController.memoryGroups.isEmpty) {
                  EasyLoading.showToast('请先创建记忆组！');
                }
              },
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
      () => Container(
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(widget.memoryGroup.title.toString())),
              Text(_fragmentMemoryListPageGetXController.serializeFragmentMemorysCount.value.toString()),
              () {
                if (_globalGetXController.isGroupModel()) {
                  return IconButton(
                    icon: Icon(Icons.circle,
                        color: _globalGetXController.selectedMemoryGroupsForGroupModel.contains(widget.memoryGroup.id) ? Colors.orange : Colors.grey),
                    iconSize: 15,
                    onPressed: () {
                      if (_globalGetXController.selectedMemoryGroupsForGroupModel.contains(widget.memoryGroup.id)) {
                        _globalGetXController.selectedMemoryGroupsForGroupModel.remove(widget.memoryGroup.id);
                      } else {
                        _globalGetXController.selectedMemoryGroupsForGroupModel.add(widget.memoryGroup.id);
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
            final OkCancelResult result =
                await showOkCancelAlertDialog(context: context, title: '确定删除？', okLabel: '确定', cancelLabel: '取消', isDestructiveAction: true);
            if (result == OkCancelResult.ok) {
              EasyLoading.show();
              await _memoryGroupListGetXController.deleteSerializeMemoryGroup(widget.memoryGroup);
              EasyLoading.showSuccess('删除成功！');
            }
          },
        ),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
      ),
    );
  }
}
