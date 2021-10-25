import 'dart:io';

import 'package:hybrid/shell.dart';

import 'HttpStoreWriter.dart';
import 'Storer.dart';

void main(List<String> args) {
  Storer();
  Writer(outputFolder: Directory.current.path + r'\lib\data\mysql\httpstore\store');
  Sheller.buildRunner();
}
