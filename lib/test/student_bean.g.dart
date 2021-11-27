// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'student_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      name: json['name'] as String?,
      age: json['age'] as int?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => II.fromJson(e as Map<String, dynamic>))
          .toList(),
      map: json['map'] as Map<String, dynamic>?,
      mapInt: (json['mapInt'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as int),
      ),
      studentBean: json['studentBean'] == null
          ? null
          : Student.fromJson(json['studentBean'] as Map<String, dynamic>),
      ii: json['ii'] == null
          ? null
          : II.fromJson(json['ii'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'name': instance.name,
      'age': instance.age,
      'list': instance.list?.map((e) => e.toJson()).toList(),
      'map': instance.map,
      'mapInt': instance.mapInt,
      'studentBean': instance.studentBean?.toJson(),
      'ii': instance.ii?.toJson(),
    };

II _$IIFromJson(Map<String, dynamic> json) => II(
      i: json['i'] as int,
    );

Map<String, dynamic> _$IIToJson(II instance) => <String, dynamic>{
      'i': instance.i,
    };
