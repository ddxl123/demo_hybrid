// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpStore_login_and_register_by_email_send_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpStore_login_and_register_by_email_send_email
    _$HttpStore_login_and_register_by_email_send_emailFromJson(
        Map<String, dynamic> json) {
  return HttpStore_login_and_register_by_email_send_email()
    ..httpRequest =
        HttpRequest.fromJson(json['httpRequest'] as Map<String, dynamic>)
    ..httpResponse =
        HttpResponse.fromJson(json['httpResponse'] as Map<String, dynamic>);
}

Map<String, dynamic> _$HttpStore_login_and_register_by_email_send_emailToJson(
        HttpStore_login_and_register_by_email_send_email instance) =>
    <String, dynamic>{
      'httpRequest': instance.httpRequest.toJson(),
      'httpResponse': instance.httpResponse.toJson(),
    };

RequestDataVO_LARBESE _$RequestDataVO_LARBESEFromJson(
    Map<String, dynamic> json) {
  return RequestDataVO_LARBESE(
    email: json['email'] as String,
  );
}

Map<String, dynamic> _$RequestDataVO_LARBESEToJson(
        RequestDataVO_LARBESE instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

ResponseDataVO_LARBESE _$ResponseDataVO_LARBESEFromJson(
    Map<String, dynamic> json) {
  return ResponseDataVO_LARBESE();
}

Map<String, dynamic> _$ResponseDataVO_LARBESEToJson(
        ResponseDataVO_LARBESE instance) =>
    <String, dynamic>{};

ResponseCodeCollect_LARBESE _$ResponseCodeCollect_LARBESEFromJson(
    Map<String, dynamic> json) {
  return ResponseCodeCollect_LARBESE();
}

Map<String, dynamic> _$ResponseCodeCollect_LARBESEToJson(
        ResponseCodeCollect_LARBESE instance) =>
    <String, dynamic>{};
