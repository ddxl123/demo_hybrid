// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';

import 'HttpStore.dart';

part 'HttpResponseIntercept.g.dart';

/// token 验证失败需重新登陆的 code。
@JsonSerializable()
class ReLoginCodeCollect extends ResponseCodeCollect {
  ReLoginCodeCollect();

  factory ReLoginCodeCollect.fromJson(Map<String, Object?> json) => _$ReLoginCodeCollectFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ReLoginCodeCollectToJson(this);

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

  /// 返回是否已被拦截。
  Future<bool> _tokenExceptionIntercept() async {
    // 当 pathType 为 jwt 时，若 token 检验或更新异常，则重新登陆。
    if (httpStore.httpResponse.responseCode == reLoginCodeCollect.C3010501 ||
        httpStore.httpResponse.responseCode == reLoginCodeCollect.C3010502 ||
        httpStore.httpResponse.responseCode == reLoginCodeCollect.C3010503 ||
        httpStore.httpResponse.responseCode == reLoginCodeCollect.C3010504) {
      // TODO: 这里弹出登陆框。注意，登陆时 token 生成发生异常会被重复触发 重新登陆 的操作，因此需要约束一下登陆弹框的单例性。
      httpStore.httpHandler.setError(
          vm: '请重新登陆！', descp: Description(''), e: Exception('PathType 为 jwt 时，token 检验或更新异常！响应code：${httpStore.httpResponse.responseCode}'), st: null);
      return true;
    }
    return false;
  }
}
