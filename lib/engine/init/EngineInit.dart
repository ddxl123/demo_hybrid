import 'package:flutter/material.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

void engineInitBeforeRun(String entryName, BaseDataTransfer dataTransfer()) {
  WidgetsFlutterBinding.ensureInitialized();
  SbLogger.engineEntryBinding(entryName);
  DataTransferManager.instance.binding(entryName, dataTransfer);
}

class EngineApp extends StatefulWidget {
  const EngineApp(this.child, this.isSetOnReadyImdtWhenFirstFrameInitialized);

  final Widget child;

  /// 是否立即标记 OnReady。
  final bool isSetOnReadyImdtWhenFirstFrameInitialized;

  @override
  _EngineAppState createState() => _EngineAppState();
}

class _EngineAppState extends State<EngineApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        if (widget.isSetOnReadyImdtWhenFirstFrameInitialized) {
          DataTransferManager.instance.isCurrentFlutterEngineOnReady = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
