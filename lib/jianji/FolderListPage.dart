import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentListPage.dart';
import 'package:hybrid/jianji/controller/FolderListPageGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'controller/GlobalGetXController.dart';

class FolderListPage extends StatefulWidget {
  const FolderListPage({Key? key}) : super(key: key);

  @override
  _FolderListPageState createState() => _FolderListPageState();
}

class _FolderListPageState extends State<FolderListPage> with AutomaticKeepAliveClientMixin {
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
                _folderListPageGetXController
                    .addFolder(await DriftDb.instance.insertDAO.insertFolder(FoldersCompanion.insert(title: drift.Value(result.first))));
              }
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Obx(
        () => SmartRefresher(
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
            _folderListPageGetXController.folders.clear();
            _folderListPageGetXController.offset = 0;
            _folderListPageGetXController.folders.addAll((await DriftDb.instance.retrieveDAO.getFolders(_folderListPageGetXController.offset, 5)));
            _folderListPageGetXController.offset = _folderListPageGetXController.folders.length;
            _folderListPageGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            _folderListPageGetXController.folders.addAll((await DriftDb.instance.retrieveDAO.getFolders(_folderListPageGetXController.offset, 5)));
            _folderListPageGetXController.offset = _folderListPageGetXController.folders.length;
            _folderListPageGetXController.refreshController.loadComplete();
          },
        ),
      ),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text(widget.folder.title.toString())),
            Obx(() {
              if (_globalGetXController.isSelectModel.value) {
                return Text(((_globalGetXController.selecteds[widget.folder.id]?.length) ?? 0).toString(), style: const TextStyle(color: Colors.green));
              } else {
                return Container();
              }
            }),
          ],
        ),
        style: const ButtonStyle(alignment: Alignment.centerLeft),
        onPressed: () async {
          Get.to(FragmentListPage(folder: widget.folder));
        },
        onLongPress: () async {
          final OkCancelResult result =
              await showOkCancelAlertDialog(context: context, title: '确定删除？', okLabel: '确定', cancelLabel: '取消', isDestructiveAction: true);
          if (result == OkCancelResult.ok) {
            EasyLoading.show();
            await DriftDb.instance.deleteDAO.deleteFolderWith(widget.folder);
            EasyLoading.showSuccess('删除成功！');
            _folderListPageGetXController.removeFolder(widget.folder);
          }
        },
      ),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
    );
  }
}
