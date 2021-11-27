// ignore_for_file: avoid_classes_with_only_static_members
import 'package:hybrid/data/sqlite/mmodel/MUpload.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sqflite/sqflite.dart';

import 'OpenSqlite.dart';

part 'SqliteCurd.g.dart';

enum CurdStatus { C, U, D }

enum UploadStatus { notUploaded, uploading, uploaded }

enum CheckResult {
  ok,

  /// model id 为空，非 aiid/uuid
  modelIdIsNull,

  /// model 不存在。
  modelIsNotExist,

  /// model 的 aiid/uuid 同时存在。
  modelIsTwoIdExist,

  /// model 的 aiid/uuid 都不存在。
  modelIsTwoIdNotExist,

  /// upload model 不存在。
  uploadModelIsNotExist,
}

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

///
///
///
///
///

/// 每次 CURD 都会依赖于事务，因此【上传队列】的每行之间都存在着事务关联。
/// 若要上传到云端，就必须让云端方也遵循相应的事务关联。
///
/// 每次 CURD 都有且仅有一个 [TransactionMark] 对象进行事务连接。
/// 同时，有 [transaction] 则必须同时有 [mark]。
///
/// [mark] 使用时间戳来标记，以便每个 [TransactionMark] 具有唯一性。
///
/// 【上传队列】中所有属于同一事务的行需要做相同标记 [mark]，若重复再次执行，则需覆盖 [mark]。
class TransactionMark {
  TransactionMark(this.transaction) {
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

///
///
///
///
///
/// TODO: 是否会存在同时执行多个 [SqliteCurd] 造成 row 被删除后，再次触发删除，导致总是抛出异常。（对增删改查四方面进行分析）
class SqliteCurd {
  ///

  /// 参数除了 connectTransaction，其他的与 db.query 相同
  static Future<SingleResult<List<Map<String, Object?>>>> queryRowsAsJsons({
    required QueryWrapper queryWrapper,
    required TransactionMark? connectTransactionMark,
  }) async {
    final SingleResult<List<Map<String, Object?>>> returnResult = SingleResult<List<Map<String, Object?>>>();
    Future<void> handle(TransactionMark tm) async {
      final List<Map<String, Object?>> query = await tm.transaction.query(
        queryWrapper.tableName,
        distinct: queryWrapper.distinct,
        columns: queryWrapper.columns,
        where: queryWrapper.where ?? queryWrapper.byTwoId?.whereByTwoId,
        whereArgs: queryWrapper.whereArgs ?? queryWrapper.byTwoId?.whereArgsByTwoId,
        groupBy: queryWrapper.groupBy,
        having: queryWrapper.having,
        orderBy: queryWrapper.orderBy,
        limit: queryWrapper.limit,
        offset: queryWrapper.offset,
      );
      returnResult.setSuccess(setResult: () => query);
    }

    try {
      if (connectTransactionMark != null) {
        await handle(connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(TransactionMark(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      }
      returnResult.setError(vm: '本地查询异常！', descp: Description(''), e: e, st: st);
    }
    return returnResult;
  }

  /// [returnWhere]: 对每个 model 进行格外操作。
  static Future<SingleResult<List<M>>> queryRowsAsModels<M extends ModelBase>({
    required TransactionMark? connectTransactionMark,
    void Function(M model)? returnWhere,
    required QueryWrapper queryWrapper,
  }) async {
    final SingleResult<List<M>> returnResult = SingleResult<List<M>>();
    Future<void> handle(TransactionMark tm) async {
      final SingleResult<List<Map<String, Object?>>> queryRowsAsJsonsResult = await queryRowsAsJsons(
        connectTransactionMark: tm,
        queryWrapper: queryWrapper,
      );
      await queryRowsAsJsonsResult.handle(
        doSuccess: (List<Map<String, Object?>> successResult) async {
          final List<M> models = <M>[];
          for (final Map<String, Object?> row in successResult) {
            final M newModel = ModelManager.createEmptyModelByTableName<M>(queryWrapper.tableName);
            newModel.getRowJson.addAll(row);
            models.add(newModel);
            returnWhere?.call(newModel);
          }
          returnResult.setSuccess(setResult: () => models);
        },
        doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
          throw errorResult.getRequiredE();
        },
      );
    }

    try {
      if (connectTransactionMark != null) {
        await handle(connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(TransactionMark(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地查询异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  /// 查看 [_toInsertRow] 注释。
  ///
  /// 会自动根据 [ModelManager.isLocal] 进行判断是使用原生非原生。
  static Future<SingleResult<T>> insertRow<T extends ModelBase>({
    required T model,
    required TransactionMark? connectTransactionMark,
  }) async {
    final SingleResult<T> returnResult = SingleResult<T>();
    Future<void> handle(TransactionMark tm) async {
      if (ModelManager.isLocal(model.tableName)) {
        // 注意用事务进行插入
        final int rowId = await tm.transaction.insert(model.tableName, model.getRowJson);
        model.getRowJson['id'] = rowId;
      } else {
        await _toInsertRow(model: model, transactionMark: tm);
      }
      returnResult.setSuccess(setResult: () => model);
    }

    try {
      if (connectTransactionMark != null) {
        await handle(connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(TransactionMark(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地插入异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  /// 查看 [_toUpdateRow] 注释。
  ///
  /// 当 [connectTransactionMark] 不为空时，内部的异常会 rethrow。
  ///
  /// 无论 [connectTransactionMark] 是否为空，[onError] 都会接收到内部的异常。
  static Future<SingleResult<T>> updateRow<T extends ModelBase>({
    required String modelTableName,
    required int modelId,
    required Map<String, Object?> updateContent,
    required TransactionMark? connectTransactionMark,
  }) async {
    final SingleResult<T> returnResult = SingleResult<T>();
    Future<void> handle(TransactionMark tm) async {
      if (ModelManager.isLocal(modelTableName)) {
        await tm.transaction.update(modelTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[modelId]);
        final SingleResult<List<T>> queryRowsAsModelsResult = await queryRowsAsModels<T>(
          connectTransactionMark: tm,
          queryWrapper: QueryWrapper(tableName: modelTableName, where: 'id = ?', whereArgs: <Object?>[modelId]),
        );
        await queryRowsAsModelsResult.handle<void>(
          doSuccess: (List<T> successResult) async {
            returnResult.setSuccess(setResult: () => successResult.first);
          },
          doError: (SingleResult<List<T>> errorResult) async {
            throw errorResult.getRequiredE();
          },
        );
      } else {
        final T tur = await _toUpdateRow(modelTableName: modelTableName, modelId: modelId, updateContent: updateContent, connectTransactionMark: tm);
        returnResult.setSuccess(setResult: () => tur);
      }
    }

    try {
      if (connectTransactionMark != null) {
        await handle(connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(TransactionMark(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地更新异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  /// {@macro RSqliteCurd.deleteRow}
  ///
  /// 返回的结果要么为 true，要么为异常，并不存在为 false 的情况。
  ///
  /// 当 [connectTransactionMark] 不为空时，内部的异常始终会 rethrow。
  ///
  /// 无论 [connectTransactionMark] 是否为空，[onError] 都会接收到内部的异常。
  static Future<SingleResult<bool>> deleteRow({
    required String modelTableName,
    required int? modelId,
    required TransactionMark? connectTransactionMark,
  }) async {
    final SingleResult<bool> returnResult = SingleResult<bool>();
    Future<void> handle(TransactionMark tm) async {
      if (ModelManager.isLocal(modelTableName)) {
        final int deleteCount = await tm.transaction.delete(modelTableName, where: 'id = ?', whereArgs: <Object?>[modelId]);
        if (deleteCount != 1) {
          throw '删除数量异常！$deleteCount';
        }
      } else {
        await _toDeleteRow(modelTableName: modelTableName, modelId: modelId, connectTransactionMark: tm);
      }
      returnResult.setSuccess(setResult: () => true);
    }

    try {
      if (connectTransactionMark != null) {
        await handle(connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(TransactionMark(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地删除异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  ///
  ///
  ///
  ///
  ///

  /// 对当前 [model] 执行 [insert] 操作。
  ///
  /// 只有需要在 [MUpload] 中 CURD 的表才能使用 [_toInsertRow]。
  ///
  /// 若插入的 [model] 已存在，则会抛异常。
  ///
  /// 当 { xx:null } 时，插入过程会将值设置成 null; 而 { 不存在 xx } 时，则按照默认值或 null；
  /// 例外： {'id':xx}: 为空或不存在 id 键时，会按照默认方式创建 id ；不为空时，会将该值设置为 id。
  /// 这是 insert 本身的特性。
  ///
  /// - [T]、[model] 要插入的模型。
  ///
  /// - [return] 返回插入的模型（带有插入后 sqlite 生成的 id），未插入前的 [model] 不带有 id。
  /// 要插入的模型与返回的模型是一个对象。
  static Future<T> _toInsertRow<T extends ModelBase>({
    required TransactionMark transactionMark,
    required T model,
  }) async {
    // 插入时只能存在 uuid。
    if (model.get_uuid == null || model.get_aiid != null) {
      throw 'insert uuid/aiid err: ${model.get_uuid}, ${model.get_aiid}';
    }
    // 检查该模型的 uuid 是否已存在。
    final SingleResult<List<Map<String, Object?>>> queryRowsAsJsonsResult = await queryRowsAsJsons(
      connectTransactionMark: transactionMark,
      queryWrapper: QueryWrapper(tableName: model.tableName, where: '${model.uuid} = ?', whereArgs: <Object>[model.get_uuid!]),
    );
    await queryRowsAsJsonsResult.handle<void>(
      doSuccess: (List<Map<String, Object?>> successResult) async {
        if (successResult.isNotEmpty) {
          throw 'The model already exits.';
        }
        // 插入当前 model ，获取并设置 id。
        final int rowId = await transactionMark.transaction.insert(model.tableName, model.getRowJson);
        model.getRowJson['id'] = rowId;

        // 创建 MUpload 模型。
        final MUpload upload = MUpload.createModel(
          id: null,
          aiid: null,
          uuid: null,
          created_at: SbHelper.newTimestamp,
          updated_at: SbHelper.newTimestamp,
          for_table_name: model.tableName,
          for_row_id: rowId,
          for_aiid: null,
          updated_columns: null,
          curd_status: CurdStatus.C.index,
          upload_status: UploadStatus.notUploaded.index,
          mark: transactionMark.mark,
        );
        await transactionMark.transaction.insert(upload.tableName, upload.getRowJson);
      },
      doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
        throw errorResult.getRequiredE();
      },
    );
    return model;
  }

  /// 对 [model] 的 [update] 操作。
  ///
  /// 只有需要在 [MUpload] 中 CURD 的表才能使用 [_toUpdateRow]。
  ///
  /// 当将被 update 的 row 不存在时，会进行 create，这是 update 本身的特性。
  /// 但 [_check] 函数已经让被更新的 row 必然存在，不存在则会抛异常。
  ///
  /// 当 { xx:null } 时，会将数据会覆盖成 null; 而 { 不存在xx } 时，则并不进行覆盖，
  /// 包括 {'id':xx}, 这是 update 本身的特性。
  ///
  /// - [modelTableName] 要更新的模型名称。
  ///
  /// - [modelId] 要更新的模型 id，非 aiid/uuid。
  ///
  /// - [updateContent] 更新的内容。
  ///
  /// - [T]、[return] 返回更新后的 model。
  static Future<T> _toUpdateRow<T extends ModelBase>({
    required String modelTableName,
    required int modelId,
    required Map<String, Object?> updateContent,
    required TransactionMark connectTransactionMark,
  }) async {
    // uploadModel 可空，若不可空不会抛异常，而会做下面的判断。
    MUpload? uploadModel;
    final CheckResult checkResult = await _check<T>(
      modelTableName: modelTableName,
      modelId: modelId,
      connectTransactionMark: connectTransactionMark,
      getModel: (T model) {},
      getUploadModel: (MUpload um) {
        uploadModel = um;
      },
    );
    if (checkResult != CheckResult.ok && checkResult != CheckResult.uploadModelIsNotExist) {
      throw 'update err: $checkResult';
    }

    // 新增的 UpdatedColumns 和原来的 UpdatedColumns 合并
    final List<String> updatedColumns =
        uploadModel == null ? <String>[] : (uploadModel!.get_updated_columns == null ? <String>[] : uploadModel!.get_updated_columns!.split(','));
    final String allUpdatedColumns = <String>{...updateContent.keys, ...updatedColumns}.toList().join(',');

    // 更新 model
    await connectTransactionMark.transaction.update(modelTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[modelId]);

    final SingleResult<List<T>> queryRowsAsModelsResult = await queryRowsAsModels<T>(
      connectTransactionMark: connectTransactionMark,
      queryWrapper: QueryWrapper(tableName: modelTableName, where: 'id = ?', whereArgs: <Object?>[modelId]),
    );

    final T newModel = await queryRowsAsModelsResult.handle<T>(
      doSuccess: (List<T> successResult) async {
        return successResult.first;
      },
      doError: (SingleResult<List<T>> errorResult) async {
        throw errorResult.getRequiredE();
      },
    );

    // R
    if (checkResult == CheckResult.uploadModelIsNotExist) {
      final MUpload mUpload = MUpload.createModel(
        id: null,
        aiid: null,
        uuid: null,
        created_at: SbHelper.newTimestamp,
        updated_at: SbHelper.newTimestamp,
        for_table_name: newModel.tableName,
        for_row_id: newModel.get_id,
        for_aiid: newModel.get_aiid,
        updated_columns: allUpdatedColumns,
        curd_status: CurdStatus.U.index,
        upload_status: UploadStatus.notUploaded.index,
        mark: connectTransactionMark.mark,
      );
      await connectTransactionMark.transaction.insert(mUpload.tableName, mUpload.getRowJson);
    }

    // C U
    // curd_status 都保持不变。
    else if (uploadModel!.get_curd_status == CurdStatus.U.index || uploadModel!.get_curd_status == CurdStatus.C.index) {
      await connectTransactionMark.transaction.update(
        uploadModel!.tableName,
        <String, Object?>{
          uploadModel!.updated_columns: allUpdatedColumns,
          uploadModel!.updated_at: SbHelper.newTimestamp,
          uploadModel!.mark: connectTransactionMark.mark,
        },
        where: '${uploadModel!.id} = ?',
        whereArgs: <Object>[uploadModel!.get_id!],
      );
    } else {
      throw 'update err: ${uploadModel!.get_curd_status}';
    }
    return newModel;
  }

  /// {@template RSqliteCurd.deleteRow}
  ///
  /// 对 [model] 的 [delete] 操作。
  ///
  /// 只有需要在 [MUpload] 中 CURD 的表才能使用 [_toDeleteRow]。
  ///
  /// 当将被 delete 的 row 不存在时，并不会抛异常，这是 delete 本身的特性。
  /// 但 [_check] 函数已经让被删除的 row 必然存在，不存在则会抛异常。
  ///
  /// - [modelTableName] 要删除的模型名称。
  ///
  /// - [modelId] 要删除的模型 id，非 aiid/uuid。
  ///
  /// 要么删除成功，要么删除异常。
  ///
  /// {@endtemplate}
  static Future<void> _toDeleteRow<T extends ModelBase>({
    required String modelTableName,
    required int? modelId,
    required TransactionMark connectTransactionMark,
  }) async {
    // 若为空必然抛异常，因此必然不可空。
    late T model;
    // uploadModel 可空，若不可空不会抛异常，而会做下面的判断。
    MUpload? uploadModel;
    final CheckResult checkResult = await _check(
      modelTableName: modelTableName,
      modelId: modelId,
      connectTransactionMark: connectTransactionMark,
      getModel: (T m) {
        model = m;
      },
      getUploadModel: (MUpload um) {
        uploadModel = um;
      },
    );

    if (checkResult != CheckResult.ok && checkResult != CheckResult.uploadModelIsNotExist) {
      throw 'delete err: $checkResult';
    }

    // 无论 CURD 都需要删除本体
    final int deleteCount = await connectTransactionMark.transaction.delete(modelTableName, where: 'id = ?', whereArgs: <Object?>[modelId]);
    if (deleteCount != 1) {
      throw '删除数量异常！$deleteCount';
    }

    // R
    if (checkResult == CheckResult.uploadModelIsNotExist) {
      final MUpload mUpload = MUpload.createModel(
        id: null,
        aiid: null,
        uuid: null,
        created_at: SbHelper.newTimestamp,
        updated_at: SbHelper.newTimestamp,
        for_table_name: model.tableName,
        for_row_id: model.get_id,
        for_aiid: model.get_aiid,
        updated_columns: null,
        curd_status: CurdStatus.D.index,
        upload_status: UploadStatus.notUploaded.index,
        mark: connectTransactionMark.mark,
      );
      await connectTransactionMark.transaction.insert(mUpload.tableName, mUpload.getRowJson);
    }

    // C
    else if (uploadModel!.get_curd_status == CurdStatus.C.index) {
      // 直接删除
      await connectTransactionMark.transaction.delete(
        uploadModel!.tableName,
        where: '${uploadModel!.id} = ?',
        whereArgs: <Object?>[uploadModel!.get_id],
      );
    }

    // U
    else if (uploadModel!.get_curd_status == CurdStatus.U.index) {
      // 无需设 aiid，因为原本就有。
      await connectTransactionMark.transaction.update(
        uploadModel!.tableName,
        <String, Object?>{
          uploadModel!.curd_status: CurdStatus.D.index,
          uploadModel!.mark: connectTransactionMark.mark,
          uploadModel!.updated_at: SbHelper.newTimestamp,
        },
      );
    }

    //
    else {
      throw 'delete err: ${uploadModel!.get_curd_status.toString()}';
    }

    // 同时删除关联该模型的外表 row。
    await _toDeleteMany<T>(model: model, connectTransactionMark: connectTransactionMark);
  }

  ///
  ///
  ///
  ///
  ///
  /// 当 sqlite 应该存在当前 [model] 时，获取并检验当前 [model] 以及对应的 [MUpload]。
  static Future<CheckResult> _check<T extends ModelBase>({
    required String modelTableName,
    required int? modelId,
    required TransactionMark connectTransactionMark,
    required void Function(T model) getModel,
    required void Function(MUpload uploadModel) getUploadModel,
  }) async {
    if (modelId == null) {
      return CheckResult.modelIdIsNull;
    }

    // 获取要更新的 model
    final SingleResult<List<T>> ofModelResult = await queryRowsAsModels<T>(
      connectTransactionMark: connectTransactionMark,
      queryWrapper: QueryWrapper(tableName: modelTableName, where: 'id = ?', whereArgs: <Object?>[modelId]),
    );

    final List<T> queryResult = await ofModelResult.handle(
      doSuccess: (List<T> successResult) async {
        return successResult;
      },
      doError: (SingleResult<List<T>> errorResult) async {
        throw errorResult.getRequiredE();
      },
    );

    if (queryResult.isEmpty) {
      return CheckResult.modelIsNotExist;
    } else {
      getModel(queryResult.first);
    }
    if (queryResult.first.get_aiid != null && queryResult.first.get_uuid != null) {
      return CheckResult.modelIsTwoIdExist;
    }
    if (queryResult.first.get_aiid == null && queryResult.first.get_uuid == null) {
      return CheckResult.modelIsTwoIdNotExist;
    }

    // ====================================================================================

    // 获取 upload model。
    // 必须新建一个 MUpload 来获取 key，因为变量 uploadModel 还未被赋值。
    final MUpload forKey = MUpload();
    final SingleResult<List<MUpload>> ofUploadModelResult = await queryRowsAsModels<MUpload>(
      connectTransactionMark: connectTransactionMark,
      queryWrapper: QueryWrapper(
        tableName: forKey.tableName,
        where: '${forKey.for_row_id} = ? AND ${forKey.for_table_name} = ?',
        whereArgs: <Object?>[modelId, modelTableName],
      ),
    );
    final CheckResult? checkResult = await ofUploadModelResult.handle<CheckResult?>(
      doSuccess: (List<MUpload> successResult) async {
        if (successResult.isNotEmpty) {
          getUploadModel(successResult.first);
          // 若为 uploading 状态，则需要先判断是否已经 upload 成功，成功则修改成 uploaded 后才能继续。
          if (successResult.first.get_upload_status == UploadStatus.uploading.index) {
            //TODO: 从 mysql 中对照是否 upload 成功过，若成功过则设为 uploaded，若未成功过则进行 upload 后再设为 uploaded
            throw 'TODO...';
          }
        } else {
          return CheckResult.uploadModelIsNotExist;
        }
      },
      doError: (SingleResult<List<MUpload>> errorResult) async {
        throw errorResult.getRequiredE();
      },
    );

    if (checkResult != null) {
      return checkResult;
    }

    return CheckResult.ok;
  }

  ///
  ///
  ///
  ///
  ///

  /// 筛选出需要同时删除的 关联该表的其他表对应的 row。
  static Future<void> _toDeleteMany<T extends ModelBase>({
    required T model,
    required TransactionMark connectTransactionMark,
  }) async {
    // for single
    for (int i = 0; i < model.getDeleteManyForSingle().length; i++) {
      final List<String> fk = model.getDeleteManyForSingle().elementAt(i).split('.');
      if (fk.length != 2) {
        throw 'deleteMany for single err: $fk';
      }
      final String fkTableName = fk.first;
      final String fkColumnName = fk.last + '_id';
      final int fkColumnValue = model.get_id!;

      await _recursionDelete(
        fkTableName: fkTableName,
        fkColumnName: fkColumnName,
        fkColumnValue: fkColumnValue,
        connectTransactionMark: connectTransactionMark,
      );
    }

    // for two
    for (int i = 0; i < model.getDeleteManyForTwo().length; i++) {
      final List<String> fk = model.getDeleteManyForTwo().elementAt(i).split('.');
      if (fk.length != 2) {
        throw 'deleteMany for two err: $fk';
      }
      final String fkTableName = fk.first;
      String fkColumnName = fk.last;
      Object fkColumnValue;
      if (model.get_uuid != null && model.get_aiid == null) {
        fkColumnName += '_uuid';
        fkColumnValue = model.get_uuid!;
        await _recursionDelete(
          fkTableName: fkTableName,
          fkColumnName: fkColumnName,
          fkColumnValue: fkColumnValue,
          connectTransactionMark: connectTransactionMark,
        );
      } else if (model.get_aiid != null && model.get_uuid == null) {
        fkColumnName += '_aiid';
        fkColumnValue = model.get_aiid!;
        await _recursionDelete(
          fkTableName: fkTableName,
          fkColumnName: fkColumnName,
          fkColumnValue: fkColumnValue,
          connectTransactionMark: connectTransactionMark,
        );
      }
    }
  }

  /// 递归删除。
  static Future<void> _recursionDelete({
    required String fkTableName,
    required String fkColumnName,
    required Object fkColumnValue,
    required TransactionMark connectTransactionMark,
  }) async {
    // 查询关联该表的对应 row 模型
    final SingleResult<List<ModelBase>> queryRowsAsModelsResult = await queryRowsAsModels<ModelBase>(
      connectTransactionMark: connectTransactionMark,
      queryWrapper: QueryWrapper(
        tableName: fkTableName,
        where: '$fkColumnName = ?',
        whereArgs: <Object>[fkColumnValue],
      ),
    );
    await queryRowsAsModelsResult.handle(
      doSuccess: (List<ModelBase> successResult) async {
        // 把查询到的进行递归 delete
        for (int i = 0; i < successResult.length; i++) {
          final SingleResult<bool> deleteRowResult = await SqliteCurd.deleteRow(
            modelTableName: successResult[i].tableName,
            modelId: successResult[i].get_id!,
            connectTransactionMark: connectTransactionMark,
          );
          await deleteRowResult.handle(
            doSuccess: (bool successResult) async {
              if (!successResult) {
                throw Exception('result 不为 true！');
              }
            },
            doError: (SingleResult<bool> errorResult) async {
              throw errorResult.getRequiredE();
            },
          );
        }
      },
      doError: (SingleResult<List<ModelBase>> errorResult) async {
        throw errorResult.getRequiredE();
      },
    );
  }
}
