import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/drift/db/DriftDb.dart';
import 'package:hybrid/jianji/FragmentEditPage.dart';
import 'package:hybrid/jianji/controller/GlobalGetXController.dart';
import 'package:hybrid/jianji/controller/RememberingPageGetXController.dart';

class FragmentSnapshotPageController {
  FragmentSnapshotPageController(this.state);

  final _FragmentSnapshotPageState state;

  void refreshFragment(Fragment fragment) {
    state.currentFragment = fragment;
    if (state.mounted) state.setState(() {});
  }

  void refreshHide(bool isHide) {
    state._isTapHide = isHide;
    if (state.mounted) state.setState(() {});
  }
}

class FragmentSnapshotPage extends StatefulWidget {
  const FragmentSnapshotPage({
    Key? key,
    required this.initEnterFragment,
    required this.isEnableEdit,
    required this.pageTurningFragments,
    required this.isSecret,
    required this.onUpdateSerialize,
    this.appBar,
    this.body,
    this.putFragmentSnapshotPageController,
    this.isRelyOnQuestionAndAnswerExchange = false,
  }) : super(key: key);

  // final Folder? folder;
  // final MemoryGroup? memoryGroup;

  /// 进入快照时的 [Fragment]。
  final Fragment initEnterFragment;

  /// 是否在导航栏右侧显示编辑选项。
  final bool isEnableEdit;

  /// 是否可翻页，为 null 时表示不可翻页。
  final List<Fragment>? pageTurningFragments;

  /// 是否隐藏答案和描述
  final bool isSecret;

  final Future<void> Function(Fragment oldFragment, Fragment newFragment)? onUpdateSerialize;

  final AppBar? appBar;

  final Widget? body;

  final void Function(FragmentSnapshotPageController fragmentSnapshotPageController)? putFragmentSnapshotPageController;

  final bool isRelyOnQuestionAndAnswerExchange;

  @override
  _FragmentSnapshotPageState createState() => _FragmentSnapshotPageState();
}

class _FragmentSnapshotPageState extends State<FragmentSnapshotPage> {
  final GlobalGetXController _globalGetXController = Get.find<GlobalGetXController>();
  final RememberPageGetXController _rememberPageGetXController = Get.find<RememberPageGetXController>();

  final ScrollController _scrollController = ScrollController();

  late final FragmentSnapshotPageController fragmentSnapshotPageController;

  late Fragment currentFragment;
  bool _isTapHide = true;

  bool get _isHide => widget.isSecret ? _isTapHide : false;

  @override
  void initState() {
    super.initState();
    currentFragment = widget.initEnterFragment;
    fragmentSnapshotPageController = FragmentSnapshotPageController(this);
    widget.putFragmentSnapshotPageController?.call(fragmentSnapshotPageController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.appBar ??
          AppBar(
            elevation: 0,
            leading: const BackButton(color: Colors.blue),
            backgroundColor: Colors.white,
            actions: [
              widget.isEnableEdit
                  ? IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () async {
                        final Fragment newFragment = await Get.to(() => FragmentEditPage(fragment: currentFragment));
                        await widget.onUpdateSerialize?.call(currentFragment, newFragment);
                        currentFragment = newFragment;
                        if (mounted) setState(() {});
                      },
                    )
                  : Container(),
            ],
          ),
      body: widget.body ??
          Stack(
            children: [
              GestureDetector(
                onTap: () {
                  _isTapHide = !_isTapHide;
                  setState(() {});
                },
                child: SingleChildScrollView(
                  controller: _scrollController,
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
                              child: Row(children: [
                                Expanded(child: Text(() {
                                  if (!widget.isRelyOnQuestionAndAnswerExchange) {
                                    return currentFragment.question.toString();
                                  } else {
                                    return _rememberPageGetXController.isQuestionAndAnswerExchange.value
                                        ? currentFragment.answer.toString()
                                        : currentFragment.question.toString();
                                  }
                                }()))
                              ]),
                              padding: const EdgeInsets.all(5),
                            ),
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (!_isHide) const Text('答案：'),
                        if (!_isHide) const SizedBox(height: 10),
                        if (!_isHide)
                          Expanded(
                            child: DottedBorder(
                              child: SingleChildScrollView(
                                child: Row(children: [
                                  Expanded(child: Text(() {
                                    if (!widget.isRelyOnQuestionAndAnswerExchange) {
                                      return currentFragment.answer.toString();
                                    } else {
                                      return _rememberPageGetXController.isQuestionAndAnswerExchange.value
                                          ? currentFragment.question.toString()
                                          : currentFragment.answer.toString();
                                    }
                                  }()))
                                ]),
                                padding: const EdgeInsets.all(5),
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        if (!_isHide) const SizedBox(height: 20),
                        if (!_isHide) const Text('描述：'),
                        if (!_isHide) const SizedBox(height: 10),
                        if (!_isHide)
                          Expanded(
                            child: DottedBorder(
                              child: SingleChildScrollView(
                                child: Row(children: [Expanded(child: Text(currentFragment.description.toString()))]),
                                padding: const EdgeInsets.all(5),
                              ),
                              color: Colors.grey,
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [Text('轻触页面任意位置可隐藏/显示', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))],
                        ),
                        const SizedBox(height: 150),
                      ],
                    ),
                  ),
                ),
              ),
              if (widget.pageTurningFragments != null)
                Positioned(
                  bottom: 50,
                  left: 100,
                  child: Transform.scale(
                    scale: 2,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.chevron_left, color: Colors.blue),
                      heroTag: 'left',
                      onPressed: () {
                        final ptfs = widget.pageTurningFragments;
                        if (ptfs != null) {
                          final int currentIndex = ptfs.indexOf(currentFragment);
                          currentFragment = ptfs[currentIndex == 0 ? currentIndex : currentIndex - 1];
                          _scrollController.jumpTo(0.0);
                          _isTapHide = true;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
              if (widget.pageTurningFragments != null)
                Positioned(
                  bottom: 50,
                  right: 100,
                  child: Transform.scale(
                    scale: 2,
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: const Icon(Icons.chevron_right, color: Colors.blue),
                      heroTag: 'right',
                      onPressed: () {
                        final ptfs = widget.pageTurningFragments;
                        if (ptfs != null) {
                          final int currentIndex = ptfs.indexOf(currentFragment);
                          currentFragment = ptfs[currentIndex == ptfs.length - 1 ? currentIndex : currentIndex + 1];
                          _scrollController.jumpTo(0.0);
                          _isTapHide = true;
                          setState(() {});
                        }
                      },
                    ),
                  ),
                ),
            ],
          ),
    );
  }
}
