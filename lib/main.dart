// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hybrid/jianji/JianJiHome.dart';

import 'engine/init/EngineInit.dart';
import 'engine/transfer/listener/MainDataTransferListener.dart';

/// TODO: 增加防止时间回退特性（监听）。

/// 应用的主入口。
///
/// 当有其他引擎启动时，该入口也可以被销毁。
void main() async {
  flutterEngineBinding('main', () => MainDataTransferListener());
  runApp(
    FlutterEngineApp(
      child: MaterialApp(
        home: JianJiHome(),
      ),
      isSetOnReadyImdtWhenFirstFrameInitialized: true,
    ),
  );
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
// @pragma('vm:entry-point')
// void data_center() async {
//   flutterEngineBinding('data_center', () => DataCenterTransferListener());
//   // runApp(FlutterEngineApp(DataCenterEntry(), false));
// }

// @pragma('vm:entry-point')
// void login_and_register() {
//   engineInitBeforeRun('login_and_register', () => ());
//   runApp(EngineApp(LoginAndRegisterEntry(), true));
// }
