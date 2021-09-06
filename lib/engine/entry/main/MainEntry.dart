import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
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

        final MessageResult<bool> result = await DataTransferManager.instance.executeToNative<void, bool>(
          operationId: OAndroidPermission_FlutterSend.check_floating_window_permission,
          data: null,
        );
        await result.handle(
          // true 已允许，false 未允许。
          onSuccess: (bool data) async {
            if (data) {
              // 触发 已允许悬浮窗权限，并进行应用数据初始化。
              (controller.any['set2']! as Function(SingleGetController))(controller);
            } else {
              SbHelper.getNavigator!.push(FloatingWindowPermissionRoute());
            }
          },
          onError: (Object? exception, StackTrace? stackTrace) async {
            // 触发 初始化失败。
            (controller.any['setError']! as Function(SingleGetController, String))(controller, '检查悬浮窗权限时发生了异常！');
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
      },
      // 触发 正在初始化应用数据。（启动数据中心引擎）
      'set2': (SingleGetController controller) async {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 2;
        });
        final MessageResult<bool> startDataCenterResult = await DataTransferManager.instance.execute<void, bool>(
          executeForWhichEngine: EngineEntryName.DATA_CENTER,
          operationIdIfEngineFirstFrameInitialized: null,
          operationData: null,
          startViewParams: null,
          endViewParams: null,
          closeViewAfterSeconds: null,
        );

        await startDataCenterResult.handle(
          onSuccess: (bool data) async {
            if (data) {
              (controller.any['set3']! as Function(SingleGetController))(controller);
            }
          },
          onError: (Object? exception, StackTrace? stackTrace) async {
            // 触发 初始化失败。
            (controller.any['setError']! as Function(SingleGetController, String))(controller, '初始化应用数据发生了异常！');
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('main entry 初始化时 初始化应用数据 发生异常！'),
              exception: exception,
              stackTrace: stackTrace,
            ).withRecord();
          },
        );
      },
      // 触发 正在初始化用户数据。（是否存在用户、初始化数据是否已下载）
      'set3': (SingleGetController controller) async {
        controller.updateLogic.updateAny((SingleGetController singleGetController) {
          controller.any['is_ok'] = 3;
        });
        final Future<bool> Function(bool isCheckOnly) checkUser = (bool isCheckOnly) async {
          bool isPass = false;
          await SqliteCurd.checkUser(
            onSuccess: () async {
              (controller.any['set0']! as Function(SingleGetController))(controller);
              isPass = true;
            },
            onNotPass: () async {
              // 保持 is_ok 状态。
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
        Timer.periodic(
          const Duration(seconds: 1),
          (Timer timer) async {
            final bool timerResult = await checkUser(true);
            if (timerResult && timer.isActive) {
              (controller.any['set0']! as Function(SingleGetController))(controller);
              timer.cancel();
            }
          },
        );
      }
    }),
    tag: SingleGetController.tag.MAIN_ENTRY_INIT_FLOATING_WINDOW,
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
      tag: SingleGetController.tag.MAIN_ENTRY_INIT_FLOATING_WINDOW,
    );
  }
}
