// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part 'HttpStore_login_and_register_by_email_send_email.g.dart';

@JsonSerializable()
class HttpStore_login_and_register_by_email_send_email extends HttpStore_POST<RequestDataVO_LARBESE, ResponseCodeCollect_LARBESE, ResponseDataVO_LARBESE> {
  HttpStore_login_and_register_by_email_send_email({
    RequestDataVO_LARBESE? putRequestDataVO_LARBESE()?,
  }) : super(
          r'no_jwt/login_and_register_by_email/send_email',
          putRequestDataVO_LARBESE,
          () => ResponseCodeCollect_LARBESE(),
          (Map<String, Object?>? json) => ResponseDataVO_LARBESE.fromJson(json ?? <String, Object?>{}),
        );
  
  factory HttpStore_login_and_register_by_email_send_email.fromJson(Map<String, Object?> json) => _$HttpStore_login_and_register_by_email_send_emailFromJson(json);

  @override
  Map<String, Object?> toJson() => _$HttpStore_login_and_register_by_email_send_emailToJson(this);
}

@JsonSerializable()
class RequestDataVO_LARBESE extends RequestDataVO {
  RequestDataVO_LARBESE(
    {required this.email,});

  factory RequestDataVO_LARBESE.fromJson(Map<String, Object?> json) => _$RequestDataVO_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_LARBESEToJson(this);

  final String email;
}

@JsonSerializable()
class ResponseDataVO_LARBESE extends ResponseDataVO {
  ResponseDataVO_LARBESE(
    
  );

  factory ResponseDataVO_LARBESE.fromJson(Map<String, Object?> json) => _$ResponseDataVO_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_LARBESEToJson(this);

  
}

@JsonSerializable()
class ResponseCodeCollect_LARBESE extends ResponseCodeCollect {
  ResponseCodeCollect_LARBESE();

  factory ResponseCodeCollect_LARBESE.fromJson(Map<String, Object?> json) => _$ResponseCodeCollect_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseCodeCollect_LARBESEToJson(this);

    /// 邮箱已发送, 请注意查收!
  final int C2_01_01_01 = 2010101;
  
}