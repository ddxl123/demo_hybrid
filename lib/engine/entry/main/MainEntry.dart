import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OAndroidPermission.dart';
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
      'is_ok': '未执行初始化！',
      // 触发 初始化失败。
      'setError': (SingleGetController controller, String errorMessage) {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = errorMessage;
        });
      },
      // 触发 全部初始化成功。
      'set0': (SingleGetController controller) {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 0;
        });
      },
      // 触发 正在检查悬浮窗权限。如果未允许悬浮窗权限，则弹出悬浮窗权限 route。
      'set1': (SingleGetController controller) async {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 1;
        });

        final SingleResult<bool> checkResult = await DataTransferManager.instance.executeToNative<void, bool>(
          operationId: OAndroidPermission_FlutterSend.check_floating_window_permission,
          data: null,
          resultDataCast: null,
        );
        if (!checkResult.hasError) {
          if (checkResult.result!) {
            // 触发 已允许悬浮窗权限，并进行应用数据初始化。
            (controller.any['set2']! as Function(SingleGetController))(controller);
          } else {
            SbHelper.getNavigator!.push(FloatingWindowPermissionRoute());
          }
        } else {
          // 触发 初始化失败。
          (controller.any['setError']! as Function(SingleGetController, String))(controller, '检查悬浮窗权限时发生了异常！');
          SbLogger(
            code: null,
            viewMessage: null,
            data: null,
            description: Description('main entry 初始化时 检测悬浮窗权限是否开启 发生异常！'),
            exception: checkResult.exception,
            stackTrace: checkResult.stackTrace,
          ).withRecord();
        }
      },
      // 触发 正在初始化应用数据。（启动数据中心引擎）
      'set2': (SingleGetController controller) async {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 2;
        });
        final SingleResult<bool> startDataCenterResult = await DataTransferManager.instance.execute<void, bool>(
          executeForWhichEngine: EngineEntryName.DATA_CENTER,
          operationIdIfEngineFirstFrameInitialized: null,
          operationData: null,
          startViewParams: ViewParams(width: 200, height: 200, left: 150, right: 0, top: 150, bottom: 0, isFocus: false),
          endViewParams: ViewParams(width: 200, height: 200, left: 150, right: 0, top: 150, bottom: 0, isFocus: false),
          closeViewAfterSeconds: null,
          resultDataCast: null,
        );

        if (!startDataCenterResult.hasError) {
          if (startDataCenterResult.result!) {
            // 启动成功。
            (controller.any['set3']! as Function(SingleGetController))(controller);
          } else {
            // 触发 初始化失败。
            (controller.any['setError']! as Function(SingleGetController, String))(controller, '启动 data_center 引擎时发生了异常！');
            SbLogger(
              code: null,
              viewMessage: null,
              data: startDataCenterResult.result,
              description: Description('main entry 初始化时 启动 data_center 引擎 发生异常！result 不为 true。'),
              exception: startDataCenterResult.exception,
              stackTrace: startDataCenterResult.stackTrace,
            ).withRecord();
          }
        } else {
          // 触发 初始化失败。
          (controller.any['setError']! as Function(SingleGetController, String))(controller, '初始化应用数据发生了异常！');
          SbLogger(
            code: null,
            viewMessage: null,
            data: null,
            description: Description('main entry 初始化时 初始化应用数据 发生异常！'),
            exception: startDataCenterResult.exception,
            stackTrace: startDataCenterResult.stackTrace,
          ).withRecord();
        }
      },
      // 触发 正在初始化用户数据。（是否存在用户、初始化数据是否已下载）
      'set3': (SingleGetController controller) async {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 3;
        });
        final Future<bool> Function(bool isCheckOnly) checkUser = (bool isCheckOnly) async {
          bool isPass = false;
          await DataTransferManager.instance.executeSomething.checkUser(
            onSuccess: () async {
              isPass = true;
            },
            onNotPass: () async {
              // is_ok 状态保持。
              isPass = false;
            },
            onError: (Object? exception, StackTrace? stackTrace) async {
              // 触发 初始化失败。
              (controller.any['setError']! as Function(SingleGetController, String))(controller, '初始化用户数据发生了异常！');
              isPass = false;
              SbLogger(
                code: null,
                viewMessage: null,
                data: null,
                description: Description('main entry 初始化时 初始化用户数据 发生异常！'),
                exception: exception,
                stackTrace: stackTrace,
              ).withRecord();
            },
            isCheckOnly: isCheckOnly,
          );
          return isPass;
        };
        await checkUser(false);
        // Timer.periodic(
        //   const Duration(seconds: 1),
        //   (Timer timer) async {
        //     final bool timerResult = await checkUser(true);
        //     if (timerResult && timer.isActive) {
        //       // 成功。
        //       (controller.any['set0']! as Function(SingleGetController))(controller);
        //       timer.cancel();
        //     }
        //   },
        // );
      }
    }),
    tag: SingleGetController.tag.MAIN_ENTRY_INIT,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        (_singleGetController.any['set1']! as Function(SingleGetController))(_singleGetController);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleGetController>(
      builder: (SingleGetController controller) {
        if (controller.any['is_ok'] == 0) {
          return HomePage();
        }
        if (controller.any['is_ok'] == 1) {
          return const Center(
            child: Text('正在检查悬浮窗权限...'),
          );
        }
        if (controller.any['is_ok'] == 2) {
          return const Center(
            child: Text('正在初始化应用数据...'),
          );
        }
        if (controller.any['is_ok'] == 3) {
          return const Center(
            child: Text('正在初始化用户数据...'),
          );
        }
        return Center(child: Text(controller.any['is_ok'].toString()));
      },
      tag: SingleGetController.tag.MAIN_ENTRY_INIT,
    );
  }
}
