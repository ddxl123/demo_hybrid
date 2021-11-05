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
class HttpRequest<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO> {
  HttpRequest({
    required this.method,
    required this.path,
    required Map<String, Object?> putRequestHeaders,
    required Map<String, Object?> putRequestDataVO,
    required Map<String, Object?> putRequestParamsVO,
  }) {
    requestHeaders.addAll(putRequestHeaders);
    requestDataVO.addAll(putRequestDataVO);
    requestParamsVO.addAll(putRequestParamsVO);
  }

  // factory HttpRequest.fromJson(
  //     Map<String, Object?> httpRequestJson, REQVO? reqvo(Map<String, Object?>? reqvoJson), REQPVO? reqpvo(Map<String, Object?>? reqpvoJson)) {
  //   return HttpRequest<REQVO, REQPVO>(
  //     method: httpRequestJson['method']! as String,
  //     path: httpRequestJson['path']! as String,
  //     putRequestHeaders: () => httpRequestJson['requestHeaders'] as Map<String, Object?>?,
  //     putRequestDataVO: () => reqvo(httpRequestJson['requestDataVO'] as Map<String, Object?>?),
  //     putRequestParamsVO: () => reqpvo(httpRequestJson['requestParamsVO'] as Map<String, Object?>?),
  //   );
  // }

  // @override
  // Map<String, Object?> toJson() => <String, dynamic>{
  //       'method': method,
  //       'path': path,
  //       'requestHeaders': requestHeaders,
  //       'requestDataVO': requestDataVO?.toJson(),
  //       'requestParamsVO': requestParamsVO?.toJson(),
  //     };

  /// 请求方法。GET/POST
  String method;

  /// 请求 url。
  /// no_jwt/bb/cc
  String path;

  /// 请求头。
  final Map<String, Object?> requestHeaders = <String, Object?>{};

  /// 请求体 body VO 模型。
  final Map<String, Object?> requestDataVO = <String, Object?>{};

  /// 请求体 params VO 模型。
  final Map<String, Object?> requestParamsVO = <String, Object?>{};

  REQVO toVOForRequestDataVO(REQVO reqvo(Map<String, Object?> json)) {
    return reqvo(requestDataVO);
  }

  REQPVO toVOForRequestParamsVO(REQPVO reqpvo(Map<String, Object?> json)) {
    return reqpvo(requestParamsVO);
  }

  /// path type
  PathType pathType() {
    final String type = path.split('/')[0];
    return PathTypeExt.textToEnum(type);
  }
}
