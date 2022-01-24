// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:io';

import 'HttpStoreWriteConfig.dart';
import 'HttpStoreWriteWrapper.dart';

class HttpStoreManager {
  static late final WriteConfigWrapper writeConfigWrapper;
  static final List<WriteStoreWrapper> writeStoreWrappers = <WriteStoreWrapper>[];

  static void setStoreConfig(WriteConfigWrapper sc) {
    writeConfigWrapper = sc;
  }

  static void createStores(List<WriteStoreWrapper> sws) {
    writeStoreWrappers.addAll(sws);
  }

  static void run() {
    HttpStoreWriteConfig(outputFolder: Directory.current.path + r'\lib\data\mysql\httpstore\store');
    // Sheller.buildRunner();
  }
}
