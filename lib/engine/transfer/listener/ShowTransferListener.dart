import 'dart:developer';

import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/jianji/RememberingRandomNotRepeatFloatingPage.dart';
import 'package:hybrid/util/SbHelper.dart';

import 'TransferListener.dart';

class ShowTransferListener extends TransferListener {
  @override
  Future<SingleResult<Object?>> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    if (operationId == OUniform.SHOW_SETSTATE) {
      toDoSetState?.call();
      log('SHOW_SETSTATE _onSizeChanged');
      returnResult.setSuccess(putData: () => true);
      return returnResult;
    } else if (operationId == OUniform.SHOW_START) {
      reStart?.call();
      returnResult.setSuccess(putData: () => true);
      return returnResult;
    } else {
      throw 'unknown operationId';
    }
  }
}
