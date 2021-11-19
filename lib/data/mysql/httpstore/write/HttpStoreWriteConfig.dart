// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:hybrid/data/mysql/httpstore/write/HttpStoreContent.dart';
import 'package:hybrid/data/mysql/httpstore/write/HttpStoreManager.dart';

import 'HttpStoreWriteWrapper.dart';

class HttpStoreWriteConfig {
  HttpStoreWriteConfig({required this.outputFolder}) {
    setOutputPath();
    runWriteHttpStoreConfig();
    runWriteList();
  }

  /// 要输出的文件夹的 [绝对路径]。
  String outputFolder;

  void setOutputPath() {
    // ignore: avoid_slow_async_io
    if (Directory(outputFolder).existsSync()) {
      throw '文件夹已存在！';
    } else {
      Directory(outputFolder).createSync();
    }
  }

  void runWriteHttpStoreConfig() {
    File(outputFolder + r'\' + 'HttpStoreConfig.dart').writeAsStringSync(HttpStoreContent.configContent(HttpStoreManager.writeConfigWrapper));
    print('HttpStoreConfig file is created successfully!');
  }

  void runWriteList() {
    for (final WriteStoreWrapper storeWriter in HttpStoreManager.writeStoreWrappers) {
      final String writeContent = HttpStoreContent.contentAll(storeWriter);
      File(outputFolder + r'\' + HttpStoreContent.parsePathToClassName(storeWriter) + '.dart').writeAsStringSync(writeContent);
      print('${HttpStoreContent.parsePathToClassName(storeWriter)} file is created successfully!');
    }
  }
}
