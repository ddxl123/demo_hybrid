// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:hybrid/engine/datatransfer/DataCenterDataTransfer.dart';
import 'package:hybrid/engine/entry/login_and_register/LoginAndRegisterEntry.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBox.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxController.dart';
import 'package:hybrid/util/sbfreebox/SbFreeBoxWidget.dart';

import 'engine/datatransfer/MainDataTransfer.dart';
import 'engine/entry/data_center/DataCenterEntry.dart';
import 'engine/entry/main/MainEntry.dart';
import 'engine/init/EngineInit.dart';

/// 应用的主入口。
///
/// 当有其他引擎启动时，该入口也可以被销毁。
void main() {
  engineInitBeforeRun('main', () => MainDataTransfer());
  runApp(EngineApp(MainEntry(), true));
}

/// android 部分的权限设置入口。
///
/// 比如需要权限列表：悬浮窗权限、应用自启权限等。
// @pragma('vm:entry-point')
// void android_permission() {
//   initBeforeRun('android_permission', () => AndroidPermissionDataTransfer());
//   runApp(EntryInitWidget(AndroidPermissionEntry()));
// }

/// 数据中心。
///
/// 全部的引擎的数据来源及操作全部由该入口控制。
@pragma('vm:entry-point')
void data_center() {
  engineInitBeforeRun('data_center', () => DataCenterDataTransfer());
  runApp(EngineApp(DataCenterEntry(), false));
}

@pragma('vm:entry-point')
void login_and_register() {
  engineInitBeforeRun('login_and_register', () => DataCenterDataTransfer());
  runApp(EngineApp(LoginAndRegisterEntry(), true));
}

@pragma('vm:entry-point')
void dddddddddddddd() {
  engineInitBeforeRun('dddddddddddddd', () => DataCenterDataTransfer());
  runApp(
    EngineApp(
      MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.amberAccent,
          body: SbFreeBox(
            boxBodyBackgroundColor: Colors.deepOrangeAccent,
            sbFreeBoxController: SbFreeBoxController(),
            boxSize: const Size(200, 200),
            fixedLayerWidgets: Stack(
              children: <Widget>[
                Positioned(
                  bottom: 100,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('button'),
                  ),
                ),
              ],
            ),
            freeMoveScaleLayerWidgets: SbFreeBoxStack(
              builder: (BuildContext context, void Function(void Function()) bSetState) {
                return <Widget>[
                  SbFreeBoxPositioned(
                    easyPosition: const Offset(100, 100),
                    child: TextButton(onPressed: () {}, child: const Text('BUTTON')),
                  ),
                ];
              },
            ),
          ),
        ),
      ),
      true,
    ),
  );
}
