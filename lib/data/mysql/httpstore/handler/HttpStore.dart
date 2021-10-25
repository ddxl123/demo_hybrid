// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';

import 'HttpRequest.dart';
import 'HttpRequestIntercept.dart';
import 'HttpResponse.dart';

part 'HttpStore.g.dart';

abstract class HttpStore<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO>
    implements DoSerializable {
  late final HttpRequest<REQVO, REQPVO> httpRequest;
  late final HttpResponse<RESPCCOL, RESPDVO> httpResponse;

  /// 返回 false 表示拦截发生异常。
  ///
  /// 无论是被 [setCancel] 还是被 [setPass]，都需要配置 [_requestIntercept] 的结果。
  Future<bool> _requestIntercept() async {
    try {
      await HttpRequestIntercept<REQVO, REQPVO>(httpRequest).intercept();
      return true;
    } catch (e, st) {
      httpResponse.setCancel('发生异常！', Description('可能是请求拦截部分发生异常！'), e, st);
      return false;
    }
  }

  /// 直接取消。
  Future<HttpStore<REQVO, REQPVO, RESPCCOL, RESPDVO>> setCancel({
    required String viewMessage,
    required Description description,
    required Object? exception,
    required StackTrace? stackTrace,
  }) async {
    final bool result = await _requestIntercept();
    if (result) {
      httpResponse.setCancel(viewMessage, description, exception, stackTrace);
    }
    return this;
  }

  /// 直接通过。
  Future<HttpStore<REQVO, REQPVO, RESPCCOL, RESPDVO>> setPass(Response<Map<String, dynamic>> response) async {
    final bool result = await _requestIntercept();
    if (result) {
      httpResponse.setPass(response);
    }
    return this;
  }
}

abstract class HttpStore_GET<REQPVO extends RequestParamsVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO>
    extends HttpStore<RequestDataVO, REQPVO, RESPCCOL, RESPDVO> {
  HttpStore_GET(
    String path,
    REQPVO requestParamsVO,
    RESPCCOL responseCodeCollect,
    RESPDVO putResponseDataVO(Map<String, Object?> json),
  ) {
    httpRequest = HttpRequest<RequestDataVO, REQPVO>(
      method: 'GET',
      path: path,
      requestHeaders: null,
      requestParamsVO: requestParamsVO,
      requestDataVO: null,
    );
    httpResponse = HttpResponse<RESPCCOL, RESPDVO>(
      responseCodeCollect: responseCodeCollect,
      putResponseDataVO: putResponseDataVO,
    );
  }
}

abstract class HttpStore_POST<REQVO extends RequestDataVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO>
    extends HttpStore<REQVO, RequestParamsVO, RESPCCOL, RESPDVO> {
  HttpStore_POST(
    String path,
    REQVO? requestDataVO,
    RESPCCOL responseCodeCollect,
    RESPDVO putResponseDataVO(Map<String, Object?> json),
  ) {
    httpRequest = HttpRequest<REQVO, RequestParamsVO>(
      method: 'POST',
      path: path,
      requestHeaders: null,
      requestParamsVO: null,
      requestDataVO: requestDataVO,
    );
    httpResponse = HttpResponse<RESPCCOL, RESPDVO>(
      responseCodeCollect: responseCodeCollect,
      putResponseDataVO: putResponseDataVO,
    );
  }
}

@JsonSerializable()
@StackTraceConverter()
class HttpStore_Error extends HttpStore {
  HttpStore_Error() {
    httpRequest = HttpRequest(
      method: 'error_method',
      path: 'error_path',
      requestHeaders: null,
      requestParamsVO: null,
      requestDataVO: null,
    );
    httpResponse = HttpResponse(
      responseCodeCollect: null,
      putResponseDataVO: null,
    );
  }

  factory HttpStore_Error.fromJson(Map<String, Object?> json) => _$HttpStore_ErrorFromJson(json);

  @override
  Map<String, Object?> toJson() => _$HttpStore_ErrorToJson(this);
}

@JsonSerializable()
class HttpStore_Clone extends HttpStore {
  HttpStore_Clone();

  factory HttpStore_Clone.fromJson(Map<String, Object?> json) => _$HttpStore_CloneFromJson(json);

  @override
  Map<String, Object?> toJson() => _$HttpStore_CloneToJson(this);
}
