import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentEditPage.dart';

class FragmentSnapshotPage extends StatefulWidget {
  const FragmentSnapshotPage({Key? key, required this.fragment, this.folder, this.memoryGroup, this.isEnableEdit = true}) : super(key: key);
  final Folder? folder;
  final MemoryGroup? memoryGroup;
  final Fragment fragment;
  final bool isEnableEdit;

  @override
  _FragmentSnapshotPageState createState() => _FragmentSnapshotPageState();
}

class _FragmentSnapshotPageState extends State<FragmentSnapshotPage> {
  late Fragment _fragment;

  @override
  void initState() {
    super.initState();
    _fragment = widget.fragment;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.isEnableEdit
              ? IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    _fragment = await Get.to(() => FragmentEditPage(fragment: _fragment, folder: widget.folder, memoryGroup: widget.memoryGroup));
                    if (mounted) setState(() {});
                  },
                )
              : Container(),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('问题：'),
              const SizedBox(height: 10),
              Expanded(
                child: DottedBorder(
                  child: SingleChildScrollView(
                    child: Row(children: [Expanded(child: Text(_fragment.question.toString()))]),
                    padding: const EdgeInsets.all(5),
                  ),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text('答案：'),
              const SizedBox(height: 10),
              Expanded(
                child: DottedBorder(
                  child: SingleChildScrollView(
                    child: Row(children: [Expanded(child: Text(_fragment.answer.toString()))]),
                    padding: const EdgeInsets.all(5),
                  ),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              const Text('描述：'),
              const SizedBox(height: 10),
              Expanded(
                child: DottedBorder(
                  child: SingleChildScrollView(
                    child: Row(children: [Expanded(child: Text(_fragment.description.toString()))]),
                    padding: const EdgeInsets.all(5),
                  ),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
