// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: implicit_dynamic_parameter

part of 'SqliteWrapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TwoId _$TwoIdFromJson(Map<String, dynamic> json) => TwoId(
      uuidKey: json['uuidKey'] as String,
      uuidValue: json['uuidValue'] as String?,
      aiidKey: json['aiidKey'] as String,
      aiidValue: json['aiidValue'] as int?,
    )
      ..whereByTwoId = json['whereByTwoId'] as String?
      ..whereArgsByTwoId = json['whereArgsByTwoId'] as List<dynamic>?;

Map<String, dynamic> _$TwoIdToJson(TwoId instance) => <String, dynamic>{
      'uuidKey': instance.uuidKey,
      'aiidKey': instance.aiidKey,
      'uuidValue': instance.uuidValue,
      'aiidValue': instance.aiidValue,
      'whereByTwoId': instance.whereByTwoId,
      'whereArgsByTwoId': instance.whereArgsByTwoId,
    };

UpdateWrapper _$UpdateWrapperFromJson(Map<String, dynamic> json) =>
    UpdateWrapper(
      modelTableName: json['modelTableName'] as String,
      modelId: json['modelId'] as int,
      updateContent: json['updateContent'] as Map<String, dynamic>,
    )..curdType = json['curdType'] as String;

Map<String, dynamic> _$UpdateWrapperToJson(UpdateWrapper instance) =>
    <String, dynamic>{
      'curdType': instance.curdType,
      'modelTableName': instance.modelTableName,
      'modelId': instance.modelId,
      'updateContent': instance.updateContent,
    };

QueryWrapper _$QueryWrapperFromJson(Map<String, dynamic> json) => QueryWrapper(
      tableName: json['tableName'] as String,
      distinct: json['distinct'] as bool?,
      columns:
          (json['columns'] as List<dynamic>?)?.map((e) => e as String).toList(),
      where: json['where'] as String?,
      whereArgs: json['whereArgs'] as List<dynamic>?,
      groupBy: json['groupBy'] as String?,
      having: json['having'] as String?,
      orderBy: json['orderBy'] as String?,
      limit: json['limit'] as int?,
      offset: json['offset'] as int?,
      byTwoId: json['byTwoId'] == null
          ? null
          : TwoId.fromJson(json['byTwoId'] as Map<String, dynamic>),
    )..curdType = json['curdType'] as String;

Map<String, dynamic> _$QueryWrapperToJson(QueryWrapper instance) =>
    <String, dynamic>{
      'curdType': instance.curdType,
      'tableName': instance.tableName,
      'distinct': instance.distinct,
      'columns': instance.columns,
      'where': instance.where,
      'whereArgs': instance.whereArgs,
      'groupBy': instance.groupBy,
      'having': instance.having,
      'orderBy': instance.orderBy,
      'limit': instance.limit,
      'offset': instance.offset,
      'byTwoId': instance.byTwoId?.toJson(),
    };

DeleteWrapper _$DeleteWrapperFromJson(Map<String, dynamic> json) =>
    DeleteWrapper(
      modelTableName: json['modelTableName'] as String,
      modelId: json['modelId'] as int?,
    )..curdType = json['curdType'] as String;

Map<String, dynamic> _$DeleteWrapperToJson(DeleteWrapper instance) =>
    <String, dynamic>{
      'curdType': instance.curdType,
      'modelTableName': instance.modelTableName,
      'modelId': instance.modelId,
    };
