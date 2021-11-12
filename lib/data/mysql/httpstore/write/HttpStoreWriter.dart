// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:hybrid/data/mysql/httpstore/write/HttpStoreContext.dart';
import 'package:meta/meta.dart';

@immutable
class WriteMethodType {
  const WriteMethodType(this.name);

  final String name;
  static WriteMethodType GET = const WriteMethodType('GET');
  static WriteMethodType POST = const WriteMethodType('POST');

  @override
  bool operator ==(Object other) {
    return other is WriteMethodType && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

@immutable
class WritePathType {
  const WritePathType(this.name);

  final String name;
  static WritePathType jwt = const WritePathType('jwt');
  static WritePathType no_jwt = const WritePathType('no_jwt');

  @override
  bool operator ==(Object other) {
    return other is WritePathType && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

@immutable
class WriteDataType {
  const WriteDataType(this.name);

  final String name;
  static WriteDataType STRING = const WriteDataType('String');
  static WriteDataType INT = const WriteDataType('int');

  @override
  bool operator ==(Object other) {
    return other is WriteDataType && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}

class VOWrapper {
  VOWrapper({
    required this.keyName,
    required this.type,
    required this.isRequired,
  });

  String keyName;
  WriteDataType type;
  bool isRequired;
}

class CodeWrapper {
  CodeWrapper({required this.code, required this.tip});

  final int code;
  final String tip;
}

class StoreWrapper {
  StoreWrapper({
    required this.method,
    required this.path,
    required this.pathType,
    required this.requestHeadersVOKeys,
    required this.requestParamsVOKeys,
    required this.requestDataVOKeys,
    required this.responseHeadersVOKeys,
    required this.responseDataVOKeys,
    required this.responseCodeCollect,
  }) {
    if (pathType == WritePathType.jwt || pathType == WritePathType.no_jwt) {
      path = pathType.name + path;
    } else {
      throw 'pathType error: $pathType';
    }
    Writer.storeWriters.add(this);
  }

  WriteMethodType method;

  WritePathType pathType;

  String path;

  List<VOWrapper> requestHeadersVOKeys;

  List<VOWrapper> requestParamsVOKeys;

  List<VOWrapper> requestDataVOKeys;

  List<VOWrapper> responseHeadersVOKeys;

  List<VOWrapper> responseDataVOKeys;

  List<CodeWrapper> responseCodeCollect;
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
