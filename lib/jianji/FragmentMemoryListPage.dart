import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/controller/FragmentMemoryListPageGetXController.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class FragmentMemoryListPage extends StatefulWidget {
  const FragmentMemoryListPage({Key? key, required this.memoryGroup}) : super(key: key);
  final MemoryGroup memoryGroup;

  @override
  _FragmentMemoryListPageState createState() => _FragmentMemoryListPageState();
}

class _FragmentMemoryListPageState extends State<FragmentMemoryListPage> {
  late final FragmentMemoryListPageGetXController _fragmentMemoryListPageGetXController;

  @override
  void initState() {
    super.initState();
    _fragmentMemoryListPageGetXController = Get.find<FragmentMemoryListPageGetXController>(tag: widget.memoryGroup.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('记忆组：' + widget.memoryGroup.title.toString()),
        actions: const <Widget>[
          // IconButton(
          //   icon: const Icon(Icons.add),
          //   onPressed: () {},
          // )
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
          controller: _fragmentMemoryListPageGetXController.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _fragmentMemoryListPageGetXController.fragmentMemorys.isEmpty ? 1 : _fragmentMemoryListPageGetXController.fragmentMemorys.length,
            itemBuilder: (BuildContext context, int index) {
              if (_fragmentMemoryListPageGetXController.fragmentMemorys.isEmpty) {
                return const Text('还没有加入知识点！', textAlign: TextAlign.center);
              }
              return FragmentMemoryButton(fragment: _fragmentMemoryListPageGetXController.fragmentMemorys[index], memoryGroup: widget.memoryGroup);
            },
          ),
          onRefresh: () async {
            await _fragmentMemoryListPageGetXController.clearViewAndReGetSerializeFragmentMemorys(widget.memoryGroup);
            _fragmentMemoryListPageGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            await _fragmentMemoryListPageGetXController.getManySerializeFragmentMemorys(widget.memoryGroup);
            _fragmentMemoryListPageGetXController.refreshController.loadComplete();
          },
        ),
      ),
    );
  }
}

class FragmentMemoryButton extends StatefulWidget {
  const FragmentMemoryButton({Key? key, required this.fragment, required this.memoryGroup}) : super(key: key);
  final MemoryGroup memoryGroup;
  final Fragment fragment;

  @override
  _FragmentMemoryButtonState createState() => _FragmentMemoryButtonState();
}

class _FragmentMemoryButtonState extends State<FragmentMemoryButton> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  late final FragmentMemoryListPageGetXController _fragmentMemoryListPageGetXController;

  @override
  void initState() {
    super.initState();
    _fragmentMemoryListPageGetXController = Get.find<FragmentMemoryListPageGetXController>(tag: widget.memoryGroup.hashCode.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Container(
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text(widget.fragment.question.toString())),
            ],
          ),
          style: const ButtonStyle(alignment: Alignment.centerLeft),
          onPressed: () async {
            Get.to(
              () => FragmentSnapshotPage(
                initEnterFragment: widget.fragment,
                pageTurningFragments: _fragmentMemoryListPageGetXController.fragmentMemorys,
                isEnableEdit: true,
                isSecret: true,
                onUpdateSerialize: (Fragment oldFragment, Fragment newFragment) async {
                  await _fragmentMemoryListPageGetXController.updateSerializeFragmentMemory(oldFragment, newFragment);
                },
              ),
            );
          },
          onLongPress: () async {
            final OkCancelResult result = await showOkCancelAlertDialog(
                context: context,
                title: '是否从该记忆组中移除下面知识点？（不会删除该知识点）\n${widget.fragment.question}',
                okLabel: '移除',
                cancelLabel: '取消',
                isDestructiveAction: true);
            if (result == OkCancelResult.ok) {
              if (_globalGetXController.isRemembering.value) {
                EasyLoading.showToast('当前已有正在执行的记忆任务，只能新增不能删除！');
              } else {
                EasyLoading.show();
                await _fragmentMemoryListPageGetXController.deleteSingleSerializeFragmentMemory(widget.memoryGroup, widget.fragment);
                EasyLoading.showSuccess('移除成功！');
              }
            }
          },
        ),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
      ),
    );
  }
}
