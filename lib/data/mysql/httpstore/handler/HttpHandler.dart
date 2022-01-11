import 'package:dio/dio.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpResponseIntercept.dart';
import 'HttpStore.dart';

/// 内属性只有 [_singleResult]。
class HttpHandler {
  HttpHandler(HttpStore httpStore) {
    _singleResult.setData(httpStore);
  }

  /// 必须额外配置 [data]。
  /// 若把 data(这里为 [httpStore]) 也在 [_singleResult] 中转化成 json，而不采用将 [httpStore] 手动传入，
  /// 则 fromJson 后，会造成真正的 [httpStore] 与 [json] 解析的 [httpStore] 不属于同一个对象的问题！
  factory HttpHandler.fromJson(HttpStore newHttpStore, Map<String, Object?> json) => HttpHandler(newHttpStore)
    .._singleResult.resetAllExcludeData(SingleResult.fromJson(json: json, dataCast: (Object data) => throw '当 data 为 null 时，dataCast 函数不应该被调用！'));

  /// 必须额外移除 [data]
  Map<String, Object?> toJson() => _singleResult.toJsonExcludeData();

  final SingleResult<HttpStore> _singleResult = SingleResult<HttpStore>();

  SingleResult<HttpStore> setPass(Response<Map<String, Object?>> response) {
    return _singleResult.setSuccess(
      putData: () => _singleResult.getRequiredData()
        ..httpResponse.setResponse(
          // 云端响应的 code 不能为空。
          code: response.data!['code']! as int,
          // 云端响应的 viewMessage 不能为空。
          viewMessage: response.data!['message']! as String,
          putResponseDataVO: response.data!['data'] == null ? <String, Object?>{} : response.data!['data']!.quickCast(),
          putResponseHeadersVO: response.headers.map,
        ),
    );
  }

  SingleResult<HttpStore> setError({required String vm, required Description descp, required Object e, required StackTrace? st}) {
    return _singleResult.setError(vm: vm, descp: descp, e: e, st: st);
  }

  /// 必须先 [setCancel]/[setPass]，再 [handle]。
  /// 必须先 [setCancel]/[setPass]，再 [doContinue]/[doCancel]。
  Future<void> handle<HS extends HttpStore>({
    required Future<bool> doContinue(HS hs),
    required Future<void> doCancel(SingleResult<HS> hh),
  }) async {
    await _singleResult.handle(
      doSuccess: (HttpStore successData) async {
        successData.httpResponse.responseCodeCollect.responseCode = successData.httpResponse.code;
        final bool isIntercept = await HttpResponseIntercept(successData).intercept();
        if (isIntercept) {
          await doCancel(_singleResult as SingleResult<HS>);
        } else {
          try {
            final bool isFinal = await doContinue(successData as HS);
            if (!isFinal) {
              setError(
                vm: '响应 code 未处理！',
                descp: Description(''),
                e: Exception('未处理的响应code: ${_singleResult.getRequiredData().httpResponse.code}'),
                st: null,
              );
              await doCancel(_singleResult as SingleResult<HS>);
            }
          } catch (e, st) {
            setError(vm: 'doContinue 内部异常！', descp: Description(''), e: e, st: st);
            await doCancel(_singleResult as SingleResult<HS>);
          }
        }
      },
      doError: (SingleResult<HttpStore> errorResult) async {
        await doCancel(_singleResult as SingleResult<HS>);
      },
    );
  }

  void resetAll(HttpHandler newHttpHandler) {
    _singleResult.resetAll(newHttpHandler._singleResult);
  }
}
