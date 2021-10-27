// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpRequest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpRequest<REQVO, REQPVO> _$HttpRequestFromJson<REQVO extends RequestDataVO,
    REQPVO extends RequestParamsVO>(Map<String, dynamic> json) {
  return HttpRequest<REQVO, REQPVO>(
    method: json['method'] as String,
    path: json['path'] as String,
  )
    ..requestHeaders = json['requestHeaders'] as Map<String, dynamic>?
    ..exception = json['exception']
    ..stackTrace =
        const StackTraceConverter().fromJson(json['stackTrace'] as String?);
}

Map<String, dynamic> _$HttpRequestToJson<REQVO extends RequestDataVO,
        REQPVO extends RequestParamsVO>(HttpRequest<REQVO, REQPVO> instance) =>
    <String, dynamic>{
      'method': instance.method,
      'path': instance.path,
      'requestHeaders': instance.requestHeaders,
      'exception': instance.exception,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
    };
