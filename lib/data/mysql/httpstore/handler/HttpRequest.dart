// ignore_for_file: camel_case_types

import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/util/SbHelper.dart';

abstract class RequestHeadersVO extends DoSerializable {
  String authorization = 'null_authorization';

  void setAuthorizationByBearer(String token) {
    authorization = 'bearer $token';
  }
}

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
///
/// 属性完全为 json 类型。
class HttpRequest<REQHVO extends RequestHeadersVO, REQPVO extends RequestParamsVO, REQVO extends RequestDataVO> implements DoSerializable {
  HttpRequest({
    required this.method,
    required this.path,
    required this.requestHeadersVO,
    required this.requestParamsVO,
    required this.requestDataVO,
  });

  factory HttpRequest.fromJson(HttpStore newHttpStore, Map<String, Object?> json) {
    return HttpRequest<REQHVO, REQPVO, REQVO>(
      method: json['method']! as String,
      path: json['path']! as String,
      requestHeadersVO: newHttpStore.toVOForResponseHeadersVO(json['requestHeadersVO']!.quickCast()) as REQHVO,
      requestParamsVO: newHttpStore.toVOForRequestParamsVO(json['requestDataVO']!.quickCast()) as REQPVO,
      requestDataVO: newHttpStore.toVOForRequestDataVO(json['requestParamsVO']!.quickCast()) as REQVO,
    );
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'method': method,
        'path': path,
        'requestHeadersVO': requestHeadersVO.toJson(),
        'requestDataVO': requestDataVO.toJson(),
        'requestParamsVO': requestParamsVO.toJson(),
      };

  /// 请求方法。GET/POST
  String method;

  /// 请求 url。
  /// no_jwt/bb/cc
  String path;

  /// 请求头。
  final REQHVO requestHeadersVO;

  /// 请求体 params VO 模型。
  final REQPVO requestParamsVO;

  /// 请求体 body VO 模型。
  final REQVO requestDataVO;

  /// path type
  PathType pathType() {
    final String type = path.split('/')[0];
    return PathTypeExt.textToEnum(type);
  }
}
