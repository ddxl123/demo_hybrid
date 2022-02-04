import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentSnapshotPage.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RememberingPage extends StatefulWidget {
  const RememberingPage({Key? key}) : super(key: key);

  @override
  _RememberingPageState createState() => _RememberingPageState();
}

class _RememberingPageState extends State<RememberingPage> {
  final RefreshController _refreshController = RefreshController(initialRefresh: true);
  final List<Fragment> _fragments = <Fragment>[];
  int _offset = 0;

  RememberStatus _rememberStatus = RememberStatus.none;

  Future<void> _getAndSetSerializeFragments() async {
    final result = await DriftDb.instance.retrieveDAO.getRemember2Fragments(offset: _offset, limit: 5);
    _fragments.addAll(result);
    _offset += result.length;
  }

  Future<void> _clearAndSet() async {
    _fragments.clear();
    _offset = 0;
    await _getAndSetSerializeFragments();
  }

  Future<void> _getToPage() async {
    final result = await Get.to(() => const RememberingRunPage());
    if (result == true) {
      _rememberStatus = RememberStatus.none;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    DriftDb.instance.retrieveDAO.getRemembering().then(
      (value) {
        if (value == null) {
          _rememberStatus = RememberStatus.none;
        } else {
          _rememberStatus = RememberStatus.values[value.status];
        }
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任务列表'),
        actions: [
          MaterialButton(
            child: const Text('取消任务'),
            onPressed: () {},
          ),
        ],
      ),
      body: SmartRefresher(
        footer: const ClassicFooter(
          height: 120,
          loadingText: '获取中...',
          idleText: '上拉刷新',
          canLoadingText: '可以松手了',
          failedText: '刷新失败！',
          noDataText: '没有更多数据',
        ),
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        controller: _refreshController,
        enablePullUp: true,
        enablePullDown: true,
        header: const WaterDropMaterialHeader(),
        child: ListView.builder(
          itemCount: _fragments.length,
          itemBuilder: (BuildContext context, int index) {
            return RememberingPageFragmentButton(fragment: _fragments[index]);
          },
        ),
        onRefresh: () async {
          await _clearAndSet();
          _refreshController.refreshCompleted();
          setState(() {});
        },
        onLoading: () async {
          await _getAndSetSerializeFragments();
          _refreshController.loadComplete();
          setState(() {});
        },
      ),
      floatingActionButton: () {
        if (_rememberStatus == RememberStatus.none) {
          return FloatingActionButton(
            backgroundColor: Colors.orangeAccent,
            child: const Text('未开始'),
            onPressed: () async {
              final int? result = await showModalActionSheet<int>(
                context: context,
                title: '请选择一种方式：',
                actions: [
                  const SheetAction(key: 1, label: '随机可重复', isDestructiveAction: true),
                  const SheetAction(key: 0, label: '随机不可重复', isDestructiveAction: true),
                ],
              );
              if (result == 0) {
                _rememberStatus = RememberStatus.randomNotRepeat;
                setState(() {});
                _getToPage();
              } else if (result == 1) {
                _rememberStatus = RememberStatus.randomRepeat;
                setState(() {});
                _getToPage();
              }
            },
          );
        } else if (_rememberStatus == RememberStatus.randomNotRepeat) {
          _getToPage();
        } else if (_rememberStatus == RememberStatus.randomRepeat) {
          _getToPage();
        } else {
          throw '未知 _rememberStatus: ${_rememberStatus.toString()}';
        }
      }(),
    );
  }
}

class RememberingPageFragmentButton extends StatefulWidget {
  const RememberingPageFragmentButton({Key? key, required this.fragment}) : super(key: key);
  final Fragment fragment;

  @override
  _RememberingPageFragmentButtonState createState() => _RememberingPageFragmentButtonState();
}

class _RememberingPageFragmentButtonState extends State<RememberingPageFragmentButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color.fromRGBO(0, 0, 0, 0.2)))),
      child: TextButton(
        child: Text(widget.fragment.question.toString()),
        onPressed: () {
          Get.to(() => FragmentSnapshotPage(fragment: widget.fragment, isEnableEdit: false));
        },
      ),
    );
  }
}

class RememberingRunPage extends StatefulWidget {
  const RememberingRunPage({Key? key}) : super(key: key);

  @override
  _RememberingRunPageState createState() => _RememberingRunPageState();
}

class _RememberingRunPageState extends State<RememberingRunPage> {
  Fragment? _lastFragment;
  late Fragment _fragment;
  late final RememberStatus _rememberStatus;

  Future<void> _getInitFragment() async {
    final result = await DriftDb.instance.retrieveDAO.getRemembering();
    if (result == null) {
      EasyLoading.showToast('_getNextFragment 结果为 null, 但是仍然进入了 RememberingRunPage！');
      Get.back(result: true);
    } else {
      _rememberStatus = RememberStatus.values[result.status];
      // 这里说明，在正在记忆时，不能对 fragment 进行删除。
      _fragment = await DriftDb.instance.retrieveDAO.getSingleFragmentById(result.fragmentId!);
    }
  }

  Future<void> _getNextFragment() async {
    if (_rememberStatus == RememberStatus.randomNotRepeat) {
      final nr = await DriftDb.instance.retrieveDAO.getRandomNotRepeatRemember2Fragment();
      if (nr == null) {}
    }
  }

  @override
  void initState() {
    super.initState();
    _getInitFragment();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
