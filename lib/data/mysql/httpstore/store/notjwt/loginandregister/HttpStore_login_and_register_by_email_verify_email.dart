// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpRequest.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'HttpStore_login_and_register_by_email_verify_email.g.dart';

class HttpStore_login_and_register_by_email_verify_email extends HttpStore_POST<RequestDataVO_LARBEVE, ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> {
  HttpStore_login_and_register_by_email_verify_email({
    required RequestDataVO_LARBEVE setRequestDataVO_LARBEVE(),
  }) : super(
          PathConstant.LONGIN_AND_REGISTER_BY_EMAIL_VERIFY_EMAIL,
          setRequestDataVO_LARBEVE,
          ResponseCodeCollect_LARBEVE(),
          (Map<String, Object?> json) => ResponseDataVO_LARBEVE.fromJson(json),
        );
}

@JsonSerializable()
class RequestDataVO_LARBEVE extends RequestDataVO {
  RequestDataVO_LARBEVE({required this.email, required this.code});

  factory RequestDataVO_LARBEVE.fromJson(Map<String, Object?> json) => _$RequestDataVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_LARBEVEToJson(this);

  final String email;

  final int code;
}

@JsonSerializable()
class ResponseDataVO_LARBEVE extends ResponseDataVO {
  ResponseDataVO_LARBEVE({required this.user_id, required this.token});

  factory ResponseDataVO_LARBEVE.fromJson(Map<String, Object?> json) => _$ResponseDataVO_LARBEVEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_LARBEVEToJson(this);

  late int user_id;
  late String token;
}

class ResponseCodeCollect_LARBEVE extends ResponseCodeCollect {
  /// 注册成功。
  final int C2_01_02_01 = 2010201;

  /// 登陆成功。
  final int C2_01_02_02 = 2010202;

  /// 邮箱重复异常，请联系管理员！
  final int C2_01_02_03 = 2010203;

  /// 验证码不正确！
  final int C2_01_02_04 = 2010204;
}
