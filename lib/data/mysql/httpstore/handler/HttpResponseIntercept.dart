// ignore_for_file: non_constant_identifier_names

import 'HttpResponse.dart';

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

class HttpResponseIntercept<RESPCCOL extends ResponseCodeCollect, RESPDVO extends ResponseDataVO> {
  HttpResponseIntercept(this.httpResponse);

  final HttpResponse<RESPCCOL, RESPDVO> httpResponse;
  final ReLoginCodeCollect reLoginCodeCollect = ReLoginCodeCollect();

  Future<void> handle() async {
    await _tokenExceptionIntercept();
  }

  Future<void> _tokenExceptionIntercept() async {
    // 若 token 创建或刷新异常，则重新登陆。
    if (httpResponse.code == reLoginCodeCollect.C3010501 ||
        httpResponse.code == reLoginCodeCollect.C3010502 ||
        httpResponse.code == reLoginCodeCollect.C3010503 ||
        httpResponse.code == reLoginCodeCollect.C3010504) {
      // TODO: 这里弹出登陆框。注意，登陆时 token 生成发生异常会被重复触发 重新登陆 的操作，因此需要约束一下登陆弹框的单例性。

    }
    // else{} 不能 else，因为会把其他不需要拦截的 code 给拦截住。
  }
}
