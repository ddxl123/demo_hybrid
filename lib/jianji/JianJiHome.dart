import 'dart:async';
import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/jianji/FolderListPage.dart';
import 'package:hybrid/jianji/MemoryGroupListPage.dart';
import 'package:hybrid/jianji/controller/JianJiHomeGetXController.dart';

import 'controller/GlobalGetXController.dart';
import 'controller/MemoryGroupListGetXController.dart';

class JianJiHome extends StatefulWidget {
  const JianJiHome({Key? key}) : super(key: key);

  @override
  _JianJiHomeState createState() => _JianJiHomeState();
}

class _JianJiHomeState extends State<JianJiHome> {
  final GlobalGetXController _globalGetXController = Get.put(GlobalGetXController());

  final JianJiHomeGetXController _jianJiHomeGetXController = Get.put(JianJiHomeGetXController());
  final MemoryGroupListGetXController _memoryGroupListGetXController = Get.put(MemoryGroupListGetXController());

  /// 当前 [CurvedNavigationBar] 的 index。
  /// 0 表示 Folder 页，1表示 记忆组 页。
  int _currentBody = 0;

  // 双击返回键才会退出应用。
  int? _lastBackAppTime;

  final GlobalKey<CurvedNavigationBarState> _curvedNavigationBar = GlobalKey();

  final List<Widget> _pages = <Widget>[const FolderListPage(), const MemoryGroupListPage()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 双击返回键才会退出应用。
        int now = DateTime.now().millisecondsSinceEpoch;
        if (_lastBackAppTime != null && now - _lastBackAppTime! < 1500) {
          return true;
        }
        _lastBackAppTime = now;
        EasyLoading.showToast('再按一次退出！');
        await Future.delayed(
          const Duration(milliseconds: 1500),
          () {
            _lastBackAppTime = null;
          },
        );
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          animationCurve: Curves.easeOutCirc,
          key: _curvedNavigationBar,
          color: Colors.blue,
          backgroundColor: Colors.white,
          items: const <Widget>[
            Icon(Icons.group_work, size: 30, color: Colors.white),
            Icon(Icons.group_work_outlined, size: 30, color: Colors.white),
          ],
          height: 50,
          onTap: (int index) {},
          letIndexChange: (int index) {
            if (index == _currentBody) {
              // 若已是当前页面时，不执行任何。
              return false;
            } else {
              log('message');
              _jianJiHomeGetXController.animateToPage(index);
              _currentBody = index;
              return true;
            }
          },
        ),
        body: PageView.builder(
          controller: _jianJiHomeGetXController.pageController,
          itemCount: _pages.length,
          onPageChanged: (int index) {
            _curvedNavigationBar.currentState?.setPage(index);
          },
          itemBuilder: (BuildContext context, int index) {
            return _pages[index];
          },
        ),
      ),
    );
  }
}
