// ignore_for_file: camel_case_types
// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import '../handler/HttpRequest.dart';
import '../handler/HttpResponse.dart';
import '../handler/HttpStore.dart';

part 'HttpStore_verify_token.g.dart';

@JsonSerializable()
class HttpStore_verify_token extends HttpStore_POST<RequestDataVO_VT, ResponseCodeCollect_VT, ResponseDataVO_VT> {
  HttpStore_verify_token({
    RequestDataVO_VT? requestDataVO_VT,
  }) : super(
          r'no_jwt/verify_token',
          requestDataVO_VT,
          ResponseCodeCollect_VT(),
          (Map<String, Object?> json) => ResponseDataVO_VT.fromJson(json),
        );
  
  factory HttpStore_verify_token.fromJson(Map<String, Object?> json) => _$HttpStore_verify_tokenFromJson(json);

  @override
  Map<String, Object?> toJson() => _$HttpStore_verify_tokenToJson(this);
}

@JsonSerializable()
class RequestDataVO_VT extends RequestDataVO {
  RequestDataVO_VT(
    {required this.token,});

  factory RequestDataVO_VT.fromJson(Map<String, Object?> json) => _$RequestDataVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$RequestDataVO_VTToJson(this);

  final String token;
}

@JsonSerializable()
class ResponseDataVO_VT extends ResponseDataVO {
  ResponseDataVO_VT(
    {required this.new_token,}
  );

  factory ResponseDataVO_VT.fromJson(Map<String, Object?> json) => _$ResponseDataVO_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseDataVO_VTToJson(this);

  late String new_token;
}

@JsonSerializable()
class ResponseCodeCollect_VT extends ResponseCodeCollect {
  ResponseCodeCollect_VT();

  factory ResponseCodeCollect_VT.fromJson(Map<String, Object?> json) => _$ResponseCodeCollect_VTFromJson(json);

  @override
  Map<String, Object?> toJson() => _$ResponseCodeCollect_VTToJson(this);

  
}