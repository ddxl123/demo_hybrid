// ignore_for_file: non_constant_identifier_names
import 'package:get/get.dart';

class SingleGetController extends GetxController {
  SingleGetController(Map<String, Object?> defaultMap) {
    any.clear();
    any.addAll(defaultMap);
  }

  final Map<String, Object?> any = <String, Object?>{};

  static Tag tag = Tag();

  void updateAny(Function callback) {
    callback();
    update();
  }
}

class Tag {
  String MAIN_ENTRY_INIT = 'main_entry_init';
}
