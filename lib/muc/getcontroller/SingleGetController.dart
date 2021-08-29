import 'package:hybrid/muc/getcontroller/GetControllerBase.dart';
import 'package:hybrid/muc/update/SingleUpdate.dart';

class SingleGetController extends GetControllerBase<SingleGetController, SingleUpdate> {
  SingleGetController(SingleUpdate updateLogic, Map<String, Object?> defaultMap) : super(updateLogic) {
    any.clear();
    any.addAll(defaultMap);
  }

  final Map<String, Object?> any = <String, Object?>{};
}
