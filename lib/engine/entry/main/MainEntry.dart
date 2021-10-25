import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/muc/getcontroller/MainEntryGetController.dart';
import 'package:hybrid/muc/view/homepage/HomePage.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';

class MainEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SbButtonApp(
      child: GetMaterialApp(
        home: Scaffold(
          body: MainEntryBody(),
        ),
      ),
    );
  }
}

class MainEntryBody extends StatefulWidget {
  @override
  _MainEntryBodyState createState() => _MainEntryBodyState();
}

class _MainEntryBodyState extends State<MainEntryBody> {
  ///

  /// 若 is_ok 为 0 代表正在检查悬浮窗权限，为 1 代表初始化悬浮窗完成、正在 初始化用户数据，为 2 代表全部初始化完成，为 null 或其他代表初始化失败。
  final MainEntryGetController _mainEntryGetController = Get.put(MainEntryGetController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) {
        _mainEntryGetController.setInitStatus(MainEntryInitStatus.permissionChecking);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainEntryGetController>(
      builder: (MainEntryGetController controller) {
        switch (controller.mainEntryInitStatus) {
          case MainEntryInitStatus.ok:
            return HomePage();
          default:
            return Center(
              child: Text(controller.currentInitStatusInfo),
            );
        }
      },
    );
  }
}
