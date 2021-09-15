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
    left: json['left'] as int?,
    right: json['right'] as int?,
    top: json['top'] as int?,
    bottom: json['bottom'] as int?,
    isFocus: json['is_focus'] as bool?,
  );
}

Map<String, dynamic> _$ViewParamsToJson(ViewParams instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'left': instance.left,
      'right': instance.right,
      'top': instance.top,
      'bottom': instance.bottom,
      'is_focus': instance.isFocus,
    };
