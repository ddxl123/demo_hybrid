// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpResponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpResponse<RESPCCOL, RESPDVO> _$HttpResponseFromJson<
    RESPCCOL extends ResponseCodeCollect,
    RESPDVO extends ResponseDataVO>(Map<String, dynamic> json) {
  return HttpResponse<RESPCCOL, RESPDVO>()
    ..responseHeaders = json['responseHeaders'] as Map<String, dynamic>?
    ..isContinue = json['isContinue'] as bool
    ..code = json['code'] as int?
    ..viewMessage = json['viewMessage'] as String?
    ..description = json['description'] == null
        ? null
        : Description.fromJson(json['description'] as Map<String, dynamic>)
    ..exception = json['exception']
    ..stackTrace =
        const StackTraceConverter().fromJson(json['stackTrace'] as String?);
}

Map<String, dynamic> _$HttpResponseToJson<RESPCCOL extends ResponseCodeCollect,
            RESPDVO extends ResponseDataVO>(
        HttpResponse<RESPCCOL, RESPDVO> instance) =>
    <String, dynamic>{
      'responseHeaders': instance.responseHeaders,
      'isContinue': instance.isContinue,
      'code': instance.code,
      'viewMessage': instance.viewMessage,
      'description': instance.description?.toJson(),
      'exception': instance.exception,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
    };
