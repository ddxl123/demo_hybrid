import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpHandler.dart';
import 'HttpRequest.dart';
import 'HttpResponse.dart';

abstract class HttpStore<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO, RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO>
    implements DoSerializable {
  HttpStore({
    required HttpRequest<REQVO, REQPVO> putHttpRequest(),
    required RESPCCOL putResponseCodeCollect,
  }) {
    httpHandler = HttpHandler(this);
    try {
      httpRequest = putHttpRequest();
      httpResponse = HttpResponse<RESPCCOL, RESPDVO>(putResponseCodeCollect: putResponseCodeCollect.toJson());
    } catch (e, st) {
      httpHandler.setCancel(vm: '', descp: Description(''), e: e, st: st);
    }
  }

  /// [HttpStore] 抽象类以及继承类，只能存在这两个熟悉，因为需要进行序列化和反序列化。
  late final HttpRequest<REQVO, REQPVO> httpRequest;
  late final HttpResponse<RESPCCOL, RESPDVO> httpResponse;
  late final HttpHandler httpHandler;
}
