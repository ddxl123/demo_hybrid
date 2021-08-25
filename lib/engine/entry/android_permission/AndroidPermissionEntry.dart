import 'package:flutter/material.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferBinding.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';

class AndroidPermissionEntry extends StatefulWidget {
  @override
  _AndroidPermissionEntryState createState() => _AndroidPermissionEntryState();
}

class _AndroidPermissionEntryState extends State<AndroidPermissionEntry> {
  @override
  Widget build(BuildContext context) {
    return SbRoundedBox(
      children: <Widget>[
        Permission(
          name: '悬浮窗权限',
          permissionGet: () async {
            DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine(operationId: '', sendToWhichEngine: '', data: null);
          },
        )
      ],
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
        if (current == PermissionResult.notAllowed)
          const Icon(Icons.done, color: Colors.green)
        else if (current == PermissionResult.notAllowed)
          const Icon(Icons.clear, color: Colors.red)
        else
          const CircularProgressIndicator(color: Colors.grey)
      ],
    );
  }
}

enum PermissionResult { allowed, notAllowed, loading }
