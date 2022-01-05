// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'HttpStore.dart';

/// token 验证失败需重新登陆的 code。
class ReLoginCodeCollect {
  /// 用户过期，请重新登陆！
  final int C3010501 = 3010501;

  /// 用户异常，请重新登陆！
  final int C3010502 = 3010502;

  /// 用户异常，请重新登陆！
  final int C3010503 = 3010503;

  /// jwt 发生其他异常。
  final int C3010504 = 3010504;
}

class HttpResponseIntercept {
  HttpResponseIntercept(this.httpStore);

  final HttpStore httpStore;
  final ReLoginCodeCollect reLoginCodeCollect = ReLoginCodeCollect();

  /// 返回 true，被拦截（doCancel）
  Future<bool> intercept() async {
    return await _tokenExceptionIntercept();
  }

  Future<bool> _tokenExceptionIntercept() async {
    // 当 pathType 为 jwt 时，若 token 检验或更新异常，则重新登陆。
    if (httpStore.httpResponse.code == reLoginCodeCollect.C3010501 ||
        httpStore.httpResponse.code == reLoginCodeCollect.C3010502 ||
        httpStore.httpResponse.code == reLoginCodeCollect.C3010503 ||
        httpStore.httpResponse.code == reLoginCodeCollect.C3010504) {
      // TODO: 这里弹出登陆框。注意，登陆时 token 生成发生异常会被重复触发 重新登陆 的操作，因此需要约束一下登陆弹框的单例性。
      httpStore.httpHandler
          .setError(vm: '请重新登陆！', descp: Description(''), e: Exception('PathType 为 jwt 时，token 检验或更新异常！响应code：${httpStore.httpResponse.code}'), st: null);
      return true;
    }
    return false;
  }
}
