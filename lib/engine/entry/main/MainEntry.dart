import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OMain.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferBinding.dart';
import 'package:hybrid/engine/entry/main/FloatingWindowPermissionRoute.dart';
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

  /// 该入口引擎是否初始化完成并可以进行之后的操作。
  ///
  /// 若为 null，则代表初始化失败。
  bool? isOk = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        final MessageResult<bool> messageResult = await DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
          sendToWhichEngine: EngineEntryName.native,
          operationId: OMain_FlutterSend.check_floating_window_permission,
          data: null,
        );

        Future<void> push() async {
          await SbHelper.getNavigator!.push(FloatingWindowPermissionRoute());
          init();
        }

        messageResult.handle(
          (bool data) async {
            if (data) {
              init();
            } else {
              push();
            }
          },
          (Object? exception, StackTrace? stackTrace) async {
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('检查悬浮窗权限发生异常！'),
              exception: exception,
              stackTrace: stackTrace,
            ).withRecord();
            push();
          },
        );
      },
    );
  }

  /// 悬浮窗权限已被允许后的操作。
  ///
  /// 初始化各种悬浮窗引擎。
  Future<void> init() async {
    SbLogger(
      code: null,
      viewMessage: null,
      data: null,
      description: Description('悬浮窗权限已获取！'),
      exception: null,
      stackTrace: null,
    );
    final MessageResult<bool> result = await DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
      sendToWhichEngine: EngineEntryName.native,
      operationId: OMain_FlutterSend.start_data_center_engine_and_keep_background_running_by_floating_window,
      data: null,
    );
    result.handle(
      (bool data) async {
        if (data) {
          SbLogger(
            code: null,
            viewMessage: null,
            data: null,
            description: Description('启动【data_center】引擎并利用悬浮窗来维持程序后台运行成功！'),
            exception: null,
            stackTrace: null,
          );
          isOk = true;
          setState(() {});
        } else {
          throw Exception('返回的数据为 false');
        }
      },
      (Object? exception, StackTrace? stackTrace) async {
        SbLogger(
          code: null,
          viewMessage: null,
          data: null,
          description: Description('发生异常，启动【data_center】引擎并利用悬浮窗来维持程序后台运行失败！'),
          exception: exception,
          stackTrace: stackTrace,
        );
        isOk = null;
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isOk == null) {
      return const Center(child: Text('初始化时出现了异常！'));
    }
    if (!isOk!) {
      return const Center(
        child: Text('正在初始化中...'),
      );
    }
    return HomePage();
  }
}
