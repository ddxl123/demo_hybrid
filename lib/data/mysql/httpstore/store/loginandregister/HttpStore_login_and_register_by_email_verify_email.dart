// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpRequest.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';

class HttpStore_login_and_register_by_email_verify_email extends HttpStore_POST<RequestDataVO_LARBEVE, ResponseCodeCollect_LARBEVE, ResponseDataVO_LARBEVE> {
  HttpStore_login_and_register_by_email_verify_email({
    required RequestDataVO_LARBEVE getRequestDataVO_LARBEVE(),
  }) : super(
          PathConstant.LONGIN_AND_REGISTER_BY_EMAIL_VERIFY_EMAIL,
          getRequestDataVO_LARBEVE,
          ResponseCodeCollect_LARBEVE(),
          ResponseDataVO_LARBEVE(),
        );
}

class RequestDataVO_LARBEVE extends RequestDataVO {
  RequestDataVO_LARBEVE({required this.email, required this.code});

  final KeyValue<String> email;

  final KeyValue<int> code;

  @override
  List<KeyValue<Object?>> get keyValues => <KeyValue<Object?>>[email, code];
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

class ResponseDataVO_LARBEVE extends ResponseDataVO {
  late int user_id;
  late String token;

  @override
  ResponseDataVO from(Map<String, dynamic> dataJson) {
    user_id = dataJson['user_id'] as int;
    token = dataJson['token'] as String;
    return this;
  }
}
