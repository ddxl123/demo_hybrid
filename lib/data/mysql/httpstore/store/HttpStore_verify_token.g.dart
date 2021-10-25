// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpStore_verify_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpStore_verify_token _$HttpStore_verify_tokenFromJson(
    Map<String, dynamic> json) {
  return HttpStore_verify_token()
    ..httpRequest =
        HttpRequest.fromJson(json['httpRequest'] as Map<String, dynamic>)
    ..httpResponse =
        HttpResponse.fromJson(json['httpResponse'] as Map<String, dynamic>);
}

Map<String, dynamic> _$HttpStore_verify_tokenToJson(
        HttpStore_verify_token instance) =>
    <String, dynamic>{
      'httpRequest': instance.httpRequest.toJson(),
      'httpResponse': instance.httpResponse.toJson(),
    };

RequestDataVO_VT _$RequestDataVO_VTFromJson(Map<String, dynamic> json) {
  return RequestDataVO_VT(
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$RequestDataVO_VTToJson(RequestDataVO_VT instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

ResponseDataVO_VT _$ResponseDataVO_VTFromJson(Map<String, dynamic> json) {
  return ResponseDataVO_VT(
    new_token: json['new_token'] as String,
  );
}

Map<String, dynamic> _$ResponseDataVO_VTToJson(ResponseDataVO_VT instance) =>
    <String, dynamic>{
      'new_token': instance.new_token,
    };

ResponseCodeCollect_VT _$ResponseCodeCollect_VTFromJson(
    Map<String, dynamic> json) {
  return ResponseCodeCollect_VT();
}

Map<String, dynamic> _$ResponseCodeCollect_VTToJson(
        ResponseCodeCollect_VT instance) =>
    <String, dynamic>{};
