// ignore_for_file: camel_case_types

import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/util/SbHelper.dart';

abstract class RequestHeadersVO extends DoSerializable {}

abstract class RequestParamsVO extends DoSerializable {}

abstract class RequestDataVO extends DoSerializable {}

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

/// 之所以 [requestHeadersVO]、[requestDataVO]、[requestParamsVO] 是回调函数，是为了对其输入的不正确数据进行置空处理，
/// 只有被引用时才会抛出异常，而在被引用前已将该对象创建成功（哪怕请求数据是空），这样做的话，能捕获到请求数据的异常。
class HttpRequest<REQHVO extends RequestHeadersVO, REQPVO extends RequestParamsVO, REQVO extends RequestDataVO> implements DoSerializable {
  HttpRequest({
    required this.method,
    required this.path,
    required Map<String, Object?> putRequestHeadersVO,
    required Map<String, Object?> putRequestParamsVO,
    required Map<String, Object?> putRequestDataVO,
  }) {
    requestHeadersVO.addAll(putRequestHeadersVO);
    requestDataVO.addAll(putRequestDataVO);
    requestParamsVO.addAll(putRequestParamsVO);
  }

  factory HttpRequest.fromJson(Map<String, Object?> json) {
    return HttpRequest<REQHVO, REQPVO, REQVO>(
      method: json['method']! as String,
      path: json['path']! as String,
      putRequestHeadersVO: json['requestHeadersVO'].quickCastNullable() ?? <String, Object?>{},
      putRequestDataVO: json['requestDataVO'].quickCastNullable() ?? <String, Object?>{},
      putRequestParamsVO: json['requestParamsVO'].quickCastNullable() ?? <String, Object?>{},
    );
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'method': method,
        'path': path,
        'requestHeadersVO': requestHeadersVO,
        'requestDataVO': requestDataVO,
        'requestParamsVO': requestParamsVO,
      };

  /// 请求方法。GET/POST
  String method;

  /// 请求 url。
  /// no_jwt/bb/cc
  String path;

  /// 请求头。
  final Map<String, Object?> requestHeadersVO = <String, Object?>{};

  /// 请求体 params VO 模型。
  final Map<String, Object?> requestParamsVO = <String, Object?>{};

  /// 请求体 body VO 模型。
  final Map<String, Object?> requestDataVO = <String, Object?>{};

  REQHVO getRequestHeadersVO(HttpStore hs) => hs.toVOForRequestHeadersVO(requestHeadersVO) as REQHVO;

  REQPVO getRequestParamsVO(HttpStore hs) => hs.toVOForRequestParamsVO(requestParamsVO) as REQPVO;

  REQVO getRequestDataVO(HttpStore hs) => hs.toVOForRequestDataVO(requestDataVO) as REQVO;

  /// path type
  PathType pathType() {
    final String type = path.split('/')[0];
    return PathTypeExt.textToEnum(type);
  }
}
