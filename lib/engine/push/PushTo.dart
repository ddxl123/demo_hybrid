// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class PushTo {
  static Future<void> withEntryName({
    required String entryName,
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
  }) async {
    final SingleResult<bool> startResult = await TransferManager.instance.transferExecutor.executeWithOnlyView(
      executeForWhichEngine: entryName,
      startViewParams: startViewParams,
      endViewParams: endViewParams,
      closeViewAfterSeconds: null,
    );
    await startResult.handle<void>(
      doSuccess: (bool successResult) async {
        if (!successResult) {
          SbLogger(
            c: null,
            vm: '新入口弹出失败！',
            data: successResult,
            descp: null,
            e: Exception('successResult 不为 true！'),
            st: null,
          );
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        SbLogger(
          c: null,
          vm: '新入口弹出异常！',
          data: null,
          descp: errorResult.getRequiredDescp(),
          e: errorResult.getRequiredE(),
          st: errorResult.stackTrace,
        );
      },
    );
  }
}
