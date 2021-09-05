// ignore_for_file: non_constant_identifier_names
import 'package:hybrid/muc/getcontroller/GetControllerBase.dart';
import 'package:hybrid/muc/update/SingleUpdate.dart';

class SingleGetController extends GetControllerBase<SingleGetController, SingleUpdate> {
  SingleGetController(SingleUpdate updateLogic, Map<String, Object?> defaultMap) : super(updateLogic) {
    any.clear();
    any.addAll(defaultMap);
  }

  final Map<String, Object?> any = <String, Object?>{};

  static Tag tag = Tag();
}

class Tag {
  String MAIN_ENTRY_INIT_FLOATING_WINDOW = 'main_entry_init_floating_window';
}
