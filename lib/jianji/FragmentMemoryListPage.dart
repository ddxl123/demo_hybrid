import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/FragmentMemoryListPageGetXController.dart';
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
        title: Text(widget.memoryGroup.title.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
      body: Obx(
        () => SmartRefresher(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          controller: _fragmentMemoryListPageGetXController.refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: const WaterDropMaterialHeader(),
          child: ListView.builder(
            itemCount: _fragmentMemoryListPageGetXController.fragmentMemorys.isEmpty ? 1 : _fragmentMemoryListPageGetXController.fragmentMemorys.length,
            itemBuilder: (BuildContext context, int index) {
              if (_fragmentMemoryListPageGetXController.fragmentMemorys.isEmpty) {
                return const Text('还没有创建过类别！', textAlign: TextAlign.center);
              }
              return FragmentMemoryButton(fragment: _fragmentMemoryListPageGetXController.fragmentMemorys[index]);
            },
          ),
          onRefresh: () async {
            await _fragmentMemoryListPageGetXController.clearViewAndReGetSerializeFragmentMemorys(widget.memoryGroup);
            _fragmentMemoryListPageGetXController.refreshController.refreshCompleted();
          },
          onLoading: () async {
            await _fragmentMemoryListPageGetXController.getSerializeFragmentMemorys(widget.memoryGroup);
            _fragmentMemoryListPageGetXController.refreshController.loadComplete();
          },
        ),
      ),
    );
  }
}

class FragmentMemoryButton extends StatefulWidget {
  const FragmentMemoryButton({Key? key, required this.fragment}) : super(key: key);
  final Fragment fragment;

  @override
  _FragmentMemoryButtonState createState() => _FragmentMemoryButtonState();
}

class _FragmentMemoryButtonState extends State<FragmentMemoryButton> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
