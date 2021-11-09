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
        httpHandler.setCancel(vm: '请求方法异常！', descp: Description(''), e: Exception('method:GET, requestDataVO: isNotEmpty'), st: null);
      } else if (httpRequest.method == 'POST' && httpRequest.requestParamsVO.isNotEmpty) {
        httpHandler.setCancel(vm: '请求方法异常！', descp: Description(''), e: Exception('method:POST, requestParamsVO: isNotEmpty'), st: null);
      }
      httpResponse = HttpResponse<RESPHVO, RESPDVO, RESPCCOL>(putResponseCodeCollect: putResponseCodeCollect.toJson());
    } catch (e, st) {
      httpHandler.setCancel(vm: '', descp: Description(''), e: e, st: st);
    }
  }

  HttpStore.empty();

  /// [HttpStore] 抽象类以及继承类，只能存在这两个熟悉，因为需要进行序列化和反序列化。
  late final HttpRequest<REQHVO, REQPVO, REQVO> httpRequest;
  late final HttpResponse<RESPHVO, RESPDVO, RESPCCOL> httpResponse;
  late final HttpHandler httpHandler;
}
