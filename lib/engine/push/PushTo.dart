import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class PushTo {
  static Future<void> loginAndRegister() async {
    final SingleResult<bool> startResult = await DataTransferManager.instance.execute<void, bool>(
      executeForWhichEngine: EngineEntryName.LOGIN_AND_REGISTER,
      operationIdIfEngineFirstFrameInitialized: null,
      operationData: null,
      startViewParams: ViewParams(width: 400, height: 400, left: 150, right: 0, top: 150, bottom: 0, isFocus: false),
      endViewParams: ViewParams(width: 400, height: 400, left: 150, right: 0, top: 150, bottom: 0, isFocus: true),
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
