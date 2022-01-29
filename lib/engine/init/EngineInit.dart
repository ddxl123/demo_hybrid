import 'package:flutter/material.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/engine/transfer/listener/TransferListener.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

/// 对引擎进行绑定初始化。
void flutterEngineBinding(String entryName, TransferListener Function() dataTransfer) {
  WidgetsFlutterBinding.ensureInitialized();
  SbLogger.engineEntryBinding(entryName);
  TransferManager.instance.binding(entryName, dataTransfer);
}

class FlutterEngineApp extends StatefulWidget {
  const FlutterEngineApp({required this.child, required this.isSetOnReadyImdtWhenFirstFrameInitialized, Key? key}) : super(key: key);

  final Widget child;

  /// 是否第一帧完成后便立即标记为 OnReady。
  final bool isSetOnReadyImdtWhenFirstFrameInitialized;

  @override
  _FlutterEngineAppState createState() => _FlutterEngineAppState();
}

class _FlutterEngineAppState extends State<FlutterEngineApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        if (widget.isSetOnReadyImdtWhenFirstFrameInitialized) {
          TransferManager.instance.isCurrentFlutterEngineOnReady = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
