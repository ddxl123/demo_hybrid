// ignore_for_file: non_constant_identifier_names
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

class WriteVOWrapper {
  WriteVOWrapper({
    required this.keyName,
    required this.type,
    required this.isRequired,
  });

  String keyName;
  WriteDataType type;
  bool isRequired;
}

class WriteCodeWrapper {
  WriteCodeWrapper({required this.code, required this.tip});

  final int code;
  final String tip;
}

class WriteStoreWrapper {
  WriteStoreWrapper({
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
  }

  WriteMethodType method;

  WritePathType pathType;

  String path;

  List<WriteVOWrapper> requestHeadersVOKeys;

  List<WriteVOWrapper> requestParamsVOKeys;

  List<WriteVOWrapper> requestDataVOKeys;

  List<WriteVOWrapper> responseHeadersVOKeys;

  List<WriteVOWrapper> responseDataVOKeys;

  List<WriteCodeWrapper> responseCodeCollect;
}

class WriteConfigWrapper {
  WriteConfigWrapper({
    required this.baseUrl,
    required this.connectTimeout,
    required this.receiveTimeout,
  });

  final String baseUrl;

  /// ms
  final int connectTimeout;

  /// ms
  final int receiveTimeout;
}
