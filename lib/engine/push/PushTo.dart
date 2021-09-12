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
      startViewParams: ViewParams(width: 800, height: 800, x: 100, y: 100, alpha: 1),
      endViewParams: ViewParams(width: 800, height: 800, x: 150, y: 300, alpha: 1),
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
