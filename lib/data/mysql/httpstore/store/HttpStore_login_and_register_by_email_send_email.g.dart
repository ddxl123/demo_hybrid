// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpStore_login_and_register_by_email_send_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestHeadersVO_LARBESE _$RequestHeadersVO_LARBESEFromJson(
        Map<String, dynamic> json) =>
    RequestHeadersVO_LARBESE()..authorization = json['authorization'] as String;

Map<String, dynamic> _$RequestHeadersVO_LARBESEToJson(
        RequestHeadersVO_LARBESE instance) =>
    <String, dynamic>{
      'authorization': instance.authorization,
    };

RequestParamsVO_LARBESE _$RequestParamsVO_LARBESEFromJson(
        Map<String, dynamic> json) =>
    RequestParamsVO_LARBESE();

Map<String, dynamic> _$RequestParamsVO_LARBESEToJson(
        RequestParamsVO_LARBESE instance) =>
    <String, dynamic>{};

RequestDataVO_LARBESE _$RequestDataVO_LARBESEFromJson(
        Map<String, dynamic> json) =>
    RequestDataVO_LARBESE(
      email: json['email'] as String,
    );

Map<String, dynamic> _$RequestDataVO_LARBESEToJson(
        RequestDataVO_LARBESE instance) =>
    <String, dynamic>{
      'email': instance.email,
    };

ResponseHeadersVO_LARBESE _$ResponseHeadersVO_LARBESEFromJson(
        Map<String, dynamic> json) =>
    ResponseHeadersVO_LARBESE();

Map<String, dynamic> _$ResponseHeadersVO_LARBESEToJson(
        ResponseHeadersVO_LARBESE instance) =>
    <String, dynamic>{};

ResponseDataVO_LARBESE _$ResponseDataVO_LARBESEFromJson(
        Map<String, dynamic> json) =>
    ResponseDataVO_LARBESE();

Map<String, dynamic> _$ResponseDataVO_LARBESEToJson(
        ResponseDataVO_LARBESE instance) =>
    <String, dynamic>{};

ResponseCodeCollect_LARBESE _$ResponseCodeCollect_LARBESEFromJson(
        Map<String, dynamic> json) =>
    ResponseCodeCollect_LARBESE();

Map<String, dynamic> _$ResponseCodeCollect_LARBESEToJson(
        ResponseCodeCollect_LARBESE instance) =>
    <String, dynamic>{};
