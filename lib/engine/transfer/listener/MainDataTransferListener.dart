// ignore_for_file: non_constant_identifier_names
import 'package:hybrid/engine/constant/o/OFromDataCenter.dart';
import 'package:hybrid/util/SbHelper.dart';

import 'TransferListener.dart';

class MainDataTransferListener extends TransferListener {
  @override
  Future<SingleResult<Object?>> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    if (operationId == OFromDataCenter.send_init_data_to_main) {
      await _send_init_data_to_main();
      // final SingleGetController singleGetController = Get.find<SingleGetController>(tag: DataTransferManager.instance.currentEntryName);
      // singleGetController.updateLogic.updateAny(() {
      //   singleGetController.any['is_ok'] = true;
      // });
      return returnResult.setSuccess(putData: () => false);
    } else {
      return returnResult;
    }
  }

  /// 对 main 引擎进行初始化。
  Future<void> _send_init_data_to_main() async {}
}
