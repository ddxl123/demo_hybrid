// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names


import 'package:hybrid/data/mysql/constant/PathConstant.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpRequest.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpResponse.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';

class HttpStore_login_and_register_by_email_send_email extends HttpStore_POST<RequestDataVO_LARBESE, ResponseCodeCollect_LARBESE, ResponseNullDataVO> {
  HttpStore_login_and_register_by_email_send_email({
    required RequestDataVO_LARBESE getRequestDataVO_LARBESE(),
  }) : super(
          PathConstant.LONGIN_AND_REGISTER_BY_EMAIL_SEND_EMAIL,
          getRequestDataVO_LARBESE,
          ResponseCodeCollect_LARBESE(),
          ResponseNullDataVO(),
        );
}

class RequestDataVO_LARBESE extends RequestDataVO {
  RequestDataVO_LARBESE({required this.email});

  final KeyValue<String> email;

  @override
  List<KeyValue<Object?>> get keyValues => <KeyValue<Object?>>[email];
}

class ResponseCodeCollect_LARBESE extends ResponseCodeCollect {
  /// 邮箱已发送, 请注意查收!
  final int C2_01_01_01 = 2010101;
}
