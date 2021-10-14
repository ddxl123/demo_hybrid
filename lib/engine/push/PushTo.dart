import 'dart:async';

import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class PushTo {
  static Future<void> withEntryName({
    required String entryName,
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
  }) async {
    final SingleResult<bool> startResult = await DataTransferManager.instance.execute<void, bool>(
      executeForWhichEngine: entryName,
      operationIdWhenEngineOnReady: null,
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
            viewMessage: '新入口弹出失败！',
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
          viewMessage: '新入口弹出异常！',
          data: null,
          description: null,
          exception: exception,
          stackTrace: stackTrace,
        );
      },
    );
  }
}
