// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'DataTransferManager.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ViewParams _$ViewParamsFromJson(Map<String, dynamic> json) {
  return ViewParams(
    width: json['width'] as int,
    height: json['height'] as int,
    x: json['x'] as int,
    y: json['y'] as int,
    alpha: (json['alpha'] as num).toDouble(),
  );
}

Map<String, dynamic> _$ViewParamsToJson(ViewParams instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'x': instance.x,
      'y': instance.y,
      'alpha': instance.alpha,
    };