import 'package:dio/dio.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpResponseIntercept.dart';
import 'HttpStore.dart';

/// 与 [SingleResult] 基本一致。
class HttpHandler {
  HttpHandler(HttpStore httpStore) {
    _singleResult.setData(httpStore);
  }

  HttpHandler.empty();

  /// 必须额外配置 [data]。
  factory HttpHandler.fromJson(Map<String, Object?> json) =>
      HttpHandler.empty().._singleResult.resetAll(SingleResult.fromJson(json: json, dataCast: (Object data) => data as HttpStore));

  /// 必须额外移除 [data]
  Map<String, Object?> toJson() => _singleResult.toJson();

  final SingleResult<HttpStore> _singleResult = SingleResult<HttpStore>();

  SingleResult<HttpStore> setPass(Response<Map<String, Object?>> response) {
    return _singleResult.setSuccess(
      putData: () => _singleResult.getRequiredData()
        ..httpResponse.setAll(
          // 云端响应的 code 不能为空。
          code: response.data!['code']! as int,
          // 云端响应的 viewMessage 不能为空。
          viewMessage: response.data!['message']! as String,
          responseDataVO: response.data!['data'] == null ? <String, Object?>{} : response.data!['data']!.quickCast(),
          responseHeadersVO: response.headers.map,
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
