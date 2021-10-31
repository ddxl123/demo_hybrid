// ignore_for_file: camel_case_types

import 'package:hybrid/util/SbHelper.dart';

abstract class RequestDataVO extends DoSerializable {}

abstract class RequestParamsVO extends DoSerializable {}

enum PathType {
  jwt,
  no_jwt,
}

extension PathTypeExt on PathType {
  String text() {
    switch (index) {
      case 0:
        return 'jwt';
      case 1:
        return 'no_jwt';
      default:
        throw 'unknown PathType: $this';
    }
  }

  static PathType textToEnum(String text) {
    for (final PathType value in PathType.values) {
      if (value.text() == text) {
        return value;
      }
    }
    throw 'unknown PathType: $text';
  }
}

/// 之所以 [requestHeaders]、[requestDataVO]、[requestParamsVO] 是回调函数，是为了对其输入的不正确数据进行置空处理，
/// 只有被引用时才会抛出异常，而在被引用前已将该对象创建成功（哪怕请求数据是空），这样做的话，能捕获到请求数据的异常。
class HttpRequest<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO> extends DoSerializable {
  HttpRequest({
    required this.method,
    required this.path,
    required Map<String, Object?>? putRequestHeaders(),
    required REQVO? putRequestDataVO(),
    required REQPVO? putRequestParamsVO(),
  }) {
    try {
      requestHeaders = putRequestHeaders();
      requestDataVO = putRequestDataVO();
      requestParamsVO = putRequestParamsVO();
    } catch (e, st) {
      exception = e;
      stackTrace = st;
    }
  }

  factory HttpRequest.fromJson(
      Map<String, Object?> httpRequestJson, REQVO? reqvo(Map<String, Object?>? reqvoJson), REQPVO? reqpvo(Map<String, Object?>? reqpvoJson)) {
    return HttpRequest<REQVO, REQPVO>(
      method: httpRequestJson['method']! as String,
      path: httpRequestJson['path']! as String,
      putRequestHeaders: () => httpRequestJson['requestHeaders'] as Map<String, Object?>?,
      putRequestDataVO: () => reqvo(httpRequestJson['requestDataVO'] as Map<String, Object?>?),
      putRequestParamsVO: () => reqpvo(httpRequestJson['requestParamsVO'] as Map<String, Object?>?),
    )
      ..exception = httpRequestJson['exception'] == null ? null : Exception(httpRequestJson['exception']! as String)
      ..stackTrace = httpRequestJson['stackTrace'] == null ? null : StackTrace.fromString(httpRequestJson['stackTrace']! as String);
  }

  @override
  Map<String, Object?> toJson() => <String, dynamic>{
        'method': method,
        'path': path,
        'requestHeaders': requestHeaders,
        'requestDataVO': requestDataVO?.toJson(),
        'requestParamsVO': requestParamsVO?.toJson(),
        'exception': exception.toString(),
        'stackTrace': stackTrace.toString(),
      };

  /// 请求方法。GET/POST
  final String method;

  /// 请求 url。
  /// no_jwt/bb/cc
  final String path;

  /// 请求头。
  Map<String, Object?>? requestHeaders;

  /// 请求体 body VO 模型。
  REQVO? requestDataVO;

  /// 请求体 params VO 模型。
  REQPVO? requestParamsVO;

  /// 请求数据的异常 (单独捕获)。
  Object? exception;

  /// 请求数据的 StackTrace (单独捕获)。
  StackTrace? stackTrace;

  /// 请求数据是否出现异常。
  bool hasErrors() => exception != null;

  /// path type
  PathType pathType() {
    final String type = path.split('/')[0];
    return PathTypeExt.textToEnum(type);
  }
}
