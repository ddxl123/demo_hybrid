// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part 'HttpStore_login_and_register_by_email_send_email.g.dart';

class HttpStore_login_and_register_by_email_send_email extends HttpStore<RequestHeadersVO_LARBESE, RequestParamsVO_LARBESE, RequestDataVO_LARBESE,
    ResponseHeadersVO_LARBESE, ResponseDataVO_LARBESE, ResponseCodeCollect_LARBESE> {
  HttpStore_login_and_register_by_email_send_email({
    required RequestHeadersVO_LARBESE requestHeadersVO_LARBESE,
    required RequestParamsVO_LARBESE requestParamsVO_LARBESE,
    required RequestDataVO_LARBESE requestDataVO_LARBESE,
  }) : super(
          putHttpRequest: () => HttpRequest<RequestHeadersVO_LARBESE, RequestParamsVO_LARBESE, RequestDataVO_LARBESE>(
            method: 'POST',
            path: r'no_jwt/login_and_register_by_email/send_email',
            putRequestHeadersVO: requestHeadersVO_LARBESE.toJson(),
            putRequestParamsVO: requestParamsVO_LARBESE.toJson(),
            putRequestDataVO: requestDataVO_LARBESE.toJson(),
          ),
          putResponseCodeCollect: ResponseCodeCollect_LARBESE(),
        );

  HttpStore_login_and_register_by_email_send_email.fromJson(Map<String, Object?> json) : super.fromJson(json);
}

@JsonSerializable()
class RequestHeadersVO_LARBESE extends RequestHeadersVO {
  RequestHeadersVO_LARBESE();

  factory RequestHeadersVO_LARBESE.fromJson(Map<String, Object?> json) => _$RequestHeadersVO_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestHeadersVO_LARBESEToJson(this);
}

@JsonSerializable()
class RequestParamsVO_LARBESE extends RequestParamsVO {
  RequestParamsVO_LARBESE();

  factory RequestParamsVO_LARBESE.fromJson(Map<String, Object?> json) => _$RequestParamsVO_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestParamsVO_LARBESEToJson(this);
}

@JsonSerializable()
class RequestDataVO_LARBESE extends RequestDataVO {
  RequestDataVO_LARBESE({
    required this.email,
  });

  factory RequestDataVO_LARBESE.fromJson(Map<String, Object?> json) => _$RequestDataVO_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_LARBESEToJson(this);

  final String email;
}

@JsonSerializable()
class ResponseHeadersVO_LARBESE extends ResponseHeadersVO {
  ResponseHeadersVO_LARBESE();

  factory ResponseHeadersVO_LARBESE.fromJson(Map<String, Object?> json) => _$ResponseHeadersVO_LARBESEFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseHeadersVO_LARBESEToJson(this);
}

@JsonSerializable()
class ResponseDataVO_LARBESE extends ResponseDataVO {
  ResponseDataVO_LARBESE();

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
