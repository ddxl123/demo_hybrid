import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentListPage.dart';
import 'package:hybrid/jianji/controller/FolderListPageGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'controller/FragmentListPageGetXController.dart';
import 'controller/GlobalGetXController.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({Key? key}) : super(key: key);

  @override
  _FolderListPageState createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> with AutomaticKeepAliveClientMixin {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final FolderListPageGetXController _folderListPageGetXController = Get.put(FolderListPageGetXController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('知识类别'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              final List<String>? result = await showTextInputDialog(
                context: context,
                textFields: <DialogTextField>[
                  const DialogTextField(hintText: '文件夹名称'),
                ],
                title: '创建文件夹',
                okLabel: '创建',
                cancelLabel: '取消',
                isDestructiveAction: true,
              );
              if (result != null && result.isNotEmpty && result.first != '') {
                EasyLoading.show();
                await _folderListPageGetXController.insertSerializeFolder(FoldersCompanion.insert(title: drift.Value(result.first)));
                EasyLoading.showSuccess('创建成功！');
              }
            },
            icon: const Icon(Icons.add),
          )
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
          controller: _folderListPageGetXController.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _folderListPageGetXController.folders.isEmpty ? 1 : _folderListPageGetXController.folders.length,
            itemBuilder: (BuildContext context, int index) {
              if (_folderListPageGetXController.folders.isEmpty) {
                return const Text('还没有创建过类别！', textAlign: TextAlign.center);
              }
              return FolderButton(folder: _folderListPageGetXController.folders[index]);
            },
          ),
          onRefresh: () async {
            _folderListPageGetXController.clearViewFolders();
            await _folderListPageGetXController.getSerializeFolders();
            _folderListPageGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            await _folderListPageGetXController.getSerializeFolders();
            _folderListPageGetXController.refreshController.loadComplete();
          },
        ),
      ),
      floatingActionButton: _globalGetXController.groupModelFloatingButton(context),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FolderButton extends StatefulWidget {
  const FolderButton({Key? key, required this.folder}) : super(key: key);
  final Folder folder;

  @override
  _FolderButtonState createState() => _FolderButtonState();
}

class _FolderButtonState extends State<FolderButton> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final FolderListPageGetXController _folderListPageGetXController = Get.find<FolderListPageGetXController>();
  late final FragmentListPageGetXController _fragmentListPageGetXController;

  @override
  void initState() {
    super.initState();
    _fragmentListPageGetXController = Get.put(FragmentListPageGetXController(), tag: widget.folder.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(widget.folder.title.toString())),
              Text(_fragmentListPageGetXController.serializeFragmentsCount.toString()),
              () {
                if (_globalGetXController.isGroupModel()) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    child: Text(
                      ((_globalGetXController.selectedsForGroupModel[widget.folder.id]?.length) ?? 0).toString(),
                      style: const TextStyle(color: Colors.orange),
                    ),
                  );
                } else {
                  return Container();
                }
              }(),
            ],
          ),
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () async {
            Get.to(() => FragmentListPage(folder: widget.folder));
          },
          onLongPress: () async {
            final OkCancelResult result =
                await showOkCancelAlertDialog(context: context, title: '确定删除？', okLabel: '确定', cancelLabel: '取消', isDestructiveAction: true);
            if (result == OkCancelResult.ok) {
              EasyLoading.show();
              await _folderListPageGetXController.deleteSerializeFolder(widget.folder);
              EasyLoading.showSuccess('删除成功！');
            }
          },
        ),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
      ),
    );
  }
}
