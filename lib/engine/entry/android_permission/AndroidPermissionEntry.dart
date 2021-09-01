import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OAndroidPermission.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';

class AndroidPermissionEntry extends StatefulWidget {
  @override
  _AndroidPermissionEntryState createState() => _AndroidPermissionEntryState();
}

class _AndroidPermissionEntryState extends State<AndroidPermissionEntry> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.transparent,
        body: AndroidPermissionEntryMain(),
      ),
    );
  }
}

class AndroidPermissionEntryMain extends StatefulWidget {
  @override
  _AndroidPermissionEntryMainState createState() => _AndroidPermissionEntryMainState();
}

class _AndroidPermissionEntryMainState extends State<AndroidPermissionEntryMain> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SbRoundedBox(
      width: MediaQueryData.fromWindow(window).size.width / 2,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      children: <Widget>[
        _floatingWindows(),
        Permission(
            name: '应用自启权限',
            permissionGet: () async {
              return PermissionResult.error;
            })
      ],
    );
  }

  Widget _floatingWindows() {
    return Permission(
      name: '悬浮窗权限',
      permissionGet: () async {
        final MessageResult<bool> messageResult = await DataTransferManager.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
          operationId: OAndroidPermission_FlutterSend.check_floating_window,
          sendToWhichEngine: EngineEntryName.native,
          data: null,
        );

        PermissionResult permissionResult = PermissionResult.error;
        await messageResult.handle(
          (bool data) async {
            permissionResult = data == true ? PermissionResult.allowed : PermissionResult.notAllowed;
          },
          (Object? exception, StackTrace? stackTrace) async {
            permissionResult = PermissionResult.error;
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('检查是否已获取悬浮窗权限发生异常！'),
              exception: exception,
              stackTrace: stackTrace,
            ).withRecord();
          },
        );
        return permissionResult;
      },
    );
  }
}

class Permission extends StatefulWidget {
  const Permission({required this.name, required this.permissionGet});

  /// 显示的权限名。
  final String name;

  /// 获取权限执行的异步操作。
  final Future<PermissionResult> Function() permissionGet;

  @override
  _PermissionState createState() => _PermissionState();
}

class _PermissionState extends State<Permission> {
  PermissionResult current = PermissionResult.loading;

  @override
  void initState() {
    super.initState();
    doPermissionReGet();
  }

  Future<void> doPermissionReGet() async {
    current = PermissionResult.loading;
    if (mounted) {
      setState(() {});
    }

    final PermissionResult permissionResult = await widget.permissionGet();
    current = permissionResult;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(widget.name),
        Expanded(child: Container()),
        if (current == PermissionResult.notAllowed)
          const Icon(Icons.done, color: Colors.green)
        else if (current == PermissionResult.notAllowed)
          const Icon(Icons.clear, color: Colors.red)
        else if (current == PermissionResult.loading)
          const CircularProgressIndicator(color: Colors.grey)
        else
          () {
            Timer(
              const Duration(seconds: 2),
              () {
                doPermissionReGet();
              },
            );
            return const Icon(Icons.error);
          }()
      ],
    );
  }
}

enum PermissionResult { allowed, notAllowed, loading, error }
