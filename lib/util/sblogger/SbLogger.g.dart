// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'SbLogger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Description _$DescriptionFromJson(Map<String, dynamic> json) {
  return Description(
    json['description'] as String,
  )..stackTrace =
      const StackTraceConverter().fromJson(json['stackTrace'] as String?);
}

Map<String, dynamic> _$DescriptionToJson(Description instance) =>
    <String, dynamic>{
      'description': instance.description,
      'stackTrace': const StackTraceConverter().toJson(instance.stackTrace),
    };
