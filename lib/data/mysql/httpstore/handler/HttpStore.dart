// ignore_for_file: camel_case_types

import 'package:dio/dio.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpRequest.dart';
import 'HttpRequestIntercept.dart';
import 'HttpResponse.dart';

abstract class HttpStore<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO> {
  late final HttpRequest<REQVO, REQPVO> httpRequest;
  late final HttpResponse<RESPCCOL, RESPDVO> httpResponse;

  /// 返回 false 表示拦截发生异常。
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
    REQPVO getRequestParamsVO(),
    RESPCCOL responseCodeCollect,
    RESPDVO responseDataVO,
  ) {
    httpRequest = HttpRequest<RequestDataVO, REQPVO>(
      method: 'GET',
      path: path,
      getRequestHeaders: null,
      getRequestParamsVO: getRequestParamsVO,
      getRequestDataVO: null,
    );
    httpResponse = HttpResponse<RESPCCOL, RESPDVO>(
      responseCodeCollect: responseCodeCollect,
      responseDataVO: responseDataVO,
    );
  }
}

abstract class HttpStore_POST<REQVO extends RequestDataVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO>
    extends HttpStore<REQVO, RequestParamsVO, RESPCCOL, RESPDVO> {
  HttpStore_POST(
    String path,
    REQVO getRequestDataVO(),
    RESPCCOL responseCodeCollect,
    RESPDVO responseDataVO,
  ) {
    httpRequest = HttpRequest<REQVO, RequestParamsVO>(
      method: 'POST',
      path: path,
      getRequestHeaders: null,
      getRequestParamsVO: null,
      getRequestDataVO: getRequestDataVO,
    );
    httpResponse = HttpResponse<RESPCCOL, RESPDVO>(
      responseCodeCollect: responseCodeCollect,
      responseDataVO: responseDataVO,
    );
  }
}
