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
  /// [HttpStore] 抽象类以及继承类，只能存在这两个熟悉，因为需要进行序列化和反序列化。
  late HttpRequest<REQVO, REQPVO> httpRequest;
  late HttpResponse<RESPCCOL, RESPDVO> httpResponse;

  /// 返回 false 表示拦截发生异常。
  ///
  /// 无论是被 [setCancel] 还是被 [setPass]，都需要配置 [_requestIntercept] 的结果。
  Future<bool> _requestIntercept() async {
    try {
      if (httpRequest.hasErrors()) {
        httpResponse.setCancel('请求数据解析异常！', Description('httpRequest 内部异常！'), httpRequest.exception, httpRequest.stackTrace);
        return false;
      }
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
    if (!result) {
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
    REQPVO? putRequestParamsVO()?,
    RESPCCOL putResponseCodeCollect(),
    RESPDVO putResponseDataVO(Map<String, Object?>? json),
  ) {
    httpRequest = HttpRequest<RequestDataVO, REQPVO>(
      method: 'GET',
      path: path,
      putRequestHeaders: null,
      putRequestParamsVO: putRequestParamsVO,
      putRequestDataVO: null,
    );
    httpResponse = HttpResponse<RESPCCOL, RESPDVO>(
      putResponseCodeCollect: putResponseCodeCollect,
      putResponseDataVO: putResponseDataVO,
    );
  }
}

abstract class HttpStore_POST<REQVO extends RequestDataVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO>
    extends HttpStore<REQVO, RequestParamsVO, RESPCCOL, RESPDVO> {
  HttpStore_POST(
    String path,
    REQVO? putRequestDataVO()?,
    RESPCCOL putResponseCodeCollect(),
    RESPDVO putResponseDataVO(Map<String, Object?>? json),
  ) {
    httpRequest = HttpRequest<REQVO, RequestParamsVO>(
      method: 'POST',
      path: path,
      putRequestHeaders: null,
      putRequestParamsVO: null,
      putRequestDataVO: putRequestDataVO,
    );
    httpResponse = HttpResponse<RESPCCOL, RESPDVO>(
      putResponseCodeCollect: putResponseCodeCollect,
      putResponseDataVO: putResponseDataVO,
    );
  }
}

@JsonSerializable()
@StackTraceConverter()
class HttpStore_Error extends HttpStore {
  HttpStore_Error() {
    httpRequest = HttpRequest(
      method: 'have_error',
      path: 'have_error',
      putRequestHeaders: null,
      putRequestParamsVO: null,
      putRequestDataVO: null,
    );
    httpResponse = HttpResponse(
      putResponseCodeCollect: null,
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
