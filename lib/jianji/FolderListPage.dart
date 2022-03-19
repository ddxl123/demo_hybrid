import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentListPage.dart';
import 'package:hybrid/jianji/controller/FolderListPageGetXController.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'SearchPage.dart';
import 'controller/FragmentListPageGetXController.dart';
import 'controller/GlobalGetXController.dart';

String logContent = '> 头';

void addLog(String content) {
  logContent += '\n● $content';
}

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
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showAboutDialog(
                context: context,
                applicationName: '更新内容：',
                children: [
                  const Text('1. 新增了「批量创建单词/词组（大文本导入）」功能。', textAlign: TextAlign.left),
                  const SizedBox(height: 10),
                  const Text('2. 新增了「批量创建词义辨析（大文本导入）」功能。', textAlign: TextAlign.left),
                  const SizedBox(height: 10),
                  const Text('3. 新增了文字选中功能。', textAlign: TextAlign.left),
                  const SizedBox(height: 10),
                  const Text('4. 对选中的文字增加了浏览器搜索功能，可以直接利用浏览器搜索答案。', textAlign: TextAlign.left),
                  const SizedBox(height: 10),
                  const Text('5. 新增了悬浮窗弹出时震动提示功能。', textAlign: TextAlign.left),
                ],
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Get.to(() => const SearchPage());
            },
          ),
          IconButton(
            onPressed: () async {
              final List<String>? result = await showTextInputDialog(
                context: context,
                textFields: <DialogTextField>[
                  const DialogTextField(hintText: '类别名称'),
                ],
                title: '创建类别',
                okLabel: '创建',
                cancelLabel: '取消',
                isDestructiveAction: true,
              );
              if (result != null && result.isNotEmpty && result.first != '') {
                EasyLoading.show();

                await _folderListPageGetXController.insertSerializeFolder(
                  FoldersCompanion.insert(title: result.first.toValue()),
                );
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
    DriftDb.instance.retrieveDAO.getFolder2FragmentCount(widget.folder).then((value) => _fragmentListPageGetXController.serializeFragmentsCount.value = value);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Container(
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
            child: TextButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Icon(Icons.folder),
                  const SizedBox(
                    width: 10,
                  ),
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
                      await _folderListPageGetXController.deleteSerializeFolder(widget.folder);
                      EasyLoading.showSuccess('删除成功！');
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
