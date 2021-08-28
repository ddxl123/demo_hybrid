import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/ODataCenter.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferBinding.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'AppInitPage.dart';

class DataCenterEntry extends StatefulWidget {
  @override
  _DataCenterEntryState createState() => _DataCenterEntryState();
}

class _DataCenterEntryState extends State<DataCenterEntry> {
  int i = 0;

  @override
  void initState() {
    super.initState();
    print('DataCenterEntry initState');
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      i++;
      print('DataCenterEntry $i');
    });
    () async {
      final MessageResult<bool> result = await DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
        sendToWhichEngine: EngineEntryName.main,
        operationId: ODataCenter_FlutterSend.send_init_data_to_main,
        data: null,
      );
      result.handle(
        (bool data) async {
          if (data) {
            SbLogger(code: null, viewMessage: null, data: null, description: Description('传递数据成功！'), exception: null, stackTrace: null);
          } else {
            throw Exception('data is null');
          }
        },
        (Object? exception, StackTrace? stackTrace) async {
          SbLogger(code: null, viewMessage: null, data: null, description: Description('传递数据异常！'), exception: exception, stackTrace: stackTrace);
        },
      );
    }();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AppInitPage(
          builder: () => const Text('data_center'),
        ),
      ),
    );
  }
}
