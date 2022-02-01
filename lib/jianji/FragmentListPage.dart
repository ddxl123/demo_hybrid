import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentCreatePage.dart';
import 'package:hybrid/jianji/controller/FragmentListPageGetXController.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
    _fragmentListPageGetXController = Get.put(FragmentListPageGetXController(), tag: widget.folder.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.folder.title.toString()),
        actions: <Widget>[
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
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: _fragmentListPageGetXController.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _fragmentListPageGetXController.fragments.isEmpty ? 1 : _fragmentListPageGetXController.fragments.length,
            itemBuilder: (BuildContext context, int index) {
              if (_fragmentListPageGetXController.fragments.isEmpty) {
                return const Text('还没有创建组！', textAlign: TextAlign.center);
              }
              return FragmentButton(fragment: _fragmentListPageGetXController.fragments[index], folder: widget.folder);
            },
          ),
          onRefresh: () async {
            _fragmentListPageGetXController.fragments.clear();
            _fragmentListPageGetXController.offset = 0;
            _fragmentListPageGetXController.fragments
                .addAll((await DriftDb.instance.retrieveDAO.getFragments(widget.folder, _fragmentListPageGetXController.offset, 5)));
            _fragmentListPageGetXController.offset = _fragmentListPageGetXController.fragments.length;
            _fragmentListPageGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            _fragmentListPageGetXController.fragments
                .addAll((await DriftDb.instance.retrieveDAO.getFragments(widget.folder, _fragmentListPageGetXController.offset, 5)));
            _fragmentListPageGetXController.offset = _fragmentListPageGetXController.fragments.length;
            _fragmentListPageGetXController.refreshController.loadComplete();
          },
        ),
      ),
      floatingActionButton: _globalGetXController.putGroupWidget(context),
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
    return Row(
      children: <Widget>[
        Expanded(
          child: TextButton(
            child: Text(widget.fragment.question.toString()),
            style: const ButtonStyle(alignment: Alignment.centerLeft),
            onPressed: () {},
            onLongPress: () async {
              final OkCancelResult result =
                  await showOkCancelAlertDialog(context: context, title: '确定删除？', okLabel: '确定', cancelLabel: '取消', isDestructiveAction: true);
              if (result == OkCancelResult.ok) {
                EasyLoading.show();
                await DriftDb.instance.deleteDAO.deleteFragmentWith(widget.fragment);
                EasyLoading.showSuccess('删除成功！');
                _fragmentListPageGetXController.removeFragment(widget.folder, widget.fragment);
              }
            },
          ),
        ),
        Obx(
          () {
            if (_globalGetXController.isSelectModel.value) {
              return IconButton(
                icon: const Icon(
                  Icons.circle,
                  size: 15,
                  color: Colors.green,
                ),
                onPressed: () {},
              );
            } else {
              return Container();
            }
          },
        ),
        Obx(
          () {
            if (_globalGetXController.isSelectModel.value) {
              return IconButton(
                icon: Icon(Icons.circle, size: 15, color: _globalGetXController.isSelected(widget.folder, widget.fragment) ? Colors.blue : Colors.grey),
                onPressed: () {
                  if (_globalGetXController.isSelected(widget.folder, widget.fragment)) {
                    _globalGetXController.cancelSelected(widget.folder, widget.fragment);
                  } else {
                    _globalGetXController.addSelected(widget.folder, widget.fragment);
                  }
                },
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }
}
