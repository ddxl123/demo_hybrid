// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpStore_verify_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestHeadersVO_VT _$RequestHeadersVO_VTFromJson(Map<String, dynamic> json) =>
    RequestHeadersVO_VT();

Map<String, dynamic> _$RequestHeadersVO_VTToJson(
        RequestHeadersVO_VT instance) =>
    <String, dynamic>{};

RequestParamsVO_VT _$RequestParamsVO_VTFromJson(Map<String, dynamic> json) =>
    RequestParamsVO_VT();

Map<String, dynamic> _$RequestParamsVO_VTToJson(RequestParamsVO_VT instance) =>
    <String, dynamic>{};

RequestDataVO_VT _$RequestDataVO_VTFromJson(Map<String, dynamic> json) =>
    RequestDataVO_VT(
      token: json['token'] as String,
    );

Map<String, dynamic> _$RequestDataVO_VTToJson(RequestDataVO_VT instance) =>
    <String, dynamic>{
      'token': instance.token,
    };

ResponseHeadersVO_VT _$ResponseHeadersVO_VTFromJson(
        Map<String, dynamic> json) =>
    ResponseHeadersVO_VT();

Map<String, dynamic> _$ResponseHeadersVO_VTToJson(
        ResponseHeadersVO_VT instance) =>
    <String, dynamic>{};

ResponseDataVO_VT _$ResponseDataVO_VTFromJson(Map<String, dynamic> json) =>
    ResponseDataVO_VT(
      new_token: json['new_token'] as String,
    );

Map<String, dynamic> _$ResponseDataVO_VTToJson(ResponseDataVO_VT instance) =>
    <String, dynamic>{
      'new_token': instance.new_token,
    };

ResponseCodeCollect_VT _$ResponseCodeCollect_VTFromJson(
        Map<String, dynamic> json) =>
    ResponseCodeCollect_VT()..responseCode = json['responseCode'] as int?;

Map<String, dynamic> _$ResponseCodeCollect_VTToJson(
        ResponseCodeCollect_VT instance) =>
    <String, dynamic>{
      'responseCode': instance.responseCode,
    };
