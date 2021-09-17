import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class PushTo {
  static Future<void> loginAndRegister(Size? changeViewSize) async {
    final SingleResult<bool> startResult = await DataTransferManager.instance.execute<void, bool>(
      executeForWhichEngine: EngineEntryName.LOGIN_AND_REGISTER,
      operationIdIfEngineFirstFrameInitialized: null,
      operationData: null,
      startViewParams: changeViewSize == null ? ViewParams(width: 300, height: 300, left: 150, right: 0, top: 150, bottom: 0, isFocus: true) : null,
      endViewParams: changeViewSize == null
          ? ViewParams(width: 1200, height: 1200, left: 150, right: 0, top: 150, bottom: 0, isFocus: true)
          : ViewParams(width: changeViewSize.width.toInt(), height: changeViewSize.height.toInt(), left: 150, right: 0, top: 150, bottom: 0, isFocus: true),
      closeViewAfterSeconds: null,
      resultDataCast: null,
    );
    if (!startResult.hasError) {
      if (!startResult.result!) {
        SbLogger(
          code: null,
          viewMessage: '登陆页面弹出失败！',
          data: startResult.result,
          description: null,
          exception: startResult.exception,
          stackTrace: startResult.stackTrace,
        );
      }
    } else {
      SbLogger(
        code: null,
        viewMessage: '登陆页面弹出失败！',
        data: startResult.result,
        description: null,
        exception: startResult.exception,
        stackTrace: startResult.stackTrace,
      );
    }
  }
}
