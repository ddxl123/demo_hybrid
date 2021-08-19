abstract class _RequestVO {
  List<KeyValue<Object?>> get keyValues;

  Map<String, dynamic> toJson() {
    final Map<String, Object?> json = <String, Object?>{};
    for (final KeyValue<Object?> item in keyValues) {
      json.addAll(<String, Object?>{item.key: item.value});
    }
    return json;
  }
}

abstract class RequestDataVO extends _RequestVO {}

abstract class RequestParamsVO extends _RequestVO {}

class KeyValue<V> {
  KeyValue(this.key, this.value);

  late String key;
  late V value;
}

/// 之所以 [requestHeaders]、[requestDataVO]、[requestParamsVO] 是回调函数，是为了对其输入的不正确数据进行置空处理，
/// 只有被引用时才会抛出异常，而在被引用前已将该对象创建成功（哪怕请求数据是空），这样做的话，能捕获到请求数据的异常。
class HttpRequest<REQVO extends RequestDataVO, REQPVO extends RequestParamsVO> {
  HttpRequest({
    required this.method,
    required this.path,
    required Map<String, dynamic>? getRequestHeaders()?,
    required REQVO? getRequestDataVO()?,
    required REQPVO? getRequestParamsVO()?,
  }) {
    try {
      requestHeaders = getRequestHeaders?.call();
      requestDataVO = getRequestDataVO?.call();
      requestParamsVO = getRequestParamsVO?.call();
    } catch (e, st) {
      exception = e;
      stackTrace = st;
    }
  }

  /// 请求方法。GET/POST
  final String method;

  /// 请求 url。
  final String path;

  /// 请求头。
  Map<String, dynamic>? requestHeaders;

  /// 请求体 body VO 模型。
  late final REQVO? requestDataVO;

  /// 请求体 params VO 模型。
  late final REQPVO? requestParamsVO;

  /// 请求数据是否出现异常。
  bool hasErrors() => exception != null;

  /// 请求数据的异常 (单独捕获)。
  late Object? exception;

  /// 请求数据的 StackTrace (单独捕获)。
  late StackTrace? stackTrace;
}
