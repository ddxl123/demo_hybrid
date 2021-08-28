// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hybrid/engine/datatransfer/AndroidPermissionDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/DataCenterDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferBinding.dart';
import 'package:hybrid/engine/entry/android_permission/AndroidPermissionEntry.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'engine/datatransfer/MainDataTransfer.dart';
import 'engine/entry/data_center/DataCenterEntry.dart';
import 'engine/entry/main/MainEntry.dart';

void initBeforeRun(String entryName, BaseDataTransfer dataTransfer()) {
  WidgetsFlutterBinding.ensureInitialized();
  SbLogger.engineEntryBinding(entryName);
  DataTransferBinding.instance.binding(entryName, dataTransfer);
}

/// 应用的主入口。
///
/// 当有其他引擎启动时，该入口也可以被销毁。
void main() {
  initBeforeRun('main', () => MainDataTransfer());
  runApp(MainEntry());
}

/// android 部分的权限设置入口。
///
/// 比如需要权限列表：悬浮窗权限、应用自启权限等。
@pragma('vm:entry-point')
void android_permission() {
  initBeforeRun('android_permission', () => AndroidPermissionDataTransfer());
  runApp(AndroidPermissionEntry());
}

/// 数据中心。
///
/// 全部的引擎的数据来源及操作全部由该入口控制。
@pragma('vm:entry-point')
void data_center() {
  initBeforeRun('data_center', () => DataCenterDataTransfer());
  runApp(DataCenterEntry());
}
