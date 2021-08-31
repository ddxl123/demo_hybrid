import 'dart:io';

import 'builder/Writer.dart';

void main(List<String> args) {
  Writer(outModelFolderPath: Directory.current.path + '/lib/data/sqlite/mmodel');
}
