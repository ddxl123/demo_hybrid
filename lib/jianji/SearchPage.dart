import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';

import 'FragmentSnapshotPage.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final List<Fragment> fragments = <Fragment>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.blue),
        backgroundColor: Colors.white,
        actions: [
          Container(
            color: Colors.white,
            child: TextField(
              decoration: const InputDecoration(iconColor: Colors.white, suffixIcon: Icon(Icons.search), hintText: '请输入搜索内容'),
              autofocus: true,
              onChanged: (String value) async {
                fragments.clear();
                fragments.addAll(await DriftDb.instance.retrieveDAO.getSearchFragment(value));
                if (mounted) setState(() {});
              },
            ),
            width: 200,
          ),
          IconButton(
            color: Colors.transparent,
            icon: const Icon(Icons.add, color: Colors.transparent),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: fragments.isEmpty ? 1 : fragments.length,
        itemBuilder: (BuildContext context, int index) {
          if (fragments.isEmpty) {
            return const Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0), child: Text('无结果', textAlign: TextAlign.center));
          }
          return Card(
            elevation: 1,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    child: Text(fragments[index].question.toString()),
                    style: const ButtonStyle(alignment: Alignment.centerLeft),
                    onPressed: () {
                      Get.to(
                        () => FragmentSnapshotPage(
                          initEnterFragment: fragments[index],
                          pageTurningFragments: null,
                          isEnableEdit: true,
                          isSecret: true,
                          onUpdateSerialize: (Fragment oldFragment, Fragment newFragment) async {
                            await DriftDb.instance.updateDAO.updateFragment(newFragment);
                            int oldIndex = fragments.indexOf(oldFragment);
                            fragments.remove(oldFragment);
                            fragments.insert(oldIndex, newFragment);
                            if (mounted) setState(() {});
                          },
                        ),
                      );
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
                            await DriftDb.instance.deleteDAO.deleteFragmentWith(fragments[index]);
                            fragments.removeAt(index);
                            if (mounted) setState(() {});
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
        },
      ),
    );
  }
}
