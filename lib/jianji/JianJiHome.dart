import 'dart:async';
import 'dart:developer';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class JianJiHome extends StatefulWidget {
  const JianJiHome({Key? key}) : super(key: key);

  @override
  _JianJiHomeState createState() => _JianJiHomeState();
}

class _JianJiHomeState extends State<JianJiHome> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final List<Folder> folders = <Folder>[];

  /// 已被选择的 folder。
  ///
  /// 清空或删除 [folders] 时，需要同时清空或删除 [selectedSet]。
  final Set<Folder> selectedSet = <Folder>{};

  /// 不包含 offset 本身。
  int offset = 0;

  /// 是否切换为多选状态。
  bool isEnableSelect = false;

  /// 是否全选。
  bool isSelectAll = false;

  // 双击返回键才会退出应用。
  int? _lastBackAppTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('你好！'),
        actions: <Widget>[
          if (isEnableSelect && !isSelectAll)
            MaterialButton(
              child: const Text('全选', style: TextStyle(color: Colors.white)),
              onPressed: () {
                isSelectAll = !isSelectAll;
                selectedSet.clear();
                selectedSet.addAll(folders);
                if (mounted) setState(() {});
              },
            ),
          if (isEnableSelect && isSelectAll)
            MaterialButton(
              child: const Text('全不选', style: TextStyle(color: Colors.white)),
              onPressed: () {
                isSelectAll = !isSelectAll;
                selectedSet.clear();
                if (mounted) setState(() {});
              },
            ),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          // 多选状态时，按返回键会先取消多选状态。
          if (isEnableSelect) {
            isEnableSelect = false;
            if (mounted) setState(() {});
            return false;
          }

          // 双击返回键才会退出应用。
          else {
            int now = DateTime.now().millisecondsSinceEpoch;
            if (_lastBackAppTime != null && now - _lastBackAppTime! < 1500) {
              return true;
            }
            _lastBackAppTime = now;
            Fluttertoast.showToast(msg: '再按一次退出！');
            await Future.delayed(
              const Duration(milliseconds: 1500),
              () {
                _lastBackAppTime = null;
              },
            );
            return false;
          }
        },
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: folders.length,
            itemBuilder: (BuildContext context, int index) {
              return FolderButton(folder: folders[index], jianJiHome: this);
            },
          ),
          onRefresh: () async {
            folders.clear();
            selectedSet.clear();
            offset = 0;
            folders.addAll(await DriftDb.instance.jianJiDAO.getFoldersByLimit(5, offset));
            offset = folders.length;
            setState(() {});
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            folders.addAll(await DriftDb.instance.jianJiDAO.getFoldersByLimit(5, offset));
            offset = folders.length;
            setState(() {});
            _refreshController.loadComplete();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
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
            await DriftDb.instance.jianJiDAO.addFolder(FoldersCompanion.insert(title: Value(result.first)));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FolderButton extends StatefulWidget {
  const FolderButton({Key? key, required this.folder, required this.jianJiHome}) : super(key: key);
  final Folder folder;
  final _JianJiHomeState jianJiHome;

  @override
  _FolderButtonState createState() => _FolderButtonState();
}

class _FolderButtonState extends State<FolderButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(child: Text(widget.folder.title.toString())),
          if (widget.jianJiHome.isEnableSelect)
            Checkbox(
              value: widget.jianJiHome.selectedSet.contains(widget.folder),
              onChanged: (bool? value) {
                log('value: $value');
                if (widget.jianJiHome.selectedSet.contains(widget.folder)) {
                  widget.jianJiHome.selectedSet.remove(widget.folder);
                } else {
                  widget.jianJiHome.selectedSet.add(widget.folder);
                }
                setState(() {});
              },
            ),
        ],
      ),
      style: const ButtonStyle(alignment: Alignment.centerLeft),
      onPressed: () async {},
      onLongPress: () async {
        // 长按进入多选状态。
        if (widget.jianJiHome.isEnableSelect) return;
        widget.jianJiHome.isEnableSelect = true;
        if (widget.jianJiHome.mounted) widget.jianJiHome.setState(() {});
      },
    );
  }
}
