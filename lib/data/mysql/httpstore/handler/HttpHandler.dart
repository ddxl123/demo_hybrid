import 'package:dio/dio.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpResponseIntercept.dart';
import 'HttpStore.dart';

class HttpHandler implements DoSerializable {
  HttpHandler(this.httpStore);

  final HttpStore httpStore;

  String? _viewMessage;

  String getRequiredViewMessage() => _viewMessage ?? '_viewMessage 为空！';

  Description? _description;

  Description getRequiredDescription() => _description ?? Description('_description 为空！');

  /// 用 [_exception] 是否为 null 来判断是否 doContinue。
  Object? _exception;

  Object getRequiredException() => _exception ?? Exception('_exception 为空！');

  StackTrace? stackTrace;

  bool isSet = false;

  bool _hasError() => _exception != null;

  factory HttpHandler.fromJson(HttpStore httpStore, Map<String, Object?> json) => HttpHandler(httpStore)
    .._viewMessage = json['viewMessage'] as String?
    .._description = json['description'] == null ? null : Description.fromJson(json['description']! as Map<String, Object?>)
    .._exception = json['exception'] == null ? null : Exception(json['exception'])
    ..stackTrace = json['stackTrace'] == null ? null : StackTrace.fromString(json['stackTrace']! as String)
    ..isSet = json['isSet']! as bool;

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'viewMessage': _viewMessage,
        'description': _description?.toJson(),
        'exception': _exception?.toString(),
        'stackTrace': stackTrace?.toString(),
        'isSet': isSet,
      };

  void _reSetCancel() {
    _viewMessage = '重复处理异常！';
    _description = Description('');
    _exception = '重复处理异常！';
    stackTrace = null;
  }

  /// [e] 不能为空，因为需要根据 [e] 来判断是否 [doCancel]。
  HttpStore setCancel({required String vm, required Description descp, required Object e, required StackTrace? st}) {
    if (isSet) {
      _reSetCancel();
      return httpStore;
    }
    isSet = true;

    _viewMessage = vm;
    _description = descp;
    _exception = e;
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
        responseHeadersVO: response.headers.map,
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
