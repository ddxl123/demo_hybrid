// ignore_for_file: non_constant_identifier_names
import 'package:hybrid/engine/constant/o/OFromDataCenter.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';

class MainDataTransfer extends BaseDataTransfer {
  @override
  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data) async {
    if (operationId == OFromDataCenter.send_init_data_to_main) {
      await _send_init_data_to_main();
      // final SingleGetController singleGetController = Get.find<SingleGetController>(tag: DataTransferManager.instance.currentEntryName);
      // singleGetController.updateLogic.updateAny(() {
      //   singleGetController.any['is_ok'] = true;
      // });
      return false;
    }
  }

  /// 对 main 引擎进行初始化。
  Future<void> _send_init_data_to_main() async {}
}
