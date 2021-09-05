import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/OAndroidPermission.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/engine/entry/main/FloatingWindowPermissionRoute.dart';
import 'package:hybrid/muc/getcontroller/SingleGetController.dart';
import 'package:hybrid/muc/update/SingleUpdate.dart';
import 'package:hybrid/muc/view/homepage/HomePage.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class MainEntry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SbButtonApp(
      child: GetMaterialApp(
        home: Scaffold(
          body: MainEntryMain(),
        ),
      ),
    );
  }
}

class MainEntryMain extends StatefulWidget {
  @override
  _MainEntryMainState createState() => _MainEntryMainState();
}

class _MainEntryMainState extends State<MainEntryMain> {
  ///

  /// 若 is_ok 为 0 代表正在检查悬浮窗权限，为 1 代表初始化悬浮窗完成、正在初始化用户数据，为 2 代表全部初始化完成，为 null 或其他代表初始化失败。
  final SingleGetController _singleGetController = Get.put(
    SingleGetController(SingleUpdate(), <String, Object?>{
      'is_ok': 0,
      'setNull': (SingleGetController controller) {
        // 触发 初始化失败。
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = null;
        });
      },
      'set0': (SingleGetController controller) {
        // 触发 正在检查悬浮窗权限。
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 0;
          SbHelper.getNavigator!.push(FloatingWindowPermissionRoute());
        });
      },
      'set1': (SingleGetController controller) {
        // 触发 已允许悬浮窗权限，并检查用户初始化数据是否已被下载。
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 1;
        });
        // 异步。
        SqliteCurd.checkUser(
          onSuccess: () async {
            // 触发 初始化成功。
            (controller.any['set2']! as Function(SingleGetController))(controller);
          },
          onError: (Object? exception, StackTrace? stackTrace) async {
            // 触发 初始化失败。
            (controller.any['setNull']! as Function(SingleGetController))(controller);
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('main entry 初始化时 检查用户初始化数据是否已被下载 发生异常！'),
              exception: exception,
              stackTrace: stackTrace,
            ).withRecord();
          },
        );
      },
      'set2': (SingleGetController controller) {
        // 触发 初始化成功。
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 2;
        });
      }
    }),
    tag: SingleGetController.tag.MAIN_ENTRY_INIT_FLOATING_WINDOW,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        _checkFloatingWindowPermission();
      },
    );
  }

  Future<void> _checkFloatingWindowPermission() async {
    final MessageResult<bool> result = await DataTransferManager.instance.executeToNative<void, bool>(
      operationId: OAndroidPermission_FlutterSend.check_floating_window_permission,
      data: null,
    );
    await result.handle(
      // true 已允许，false 未允许。
      onSuccess: (bool data) async {
        if (data) {
          // 触发 已允许悬浮窗权限，并进行用户数据初始化。
          (_singleGetController.any['set1']! as Function(SingleGetController))(_singleGetController);
        } else {
          // 触发 正在检查悬浮窗权限。（弹出悬浮窗权限 route）
          (_singleGetController.any['set0']! as Function(SingleGetController))(_singleGetController);
        }
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        // 触发 初始化失败。
        (_singleGetController.any['setNull']! as Function(SingleGetController))(_singleGetController);
        SbLogger(
          code: null,
          viewMessage: null,
          data: null,
          description: Description('main entry 初始化时 检测悬浮窗权限是否开启 发生异常！'),
          exception: exception,
          stackTrace: stackTrace,
        ).withRecord();
      },
    );
  }

  Future<void> _initUser() async {
    await SqliteCurd.checkUser(
      onSuccess: () async {},
      onError: (Object? exception, StackTrace? stackTrace) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleGetController>(
      builder: (SingleGetController controller) {
        if (controller.any['is_ok'] == 0) {
          print('----0');
          return const Center(
            child: Text('正在检查悬浮窗权限...'),
          );
        }
        if (controller.any['is_ok'] == 1) {
          print('----1');
          return const Center(
            child: Text('正在初始化用户数据...'),
          );
        }
        if (controller.any['is_ok'] == 2) {
          print('----2');
          return HomePage();
        }
        print('----3 ${controller.any['is_ok']}');
        return const Center(child: Text('应用初始化出现了异常！'));
      },
      tag: SingleGetController.tag.MAIN_ENTRY_INIT_FLOATING_WINDOW,
    );
  }
}
