// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'engine/entry/data_center/DataCenterEntry.dart';
import 'engine/entry/main/MainEntry.dart';
import 'engine/init/EngineInit.dart';
import 'engine/transfer/listener/DataCenterTransferListener.dart';
import 'engine/transfer/listener/MainDataTransferListener.dart';

/// 应用的主入口。
///
/// 当有其他引擎启动时，该入口也可以被销毁。
void main() {
  engineInitBeforeRun('main', () => MainDataTransferListener());
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
  engineInitBeforeRun('data_center', () => DataCenterTransferListener());
  runApp(EngineApp(DataCenterEntry(), false));
}

// @pragma('vm:entry-point')
// void login_and_register() {
//   engineInitBeforeRun('login_and_register', () => ());
//   runApp(EngineApp(LoginAndRegisterEntry(), true));
// }
