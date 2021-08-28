import 'package:get/get.dart';
import 'package:hybrid/engine/constant/ODataCenter.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/muc/getcontroller/homepage/HomePageGetController.dart';

class MainDataTransfer extends BaseDataTransfer {
  @override
  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data) async {
    if (operationId == ODataCenter_FlutterSend.send_init_data_to_main) {
      final HomePageGetController homePageGetController = Get.find<HomePageGetController>();
      print('---------------- ${homePageGetController.sbFreeBoxController.freeBoxCamera}');
      return true;
    } else {
      throw throwUnhandledOperationIdException(operationId);
    }
  }
}
