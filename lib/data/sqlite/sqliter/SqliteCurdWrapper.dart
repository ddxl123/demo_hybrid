import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/transfer/executor/SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'SqliteCurdWrapper.g.dart';

// ============================================================================
//
// 事务中可以进行 txn.query，即可以查询到已修改但未提交的事务。
//
// 事务失败的原因是事务内部 throw 异常，因此不能在事务内部进行 try 异常，否则就算 err 也会提交事务。
//
// 需要中途取消事务，则直接在内部 throw 即可。
//
// 事务中每条 sql 语句都必须 await。
//
// ============================================================================

/// 每次 CURD 都会依赖于事务，因此【上传队列】的每行之间都存在着事务关联。
/// 若要上传到云端，就必须让云端方也遵循相应的事务关联。
///
/// 每次 CURD 都有且仅有一个 [TransactionWrapper] 对象进行事务连接。
/// 同时，有 [transaction] 则必须同时有 [mark]。
///
/// [mark] 使用时间戳来标记，以便每个 [TransactionWrapper] 具有唯一性。
///
/// 【上传队列】中所有属于同一事务的行需要做相同标记 [mark]，若重复再次执行，则需覆盖 [mark]。
class TransactionWrapper {
  TransactionWrapper(this.transaction) {
    mark = SbHelper.newTimestamp;
  }

  Transaction transaction;
  late int mark;
}

@JsonSerializable()
class TwoId {
  TwoId({
    required this.uuidKey,
    required this.uuidValue,
    required this.aiidKey,
    required this.aiidValue,
  }) {
    if (aiidValue != null && uuidValue == null) {
      whereByTwoId = '$aiidKey = ?';
      whereArgsByTwoId = <Object?>[aiidValue];
    } else if (aiidValue == null && uuidValue != null) {
      whereByTwoId = '$uuidKey = ?';
      whereArgsByTwoId = <Object>[uuidValue!];
    }
  }

  factory TwoId.fromJson(Map<String, Object?> json) => _$TwoIdFromJson(json);

  Map<String, Object?> toJson() => _$TwoIdToJson(this);

  final String uuidKey;
  final String aiidKey;
  final String? uuidValue;
  final int? aiidValue;

  late final String? whereByTwoId;
  late final List<Object?>? whereArgsByTwoId;
}

abstract class CurdWrapper {
  String curdType = 'UnknownCurdType';

  Map<String, Object?> toJson();

  /// 返回 [CurdWrapper] 类的子类实体。
  static CurdWrapper fromJsonToChildInstance(Map<String, Object?> json) {
    switch (json['curdType']) {
      case 'C':
        return InsertWrapper.fromJson(json);
      case 'U':
        return UpdateWrapper.fromJson(json);
      case 'R':
        return QueryWrapper.fromJson(json);
      case 'D':
        return DeleteWrapper.fromJson(json);
      default:
        throw 'curdType 不匹配：${json['curdType']}';
    }
  }
}

class InsertWrapper<M extends ModelBase> extends CurdWrapper {
  InsertWrapper(this.model) {
    curdType = 'C';
  }

  factory InsertWrapper.fromJson(Map<String, Object?> json) {
    return InsertWrapper<M>(ModelManager.createEmptyModelByTableName<M>(json['modelTableName']! as String)..setRowJson = json['model']!.quickCast())
      ..curdType = json['curdType']! as String;
  }

  @override
  Map<String, Object?> toJson() {
    return <String, Object?>{
      'curdType': curdType,
      'modelTableName': model.tableName,
      'model': model.getRowJson,
    };
  }

  /// 返回值 与 [SqliteCurd.insertRowReturnModel] 返回值的 data 相同。
  ///
  /// 主要从 [QueueMember.result] 中获取。
  static M insertResultFromJson<M extends ModelBase>(String newModelTableName, Map<String, Object?> newModelRowJson) {
    return ModelManager.createEmptyModelByTableName(newModelTableName)..setRowJson = newModelRowJson;
  }

  final M model;
}

@JsonSerializable()
class UpdateWrapper extends CurdWrapper {
  UpdateWrapper({
    required this.modelTableName,
    required this.modelId,
    required this.updateContent,
  }) {
    curdType = 'U';
  }

  factory UpdateWrapper.fromJson(Map<String, Object?> json) => _$UpdateWrapperFromJson(json);

  @override
  Map<String, Object?> toJson() => _$UpdateWrapperToJson(this);

  /// 返回值 与 [SqliteCurd.updateRowReturnModel] 返回值的 data 相同。
  ///
  /// 主要从 [QueueMember.result] 中获取。
  static M updateResultFromJson<M extends ModelBase>(String newModelTableName, Map<String, Object?> newModelRowJson) {
    return ModelManager.createEmptyModelByTableName(newModelTableName)..setRowJson = newModelRowJson;
  }

  final String modelTableName;
  final int modelId;
  final Map<String, Object?> updateContent;
}

@JsonSerializable()
class QueryWrapper<M extends ModelBase> extends CurdWrapper {
  QueryWrapper({
    required this.tableName,
    this.distinct,
    this.columns,
    this.where,
    this.whereArgs,
    this.groupBy,
    this.having,
    this.orderBy,
    this.limit,
    this.offset,
    this.byTwoId,
  }) {
    curdType = 'R';
  }

  factory QueryWrapper.fromJson(Map<String, Object?> json) => _$QueryWrapperFromJson(json);

  @override
  Map<String, Object?> toJson() => _$QueryWrapperToJson(this);

  /// 返回值 与 [SqliteCurd.queryRowsReturnModel] 返回值的 data 相同。
  ///
  /// 主要从 [QueueMember.result] 中获取。
  static List<M> queryResultFromJson<M extends ModelBase>(String newModelTableName, List<Map<String, Object?>> newModelsJson) {
    return newModelsJson.map<M>((Map<String, Object?> e) => (ModelManager.createEmptyModelByTableName(newModelTableName) as M)..setRowJson = e).toList();
  }

  final String tableName;
  final bool? distinct;
  final List<String>? columns;
  final String? where;
  final List<Object?>? whereArgs;
  final String? groupBy;
  final String? having;
  final String? orderBy;
  final int? limit;
  final int? offset;
  final TwoId? byTwoId;
}

@JsonSerializable()
class DeleteWrapper extends CurdWrapper {
  DeleteWrapper({
    required this.modelTableName,
    required this.modelId,
  }) {
    curdType = 'D';
  }

  factory DeleteWrapper.fromJson(Map<String, Object?> json) => _$DeleteWrapperFromJson(json);

  @override
  Map<String, Object?> toJson() => _$DeleteWrapperToJson(this);

  /// 返回值 与 [SqliteCurd.deleteRow] 返回值的 data 相同。
  ///
  /// 主要从 [QueueMember.result] 中获取。
  bool deleteResultFromJson(bool isDeleted) {
    return isDeleted;
  }

  final String modelTableName;
  final int? modelId;
}
