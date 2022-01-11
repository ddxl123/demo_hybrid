// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part 'HttpStore_login_and_register_by_email_verify_email.g.dart';

class HttpStore_login_and_register_by_email_verify_email extends HttpStore<RequestHeadersVO_LARBEVE,
    RequestParamsVO_LARBEVE,
    RequestDataVO_LARBEVE,
    ResponseHeadersVO_LARBEVE,
    ResponseDataVO_LARBEVE,
    ResponseCodeCollect_LARBEVE> {
  HttpStore_login_and_register_by_email_verify_email({
    required RequestHeadersVO_LARBEVE requestHeadersVO_LARBEVE,
    required RequestParamsVO_LARBEVE requestParamsVO_LARBEVE,
    required RequestDataVO_LARBEVE requestDataVO_LARBEVE,
  }) : super(
    putHttpRequest: () =>
        HttpRequest<RequestHeadersVO_LARBEVE, RequestParamsVO_LARBEVE, RequestDataVO_LARBEVE>(
          method: 'POST',
          path: r'no_jwt/login_and_register_by_email/verify_email',
          putRequestHeadersVO: requestHeadersVO_LARBEVE.toJson(),
          putRequestParamsVO: requestParamsVO_LARBEVE.toJson(),
          putRequestDataVO: requestDataVO_LARBEVE.toJson(),
        ),
    putResponseCodeCollect: ResponseCodeCollect_LARBEVE(),
  );

  HttpStore_login_and_register_by_email_verify_email.fromJson(Map<String, Object?> json) : super.fromJson(json);

  @override
  RequestHeadersVO_LARBEVE toVOForRequestHeadersVO(Map<String, Object?> json) => RequestHeadersVO_LARBEVE.fromJson(json);

  @override
  RequestParamsVO_LARBEVE toVOForRequestParamsVO(Map<String, Object?> json) => RequestParamsVO_LARBEVE.fromJson(json);

  @override
  RequestDataVO_LARBEVE toVOForRequestDataVO(Map<String, Object?> json) => RequestDataVO_LARBEVE.fromJson(json);

  @override
  ResponseCodeCollect_LARBEVE toVOForResponseCodeCollect(Map<String, Object?> json) => ResponseCodeCollect_LARBEVE.fromJson(json);

  @override
  ResponseDataVO_LARBEVE toVOForResponseDataVO(Map<String, Object?> json) => ResponseDataVO_LARBEVE.fromJson(json);

  @override
  ResponseHeadersVO_LARBEVE toVOForResponseHeadersVO(Map<String, Object?> json) => ResponseHeadersVO_LARBEVE.fromJson(json);
}

@JsonSerializable()
class RequestHeadersVO_LARBEVE extends RequestHeadersVO {
  RequestHeadersVO_LARBEVE();

  factory RequestHeadersVO_LARBEVE.fromJson(Map<String, Object?> json) => _$RequestHeadersVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestHeadersVO_LARBEVEToJson(this);
}

@JsonSerializable()
class RequestParamsVO_LARBEVE extends RequestParamsVO {
  RequestParamsVO_LARBEVE();

  factory RequestParamsVO_LARBEVE.fromJson(Map<String, Object?> json) => _$RequestParamsVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestParamsVO_LARBEVEToJson(this);
}

@JsonSerializable()
class RequestDataVO_LARBEVE extends RequestDataVO {
  RequestDataVO_LARBEVE({
    required this.email,
    required this.code,
  });

  factory RequestDataVO_LARBEVE.fromJson(Map<String, Object?> json) => _$RequestDataVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_LARBEVEToJson(this);

  final String email;
  final int code;
}

@JsonSerializable()
class ResponseHeadersVO_LARBEVE extends ResponseHeadersVO {
  ResponseHeadersVO_LARBEVE();

  factory ResponseHeadersVO_LARBEVE.fromJson(Map<String, Object?> json) => _$ResponseHeadersVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseHeadersVO_LARBEVEToJson(this);
}

@JsonSerializable()
class ResponseDataVO_LARBEVE extends ResponseDataVO {
  ResponseDataVO_LARBEVE({
    required this.user_id,
    required this.token,
  });

  factory ResponseDataVO_LARBEVE.fromJson(Map<String, Object?> json) => _$ResponseDataVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_LARBEVEToJson(this);

  final int user_id;
  final String token;
}

@JsonSerializable()
class ResponseCodeCollect_LARBEVE extends ResponseCodeCollect {
  ResponseCodeCollect_LARBEVE();

  factory ResponseCodeCollect_LARBEVE.fromJson(Map<String, Object?> json) => _$ResponseCodeCollect_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseCodeCollect_LARBEVEToJson(this);

  /// 邮箱注册成功！
  final int C2_01_02_01 = 2010201;

  /// 邮箱登陆成功！
  final int C2_01_02_02 = 2010202;

  Future<R> handleCode<R>(Future<R> C2_01_02_01()) async {
    switch
    }
}
