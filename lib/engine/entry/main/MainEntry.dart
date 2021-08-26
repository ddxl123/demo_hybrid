import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OMain.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferBinding.dart';
import 'package:hybrid/util/sbbutton/SbButton.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class MainEntry extends StatefulWidget {
  @override
  _MainEntryState createState() => _MainEntryState();
}

class _MainEntryState extends State<MainEntry> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
      (Duration timeStamp) async {
        final MessageResult<bool> messageResult = await DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
          sendToWhichEngine: EngineEntryName.native,
          operationId: OMain_FlutterSend.start_data_center_engine,
          data: <String, Object?>{'aaaa': 123.1},
        );
        await messageResult.handle(
          (bool data) async {
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('成功启动了 data_center 悬浮窗！'),
              exception: null,
              stackTrace: null,
            );
          },
          (Object? exception, StackTrace? stackTrace) async {
            SbLogger(
              code: null,
              viewMessage: '启动悬浮窗失败！',
              data: null,
              description: Description('发送给原生数据出现异常，启动 data_center 悬浮窗失败！'),
              exception: exception,
              stackTrace: stackTrace,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SbButtonApp(
      child: GetMaterialApp(
        home: TextButton(
          child: Text("ddd"),
          onPressed: () {
            setState(() {});
          },
        ),
      ),
    );
  }
}
