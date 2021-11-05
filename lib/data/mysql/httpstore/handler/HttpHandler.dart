import 'package:dio/dio.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpResponseIntercept.dart';
import 'HttpStore.dart';

class HttpHandler {
  HttpHandler(this.httpStore);

  final HttpStore httpStore;

  String? viewMessage;

  Description? description;

  /// 用 [exception] 是否为 null 来判断是否 doContinue。
  Object? exception;

  StackTrace? stackTrace;

  bool isSet = false;

  bool _hasError() => exception != null;

  void _reSetCancel() {
    viewMessage = '重复处理异常！';
    description = Description('');
    exception = '重复处理异常！';
    stackTrace = null;
  }

  /// [e] 不能为空，因为需要根据 [e] 来判断是否 [doCancel]。
  HttpStore setCancel({required String vm, required Description descp, required Object e, required StackTrace? st}) {
    if (isSet) {
      _reSetCancel();
      return httpStore;
    }
    isSet = true;

    viewMessage = vm;
    description = descp;
    exception = e;
    stackTrace = st;
    return httpStore;
  }

  HttpStore setPass(Response<Map<String, Object?>> response) {
    if (isSet) {
      _reSetCancel();
      return httpStore;
    }

    try {
      httpStore.httpResponse.setAll(
        // 云端响应的 code 不能为空。
        code: response.data!['code']! as int,
        // 云端响应的 viewMessage 不能为空。
        viewMessage: response.data!['message']! as String,
        responseDataVO: response.data!['data'] == null ? <String, Object?>{} : response.data!['data']! as Map<String, Object?>,
        responseHeaders: response.headers.map,
      );
      isSet = true;
    } catch (e, st) {
      setCancel(vm: '响应数据解析异常！', descp: Description(''), e: e, st: st);
    }
    return httpStore;
  }

  /// 必须先 [setCancel]/[setPass]，再 [handle]。
  /// 必须先 [setCancel]/[setPass]，再 [doContinue]/[doCancel]。
  Future<void> handle({
    required Future<bool> doContinue(HttpStore httpStore),
    required Future<void> doCancel(HttpHandler httpHandler),
  }) async {
    if (!isSet) {
      setCancel(vm: '请求未完全处理！', descp: Description(''), e: Exception('必须先进行 setCancel/setPass，才能进行 handle！'), st: null);
      await doCancel(this);
      return;
    }
    if (!_hasError()) {
      final bool isIntercept = await HttpResponseIntercept(httpStore).intercept();
      if (isIntercept) {
        /// HttpResponseIntercept 内已进行 setCancel。
        await doCancel(this);
      } else {
        try {
          final bool isFinal = await doContinue(httpStore);
          if (!isFinal) {
            setCancel(vm: '响应 code 未处理！', descp: Description(''), e: Exception('未处理的响应code: ${httpStore.httpResponse.code}'), st: null);
            await doCancel(this);
          }
        } catch (e, st) {
          setCancel(vm: 'doContinue 内部异常！', descp: Description(''), e: e, st: st);
          await doCancel(this);
        }
      }
    } else {
      await doCancel(this);
    }
  }
}
