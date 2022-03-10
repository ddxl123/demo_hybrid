import 'dart:async';
import 'dart:developer';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/jianji/FolderListPage.dart';
import 'package:hybrid/jianji/MemoryGroupListPage.dart';
import 'package:hybrid/jianji/RememberingPage.dart';
import 'package:hybrid/jianji/RememberingRandomNotRepeatFloatingPage.dart';
import 'package:hybrid/jianji/controller/JianJiHomeGetXController.dart';
import 'package:hybrid/jianji/controller/RememberingRunPageGetXController.dart';
import 'package:hybrid/util/SbHelper.dart';

import 'controller/GlobalGetXController.dart';
import 'controller/MemoryGroupListGetXController.dart';
import 'controller/RememberingPageGetXController.dart';

class JianJiHome extends StatefulWidget {
  const JianJiHome({Key? key}) : super(key: key);

  @override
  _JianJiHomeState createState() => _JianJiHomeState();
}

class _JianJiHomeState extends State<JianJiHome> {
  final GlobalGetXController _globalGetXController = Get.put(GlobalGetXController());

  final JianJiHomeGetXController _jianJiHomeGetXController = Get.put(JianJiHomeGetXController());
  final MemoryGroupListGetXController _memoryGroupListGetXController = Get.put(MemoryGroupListGetXController());
  final RememberPageGetXController _rememberPageGetXController = Get.put(RememberPageGetXController());
  final RememberingRunPageGetXController _rememberingRunPageGetXController = Get.put(RememberingRunPageGetXController());

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
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            bottomNavigationBar: CurvedNavigationBar(
              animationCurve: Curves.easeOutCirc,
              key: _curvedNavigationBar,
              color: Colors.blue,
              backgroundColor: Colors.transparent,
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
          Obx(
            () {
              if (_globalGetXController.isRemembering.value) {
                return ObxValue<RxList<dynamic>>(
                  (positionValue) {
                    return Positioned(
                      right: positionValue.first,
                      bottom: positionValue.last,
                      child: Listener(
                        child: FloatingActionButton(
                          child: positionValue[1].value ? const Text('可移动') : const Text('任务', style: TextStyle(color: Colors.green)),
                          backgroundColor: Colors.greenAccent,
                          onPressed: () async {
                            Get.to(() => const RememberingPage());
                            log('_globalGetXController.selectModel.value ${_globalGetXController.selectModel.value}');
                            if (_globalGetXController.selectModel.value == RememberStatus.randomNotRepeatFloating.index) {
                              EasyLoading.showToast('正在启动悬浮窗口...');
                              final result = await TransferManager.instance.transferExecutor.executeWithOnlyView(
                                executeForWhichEngine: EngineEntryName.SHOW,
                                startViewParams: null,
                                endViewParams: (ViewParams lastViewParams, SizeInt screenSize) => smallViewParams,
                                closeViewAfterSeconds: null,
                              );
                              await result.handle(
                                doSuccess: (bool successData) async {
                                  if (!successData) {
                                    throw 'successData 为空';
                                  }
                                  await EasyLoading.showToast('已启动');
                                },
                                doError: (SingleResult<bool> errorResult) async {
                                  await EasyLoading.showToast('启动异常}');
                                },
                              );
                            }
                          },
                        ),
                        onPointerMove: (d) {
                          positionValue[1].value = false;
                          positionValue.first -= d.delta.dx;
                          positionValue.last -= d.delta.dy;
                        },
                      ),
                    );
                  },
                  [30.0, true.obs, 200.0].obs,
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
