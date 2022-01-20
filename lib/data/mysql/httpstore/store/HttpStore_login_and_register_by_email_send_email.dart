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
            requestHeadersVO: requestHeadersVO_LARBESE,
            requestParamsVO: requestParamsVO_LARBESE,
            requestDataVO: requestDataVO_LARBESE,
          ),
          responseCodeCollect: ResponseCodeCollect_LARBESE(),
        );

  HttpStore_login_and_register_by_email_send_email.fromJson(Map<String, Object?> json) : super.fromJson(json);

  @override
  RequestHeadersVO_LARBESE toVOForRequestHeadersVO(Map<String, Object?> json) => RequestHeadersVO_LARBESE.fromJson(json);

  @override
  RequestParamsVO_LARBESE toVOForRequestParamsVO(Map<String, Object?> json) => RequestParamsVO_LARBESE.fromJson(json);

  @override
  RequestDataVO_LARBESE toVOForRequestDataVO(Map<String, Object?> json) => RequestDataVO_LARBESE.fromJson(json);

  @override
  ResponseCodeCollect_LARBESE toVOForResponseCodeCollect(Map<String, Object?> json) => ResponseCodeCollect_LARBESE.fromJson(json);

  @override
  ResponseDataVO_LARBESE toVOForResponseDataVO(Map<String, Object?> json) => ResponseDataVO_LARBESE.fromJson(json);

  @override
  ResponseHeadersVO_LARBESE toVOForResponseHeadersVO(Map<String, Object?> json) => ResponseHeadersVO_LARBESE.fromJson(json);
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
  RequestDataVO_LARBESE({required this.email,});
    
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
  ResponseCodeCollect_LARBESE C2_01_01_01() {
    if (httpStore.httpResponse.responseCode == 2010101) {
      isFinal = true;
    }
    return this;
  }
    

}    
