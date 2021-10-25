// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:hybrid/data/mysql/httpstore/write/HttpStoreContext.dart';

enum PathType {
  jwt,
  no_jwt,
}

class CodeWrapper {
  CodeWrapper({required this.code, required this.tip});

  final int code;
  final String tip;
}

class DataVOType {
  DataVOType(this.name);

  final String name;
  static DataVOType STRING = DataVOType('String');
  static DataVOType INT = DataVOType('int');
}

class DataVOWrapper {
  DataVOWrapper({
    required this.keyName,
    required this.type,
    required this.isRequired,
  });

  String keyName;
  DataVOType type;
  bool isRequired;
}

abstract class StoreWrapper {
  StoreWrapper(
    this.method,
    this.path,
    this.pathType,
    this.requestDataVOKeys,
    this.responseCodeCollect,
    this.responseDataVOKeys,
    this.requestParamsVOKeys,
  ) {
    if (pathType == PathType.jwt) {
      path = 'jwt' + path;
    } else if (pathType == PathType.no_jwt) {
      path = 'no_jwt' + path;
    } else {
      throw 'pathType error: $pathType';
    }
    Writer.storeWriters.add(this);
  }

  String method;

  PathType pathType;

  String path;

  List<DataVOWrapper>? requestDataVOKeys;

  List<DataVOWrapper>? requestParamsVOKeys;

  List<CodeWrapper> responseCodeCollect;

  List<DataVOWrapper> responseDataVOKeys;
}

class StoreWrapperPost extends StoreWrapper {
  StoreWrapperPost({
    required PathType pathType,
    required String path,
    required List<DataVOWrapper> requestDataVOKeys,
    required List<CodeWrapper> responseCodeCollect,
    required List<DataVOWrapper> responseDataVOKeys,
  }) : super(
          'POST',
          path,
          pathType,
          requestDataVOKeys,
          responseCodeCollect,
          responseDataVOKeys,
          null,
        );
}

class StoreWrapperGet extends StoreWrapper {
  StoreWrapperGet({
    required PathType pathType,
    required String path,
    required List<DataVOWrapper> requestParamsVOKeys,
    required List<CodeWrapper> responseCodeCollect,
    required List<DataVOWrapper> responseDataVOKeys,
  }) : super(
          'GET',
          path,
          pathType,
          null,
          responseCodeCollect,
          responseDataVOKeys,
          requestParamsVOKeys,
        );
}

class Writer {
  Writer({required this.outputFolder}) {
    execute();
  }

  static final List<StoreWrapper> storeWriters = <StoreWrapper>[];

  /// 要输出的文件夹的 [绝对路径]。
  String outputFolder;

  void execute() {
    setOutputPath();
    runWriteList();
  }

  void setOutputPath() {
    // ignore: avoid_slow_async_io
    if (Directory(outputFolder).existsSync()) {
      throw '文件夹已存在！';
    } else {
      Directory(outputFolder).createSync();
    }
  }

  void runWriteList() {
    for (final StoreWrapper storeWriter in storeWriters) {
      final String writeContent = HttpStoreContent.contentAll(storeWriter);
      File(outputFolder + r'\' + HttpStoreContent.parsePathToClassName(storeWriter) + '.dart').writeAsStringSync(writeContent);
      print('${HttpStoreContent.parsePathToClassName(storeWriter)} file is created successfully!');
    }
  }
}
