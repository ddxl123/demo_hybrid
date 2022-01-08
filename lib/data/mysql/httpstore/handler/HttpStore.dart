// ignore_for_file: camel_case_types
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpHandler.dart';
import 'HttpRequest.dart';
import 'HttpResponse.dart';

abstract class HttpStore<REQHVO extends RequestHeadersVO, REQPVO extends RequestParamsVO, REQVO extends RequestDataVO, RESPHVO extends ResponseHeadersVO,
    RESPDVO extends ResponseDataVO, RESPCCOL extends ResponseCodeCollect> implements DoSerializable {
  HttpStore({
    required HttpRequest<REQHVO, REQPVO, REQVO> putHttpRequest(),
    required RESPCCOL putResponseCodeCollect,
  }) {
    httpHandler = HttpHandler(this);
    try {
      httpRequest = putHttpRequest();
      if (httpRequest.method == 'GET' && httpRequest.requestDataVO.isNotEmpty) {
        httpHandler.setError(vm: '请求方法异常！', descp: Description(''), e: Exception('method:GET, requestDataVO: isNotEmpty'), st: null);
      } else if (httpRequest.method == 'POST' && httpRequest.requestParamsVO.isNotEmpty) {
        httpHandler.setError(vm: '请求方法异常！', descp: Description(''), e: Exception('method:POST, requestParamsVO: isNotEmpty'), st: null);
      }
      httpResponse = HttpResponse<RESPHVO, RESPDVO, RESPCCOL>(putResponseCodeCollect: putResponseCodeCollect.toJson());
    } catch (e, st) {
      httpHandler.setError(vm: '', descp: Description(''), e: e, st: st);
    }
  }

  HttpStore.fromJson(Map<String, Object?> json) {
    httpRequest = HttpRequest.fromJson(json['httpRequest']!.quickCast());
    httpResponse = HttpResponse.fromJson(json['httpResponse']!.quickCast());
    httpHandler = HttpHandler.fromJson(json['httpHandler']!.quickCast());
  }

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'httpRequest': httpRequest.toJson(),
        'httpResponse': httpResponse.toJson(),
        'httpHandler': httpHandler.toJson(),
      };

  late final HttpRequest<REQHVO, REQPVO, REQVO> httpRequest;

  late final HttpResponse<RESPHVO, RESPDVO, RESPCCOL> httpResponse;

  late final HttpHandler httpHandler;

  REQHVO toVOForRequestHeadersVO(Map<String, Object?> json);

  REQVO toVOForRequestDataVO(Map<String, Object?> json);

  REQPVO toVOForRequestParamsVO(Map<String, Object?> json);

  RESPHVO toVOForResponseHeadersVO(Map<String, Object?> json);

  RESPDVO toVOForResponseDataVO(Map<String, Object?> json);

  RESPCCOL toVOForResponseCodeCollect(Map<String, Object?> json);
}

class HttpStore_Any extends HttpStore {
  HttpStore_Any.fromJson(Map<String, Object?> json) : super.fromJson(json);

  @override
  RequestDataVO toVOForRequestDataVO(Map<String, Object?> json) {
    // TODO: implement toVOForRequestDataVO
    throw UnimplementedError();
  }

  @override
  RequestHeadersVO toVOForRequestHeadersVO(Map<String, Object?> json) {
    // TODO: implement toVOForRequestHeadersVO
    throw UnimplementedError();
  }

  @override
  RequestParamsVO toVOForRequestParamsVO(Map<String, Object?> json) {
    // TODO: implement toVOForRequestParamsVO
    throw UnimplementedError();
  }

  @override
  ResponseCodeCollect toVOForResponseCodeCollect(Map<String, Object?> json) {
    // TODO: implement toVOForResponseCodeCollect
    throw UnimplementedError();
  }

  @override
  ResponseDataVO toVOForResponseDataVO(Map<String, Object?> json) {
    // TODO: implement toVOForResponseDataVO
    throw UnimplementedError();
  }

  @override
  ResponseHeadersVO toVOForResponseHeadersVO(Map<String, Object?> json) {
    // TODO: implement toVOForResponseHeadersVO
    throw UnimplementedError();
  }
}
