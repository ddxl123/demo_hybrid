import 'dart:async';
import 'dart:ui';

import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class PushTo {
  static Future<void> loginAndRegister({
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
  }) async {
    final SingleResult<bool> startResult = await DataTransferManager.instance.execute<void, bool>(
      executeForWhichEngine: EngineEntryName.LOGIN_AND_REGISTER,
      operationIdIfEngineFirstFrameInitialized: null,
      setOperationData: () {},
      startViewParams: startViewParams,
      endViewParams: endViewParams,
      closeViewAfterSeconds: null,
      resultDataCast: null,
    );
    await startResult.handle<void>(
      onSuccess: (bool successResult) async {
        if (!successResult) {
          SbLogger(
            code: null,
            viewMessage: '登陆页面弹出失败！',
            data: successResult,
            description: null,
            exception: Exception('successResult 不为 true！'),
            stackTrace: null,
          );
        }
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        SbLogger(
          code: null,
          viewMessage: '登陆页面弹出失败！',
          data: null,
          description: null,
          exception: exception,
          stackTrace: stackTrace,
        );
      },
    );
  }
}
