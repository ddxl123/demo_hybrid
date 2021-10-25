// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'HttpStore.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HttpStore_Error _$HttpStore_ErrorFromJson(Map<String, dynamic> json) {
  return HttpStore_Error()
    ..httpRequest =
        HttpRequest.fromJson(json['httpRequest'] as Map<String, dynamic>)
    ..httpResponse =
        HttpResponse.fromJson(json['httpResponse'] as Map<String, dynamic>);
}

Map<String, dynamic> _$HttpStore_ErrorToJson(HttpStore_Error instance) =>
    <String, dynamic>{
      'httpRequest': instance.httpRequest.toJson(),
      'httpResponse': instance.httpResponse.toJson(),
    };

HttpStore_Clone _$HttpStore_CloneFromJson(Map<String, dynamic> json) {
  return HttpStore_Clone()
    ..httpRequest =
        HttpRequest.fromJson(json['httpRequest'] as Map<String, dynamic>)
    ..httpResponse =
        HttpResponse.fromJson(json['httpResponse'] as Map<String, dynamic>);
}

Map<String, dynamic> _$HttpStore_CloneToJson(HttpStore_Clone instance) =>
    <String, dynamic>{
      'httpRequest': instance.httpRequest.toJson(),
      'httpResponse': instance.httpResponse.toJson(),
    };
