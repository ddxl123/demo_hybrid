import 'package:get/get.dart';
import 'package:hybrid/muc/update/UpdateBase.dart';

/// [G] 为 [GetxController] 类型。
///
/// [U] 为 [UpdateBase] 类型。
class GetControllerBase<G extends GetxController, U extends UpdateBase<G>> extends GetxController {
  GetControllerBase(this.updateLogic) {
    updateLogic.getxController = this as G;
  }

  final U updateLogic;
}
