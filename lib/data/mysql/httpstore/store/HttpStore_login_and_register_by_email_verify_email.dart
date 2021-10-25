// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part 'HttpStore_login_and_register_by_email_verify_email.g.dart';

@JsonSerializable()
class HttpStore_login_and_register_by_email_verify_email extends HttpStore_POST<RequestDataVO_LARBEVE, ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> {
  HttpStore_login_and_register_by_email_verify_email({
    RequestDataVO_LARBEVE? requestDataVO_LARBEVE,
  }) : super(
          r'no_jwt/login_and_register_by_email/verify_email',
          requestDataVO_LARBEVE,
          ResponseCodeCollect_LARBEVE(),
          (Map<String, Object?> json) => ResponseDataVO_LARBEVE.fromJson(json),
        );
  
  factory HttpStore_login_and_register_by_email_verify_email.fromJson(Map<String, Object?> json) => _$HttpStore_login_and_register_by_email_verify_emailFromJson(json);

  @override
  Map<String, Object?> toJson() => _$HttpStore_login_and_register_by_email_verify_emailToJson(this);
}

@JsonSerializable()
class RequestDataVO_LARBEVE extends RequestDataVO {
  RequestDataVO_LARBEVE(
    {required this.email,required this.code,});

  factory RequestDataVO_LARBEVE.fromJson(Map<String, Object?> json) => _$RequestDataVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_LARBEVEToJson(this);

  final String email;final int code;
}

@JsonSerializable()
class ResponseDataVO_LARBEVE extends ResponseDataVO {
  ResponseDataVO_LARBEVE(
    {required this.user_id,required this.token,}
  );

  factory ResponseDataVO_LARBEVE.fromJson(Map<String, Object?> json) => _$ResponseDataVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_LARBEVEToJson(this);

  late int user_id;late String token;
}

@JsonSerializable()
class ResponseCodeCollect_LARBEVE extends ResponseCodeCollect {
  ResponseCodeCollect_LARBEVE();

  factory ResponseCodeCollect_LARBEVE.fromJson(Map<String, Object?> json) => _$ResponseCodeCollect_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseCodeCollect_LARBEVEToJson(this);

    /// 注册成功。
  final int C2_01_02_01 = 2010201;
    /// 登陆成功。
  final int C2_01_02_02 = 2010202;
    /// 邮箱重复异常，请联系管理员！
  final int C2_01_02_03 = 2010203;
    /// 验证码不正确！
  final int C2_01_02_04 = 2010204;
  
}