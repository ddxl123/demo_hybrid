import 'package:hybrid/util/SbHelper.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'SqliteWrapper.g.dart';

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

@JsonSerializable()
class QueryWrapper {
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
  });

  factory QueryWrapper.fromJson(Map<String, Object?> json) => _$QueryWrapperFromJson(json);

  Map<String, Object?> toJson() => _$QueryWrapperToJson(this);

  String tableName;
  bool? distinct;
  List<String>? columns;
  String? where;
  List<Object?>? whereArgs;
  String? groupBy;
  String? having;
  String? orderBy;
  int? limit;
  int? offset;
  TwoId? byTwoId;
}

@JsonSerializable()
class UpdateWrapper {
  UpdateWrapper({
    required this.modelTableName,
    required this.modelId,
    required this.updateContent,
  });

  factory UpdateWrapper.fromJson(Map<String, Object?> json) => _$UpdateWrapperFromJson(json);

  Map<String, Object?> toJson() => _$UpdateWrapperToJson(this);

  final String modelTableName;
  final int modelId;
  final Map<String, Object?> updateContent;
}

@JsonSerializable()
class DeleteWrapper {
  DeleteWrapper({
    required this.modelTableName,
    required this.modelId,
  });

  factory DeleteWrapper.fromJson(Map<String, Object?> json) => _$DeleteWrapperFromJson(json);

  Map<String, Object?> toJson() => _$DeleteWrapperToJson(this);

  final String modelTableName;
  final int? modelId;
}
