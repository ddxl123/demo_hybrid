import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'controller/GlobalGetXController.dart';

class MemoryGroupPage extends StatefulWidget {
  const MemoryGroupPage({Key? key}) : super(key: key);

  @override
  _MemoryGroupPageState createState() => _MemoryGroupPageState();
}

class _MemoryGroupPageState extends State<MemoryGroupPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final List<MemoryGroup> memoryGroups = <MemoryGroup>[];

  /// 不包含 offset 本身。
  int offset = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('记忆组'),
        actions: <Widget>[IconButton(onPressed: () async {}, icon: const Icon(Icons.add))],
      ),
      body: SmartRefresher(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
        header: const WaterDropMaterialHeader(),
        child: ListView.builder(
          itemCount: memoryGroups.length,
          itemBuilder: (BuildContext context, int index) {
            return MemoryGroupButton(memoryGroup: memoryGroups[index]);
          },
        ),
        onRefresh: () async {
          memoryGroups.clear();
          offset = 0;
          memoryGroups.addAll((await DriftDb.instance.retrieveDAO.getMemoryGroups(offset, 5)));
          offset = memoryGroups.length;
          setState(() {});
          _refreshController.refreshCompleted();
        },
        onLoading: () async {
          memoryGroups.addAll((await DriftDb.instance.retrieveDAO.getMemoryGroups(offset, 5)));
          offset = memoryGroups.length;
          setState(() {});
          _refreshController.loadComplete();
        },
      ),
    );
  }
}

class MemoryGroupButton extends StatefulWidget {
  const MemoryGroupButton({Key? key, required this.memoryGroup}) : super(key: key);
  final MemoryGroup memoryGroup;

  @override
  _MemoryGroupButtonState createState() => _MemoryGroupButtonState();
}

class _MemoryGroupButtonState extends State<MemoryGroupButton> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(child: Text(widget.memoryGroup.title.toString())),
            Obx(() {
              if (_globalGetXController.isSelectModel.value) {
                return Text(((_globalGetXController.selecteds[widget.memoryGroup.id]?.length) ?? 0).toString(), style: const TextStyle(color: Colors.green));
              } else {
                return Container();
              }
            }),
          ],
        ),
        style: const ButtonStyle(alignment: Alignment.centerLeft),
        onPressed: () async {},
        onLongPress: () async {},
      ),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
    );
  }
}
