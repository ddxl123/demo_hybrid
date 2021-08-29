import 'package:hybrid/muc/getcontroller/SingleGetController.dart';
import 'package:hybrid/muc/update/UpdateBase.dart';

class SingleUpdate extends UpdateBase<SingleGetController> {
  void updateAny(void call()) {
    call();
    getxController.update();
  }
}
