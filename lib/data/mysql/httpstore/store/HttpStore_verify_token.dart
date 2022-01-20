// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part 'HttpStore_verify_token.g.dart';

class HttpStore_verify_token extends HttpStore<RequestHeadersVO_VT, RequestParamsVO_VT, RequestDataVO_VT,
    ResponseHeadersVO_VT, ResponseDataVO_VT, ResponseCodeCollect_VT> {
  HttpStore_verify_token({
    required RequestHeadersVO_VT requestHeadersVO_VT,
    required RequestParamsVO_VT requestParamsVO_VT,
    required RequestDataVO_VT requestDataVO_VT,
  }) : super(
          putHttpRequest: () => HttpRequest<RequestHeadersVO_VT, RequestParamsVO_VT, RequestDataVO_VT>(
            method: 'POST',
            path: r'no_jwt/verify_token',
            requestHeadersVO: requestHeadersVO_VT,
            requestParamsVO: requestParamsVO_VT,
            requestDataVO: requestDataVO_VT,
          ),
          responseCodeCollect: ResponseCodeCollect_VT(),
        );

  HttpStore_verify_token.fromJson(Map<String, Object?> json) : super.fromJson(json);

  @override
  RequestHeadersVO_VT toVOForRequestHeadersVO(Map<String, Object?> json) => RequestHeadersVO_VT.fromJson(json);

  @override
  RequestParamsVO_VT toVOForRequestParamsVO(Map<String, Object?> json) => RequestParamsVO_VT.fromJson(json);

  @override
  RequestDataVO_VT toVOForRequestDataVO(Map<String, Object?> json) => RequestDataVO_VT.fromJson(json);

  @override
  ResponseCodeCollect_VT toVOForResponseCodeCollect(Map<String, Object?> json) => ResponseCodeCollect_VT.fromJson(json);

  @override
  ResponseDataVO_VT toVOForResponseDataVO(Map<String, Object?> json) => ResponseDataVO_VT.fromJson(json);

  @override
  ResponseHeadersVO_VT toVOForResponseHeadersVO(Map<String, Object?> json) => ResponseHeadersVO_VT.fromJson(json);
}

@JsonSerializable()
class RequestHeadersVO_VT extends RequestHeadersVO {
  RequestHeadersVO_VT();
    
  factory RequestHeadersVO_VT.fromJson(Map<String, Object?> json) => _$RequestHeadersVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestHeadersVO_VTToJson(this);
  
  
}

@JsonSerializable()
class RequestParamsVO_VT extends RequestParamsVO {
  RequestParamsVO_VT();
    
  factory RequestParamsVO_VT.fromJson(Map<String, Object?> json) => _$RequestParamsVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestParamsVO_VTToJson(this);
    
  
}

@JsonSerializable()
class RequestDataVO_VT extends RequestDataVO {
  RequestDataVO_VT({required this.token,});
    
  factory RequestDataVO_VT.fromJson(Map<String, Object?> json) => _$RequestDataVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_VTToJson(this);
    
  final String token;

}

@JsonSerializable()
class ResponseHeadersVO_VT extends ResponseHeadersVO {
  ResponseHeadersVO_VT();
    
  factory ResponseHeadersVO_VT.fromJson(Map<String, Object?> json) => _$ResponseHeadersVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseHeadersVO_VTToJson(this);
    
  
}

@JsonSerializable()
class ResponseDataVO_VT extends ResponseDataVO {
  ResponseDataVO_VT({required this.new_token,});
    
  factory ResponseDataVO_VT.fromJson(Map<String, Object?> json) => _$ResponseDataVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_VTToJson(this);
    
  final String new_token;

}

@JsonSerializable()
class ResponseCodeCollect_VT extends ResponseCodeCollect {
  ResponseCodeCollect_VT();

  factory ResponseCodeCollect_VT.fromJson(Map<String, Object?> json) => _$ResponseCodeCollect_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseCodeCollect_VTToJson(this);


}    
