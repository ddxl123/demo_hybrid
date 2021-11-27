// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpStore_login_and_register_by_email_verify_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestHeadersVO_LARBEVE _$RequestHeadersVO_LARBEVEFromJson(
        Map<String, dynamic> json) =>
    RequestHeadersVO_LARBEVE();

Map<String, dynamic> _$RequestHeadersVO_LARBEVEToJson(
        RequestHeadersVO_LARBEVE instance) =>
    <String, dynamic>{};

RequestParamsVO_LARBEVE _$RequestParamsVO_LARBEVEFromJson(
        Map<String, dynamic> json) =>
    RequestParamsVO_LARBEVE();

Map<String, dynamic> _$RequestParamsVO_LARBEVEToJson(
        RequestParamsVO_LARBEVE instance) =>
    <String, dynamic>{};

RequestDataVO_LARBEVE _$RequestDataVO_LARBEVEFromJson(
        Map<String, dynamic> json) =>
    RequestDataVO_LARBEVE(
      email: json['email'] as String,
      code: json['code'] as int,
    );

Map<String, dynamic> _$RequestDataVO_LARBEVEToJson(
        RequestDataVO_LARBEVE instance) =>
    <String, dynamic>{
      'email': instance.email,
      'code': instance.code,
    };

ResponseHeadersVO_LARBEVE _$ResponseHeadersVO_LARBEVEFromJson(
        Map<String, dynamic> json) =>
    ResponseHeadersVO_LARBEVE();

Map<String, dynamic> _$ResponseHeadersVO_LARBEVEToJson(
        ResponseHeadersVO_LARBEVE instance) =>
    <String, dynamic>{};

ResponseDataVO_LARBEVE _$ResponseDataVO_LARBEVEFromJson(
        Map<String, dynamic> json) =>
    ResponseDataVO_LARBEVE(
      user_id: json['user_id'] as int,
      token: json['token'] as String,
    );

Map<String, dynamic> _$ResponseDataVO_LARBEVEToJson(
        ResponseDataVO_LARBEVE instance) =>
    <String, dynamic>{
      'user_id': instance.user_id,
      'token': instance.token,
    };

ResponseCodeCollect_LARBEVE _$ResponseCodeCollect_LARBEVEFromJson(
        Map<String, dynamic> json) =>
    ResponseCodeCollect_LARBEVE();

Map<String, dynamic> _$ResponseCodeCollect_LARBEVEToJson(
        ResponseCodeCollect_LARBEVE instance) =>
    <String, dynamic>{};
