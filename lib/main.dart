// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid/engine/constant/OExecute.dart';
import 'package:hybrid/engine/datatransfer/DataCenterDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/engine/entry/login_and_register/LoginAndRegisterEntry.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'engine/datatransfer/MainDataTransfer.dart';
import 'engine/entry/data_center/DataCenterEntry.dart';
import 'engine/entry/main/MainEntry.dart';

bool hadSentInitFirstFrame = false;

Future<void> sendInitFirstFrame() async {
  if (hadSentInitFirstFrame) {
    return;
  }
  hadSentInitFirstFrame = true;

  final SingleResult<bool> result = await DataTransferManager.instance.executeToNative<void, bool>(
    operationId: OExecute_FlutterSend.SET_FIRST_FRAME_INITIALIZED,
    data: null,
    resultDataCast: null,
  );
  await result.handle<void>(
    onSuccess: (bool successResult) async {
      if (!successResult) {
        throw Exception('data 不为 true！');
      }
    },
    onError: (Object? exception, StackTrace? stackTrace) async {
      // TODO: 失败的时候要如何处理？
      SbLogger(
        code: null,
        viewMessage: '窗口初始化异常！',
        data: null,
        description: Description('第一帧初始化异常！'),
        exception: exception,
        stackTrace: stackTrace,
      ).withRecord();
    },
  );
}

void initBeforeRun(String entryName, BaseDataTransfer dataTransfer()) {
  WidgetsFlutterBinding.ensureInitialized();
  SbLogger.engineEntryBinding(entryName);
  DataTransferManager.instance.binding(entryName, dataTransfer);
}

class EntryInitWidget extends StatefulWidget {
  const EntryInitWidget(this.child, this.isSendImdt);

  final Widget child;
  final bool isSendImdt;

  @override
  _EntryInitWidgetState createState() => _EntryInitWidgetState();
}

class _EntryInitWidgetState extends State<EntryInitWidget> {
  @override
  void initState() {
    super.initState();
    if (!widget.isSendImdt) {
      return;
    }
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        sendInitFirstFrame();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// 应用的主入口。
///
/// 当有其他引擎启动时，该入口也可以被销毁。
void main() {
  initBeforeRun('main', () => MainDataTransfer());
  runApp(EntryInitWidget(MainEntry(), true));
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
  initBeforeRun('data_center', () => DataCenterDataTransfer());
  runApp(EntryInitWidget(DataCenterEntry(), false));
}

@pragma('vm:entry-point')
void login_and_register() {
  initBeforeRun('login_and_register', () => DataCenterDataTransfer());
  runApp(EntryInitWidget(LoginAndRegisterEntry(), true));
}
