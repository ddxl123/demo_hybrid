
import 'package:hybrid/data/sqlite/mmodel/MUpload.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:sqflite/sqflite.dart';

import 'OpenSqlite.dart';

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
    mark = SbHelper().newTimestamp;
  }

  Transaction transaction;
  late int mark;
}

///
///
///
///
///

// TODO: 是否会存在同时执行多个 [RSqliteCURD] 造成 row 被删除后，再次触发删除，导致总是抛出异常。（对增删改查四方面进行分析）
class SqliteCurd<T extends ModelBase> {
  ///

  /// {@macro RSqliteCurd.insertRow}
  Future<T> insertRow({required T model, required TransactionMark? transactionMark}) async {
    if (transactionMark == null) {
      // 开始事务。
      return await db.transaction<T>(
        (Transaction txn) async {
          return await _toInsertRow(model: model, transactionMark: TransactionMark(txn));
        },
      );
    } else {
      // 继续事务。
      return await _toInsertRow(model: model, transactionMark: transactionMark);
    }
  }

  /// {@macro RSqliteCurd.updateRow}
  Future<T> updateRow({
    required String modelTableName,
    required int? modelId,
    required Map<String, Object?> updateContent,
    required TransactionMark? transactionMark,
  }) async {
    if (transactionMark == null) {
      // 开始事务。
      return await db.transaction<T>(
        (Transaction txn) async {
          return await _toUpdateRow(modelTableName: modelTableName, modelId: modelId, updateContent: updateContent, transactionMark: TransactionMark(txn));
        },
      );
    } else {
      // 继续事务。
      return await _toUpdateRow(modelTableName: modelTableName, modelId: modelId, updateContent: updateContent, transactionMark: transactionMark);
    }
  }

  /// {@macro RSqliteCurd.deleteRow}
  ///
  /// 返回是否删除成功，捕获到异常返回 false
  Future<void> deleteRow({required String modelTableName, required int? modelId, required TransactionMark? transactionMark}) async {
    if (transactionMark == null) {
      // 开始事务。
      await db.transaction<void>(
        (Transaction txn) async {
          await _toDeleteRow(modelTableName: modelTableName, modelId: modelId, transactionMark: TransactionMark(txn));
        },
      );
    } else {
      // 继续事务。
      await _toDeleteRow(modelTableName: modelTableName, modelId: modelId, transactionMark: transactionMark);
    }
  }

  ///
  ///
  ///
  ///
  ///

  /// {@template RSqliteCurd.insertRow}
  ///
  /// 对当前 [model] 执行 [insert] 操作。
  ///
  /// 若插入的 [model] 已存在，则会抛异常。
  ///
  /// 当 { xx:null } 时，插入过程会将值设置成 null; 而 { 不存在 xx } 时，则按照默认值或 null；
  /// 例外： {'id':xx}: 为空或不存在 id 键时，会按照默认方式创建 id ；不为空时，会将该值设置为 id。
  /// 这是 insert 本身的特性。
  ///
  /// - [model] 要插入的模型。
  ///
  /// - [return] 返回插入的模型（带有插入后 sqlite 生成的 id），未插入前的 [model] 不带有 id。
  ///
  /// {@endtemplate}
  Future<T> _toInsertRow({required TransactionMark transactionMark, required T model}) async {
    // 插入时只能存在 uuid。
    if (model.get_uuid == null || model.get_aiid != null) {
      throw 'insert uuid/aiid err: ${model.get_uuid}, ${model.get_aiid}';
    }
    // 检查该模型的 uuid 是否已存在。
    final List<Map<String, Object?>> queryResult = await ModelManager.queryRowsAsJsons(
      tableName: model.tableName,
      where: '${model.uuid} = ?',
      whereArgs: <Object>[model.get_uuid!],
      connectTransaction: transactionMark.transaction,
    );

    if (queryResult.isNotEmpty) {
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
      created_at: SbHelper().newTimestamp,
      updated_at: SbHelper().newTimestamp,
      for_table_name: model.tableName,
      for_row_id: rowId,
      for_aiid: null,
      updated_columns: null,
      curd_status: CurdStatus.C.index,
      upload_status: UploadStatus.notUploaded.index,
      mark: transactionMark.mark,
    );
    await transactionMark.transaction.insert(upload.tableName, upload.getRowJson);
    return model;
  }

  /// {@template RSqliteCurd.updateRow}
  ///
  /// 对 [model] 的 [update] 操作。
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
  /// - [return] 返回 new model。
  ///
  /// {@endtemplate}
  Future<T> _toUpdateRow({
    required String modelTableName,
    required int? modelId,
    required Map<String, Object?> updateContent,
    required TransactionMark transactionMark,
  }) async {
    // uploadModel 可空，若不可空不会抛异常，而会做下面的判断。
    MUpload? uploadModel;
    final CheckResult checkResult = await _check(
      modelTableName: modelTableName,
      modelId: modelId,
      transactionMark: transactionMark,
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
    await transactionMark.transaction.update(modelTableName, updateContent, where: 'id = ?', whereArgs: <Object?>[modelId]);

    final T newModel = (await ModelManager.queryRowsAsModels<T>(
      tableName: modelTableName,
      where: 'id = ?',
      whereArgs: <Object?>[modelId],
      connectTransaction: transactionMark.transaction,
    ))
        .first;

    // R
    if (checkResult == CheckResult.uploadModelIsNotExist) {
      final MUpload mUpload = MUpload.createModel(
        id: null,
        aiid: null,
        uuid: null,
        created_at: SbHelper().newTimestamp,
        updated_at: SbHelper().newTimestamp,
        for_table_name: newModel.tableName,
        for_row_id: newModel.get_id,
        for_aiid: newModel.get_aiid,
        updated_columns: allUpdatedColumns,
        curd_status: CurdStatus.U.index,
        upload_status: UploadStatus.notUploaded.index,
        mark: transactionMark.mark,
      );
      await transactionMark.transaction.insert(mUpload.tableName, mUpload.getRowJson);
    }

    // C U
    // curd_status 都保持不变。
    else if (uploadModel!.get_curd_status == CurdStatus.U.index || uploadModel!.get_curd_status == CurdStatus.C.index) {
      await transactionMark.transaction.update(
        uploadModel!.tableName,
        <String, Object?>{
          uploadModel!.updated_columns: allUpdatedColumns,
          uploadModel!.updated_at: SbHelper().newTimestamp,
          uploadModel!.mark: transactionMark.mark,
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
  /// 当将被 delete 的 row 不存在时，并不会抛异常，这是 delete 本身的特性。
  /// 但 [_check] 函数已经让被删除的 row 必然存在，不存在则会抛异常。
  ///
  /// - [modelTableName] 要删除的模型名称。
  ///
  /// - [modelId] 要删除的模型 id，非 aiid/uuid。
  ///
  /// {@endtemplate}
  Future<void> _toDeleteRow({required String modelTableName, required int? modelId, required TransactionMark transactionMark}) async {
    // 若为空必然抛异常，因此必然不可空。
    late T model;
    // uploadModel 可空，若不可空不会抛异常，而会做下面的判断。
    MUpload? uploadModel;
    final CheckResult checkResult = await _check(
      modelTableName: modelTableName,
      modelId: modelId,
      transactionMark: transactionMark,
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
    await transactionMark.transaction.delete(modelTableName, where: 'id = ?', whereArgs: <Object?>[modelId]);

    // R
    if (checkResult == CheckResult.uploadModelIsNotExist) {
      final MUpload mUpload = MUpload.createModel(
        id: null,
        aiid: null,
        uuid: null,
        created_at: SbHelper().newTimestamp,
        updated_at: SbHelper().newTimestamp,
        for_table_name: model.tableName,
        for_row_id: model.get_id,
        for_aiid: model.get_aiid,
        updated_columns: null,
        curd_status: CurdStatus.D.index,
        upload_status: UploadStatus.notUploaded.index,
        mark: transactionMark.mark,
      );
      await transactionMark.transaction.insert(mUpload.tableName, mUpload.getRowJson);
    }

    // C
    else if (uploadModel!.get_curd_status == CurdStatus.C.index) {
      // 直接删除
      await transactionMark.transaction.delete(
        uploadModel!.tableName,
        where: '${uploadModel!.id} = ?',
        whereArgs: <Object?>[uploadModel!.get_id],
      );
    }

    // U
    else if (uploadModel!.get_curd_status == CurdStatus.U.index) {
      // 无需设 aiid，因为原本就有。
      await transactionMark.transaction.update(
        uploadModel!.tableName,
        <String, Object?>{
          uploadModel!.curd_status: CurdStatus.D.index,
          uploadModel!.mark: transactionMark.mark,
          uploadModel!.updated_at: SbHelper().newTimestamp,
        },
      );
    }

    //
    else {
      throw 'delete err: ${uploadModel!.get_curd_status.toString()}';
    }

    // 同时删除关联该模型的外表 row。
    await _toDeleteMany(model: model, transactionMark: transactionMark);
  }

  ///
  ///
  ///
  ///
  ///
  /// 当 sqlite 应该存在当前 [model] 时，获取并检验当前 [model] 以及对应的 [MUpload]。
  Future<CheckResult> _check({
    required String modelTableName,
    required int? modelId,
    required TransactionMark transactionMark,
    required void Function(T model) getModel,
    required void Function(MUpload uploadModel) getUploadModel,
  }) async {
    if (modelId == null) {
      return CheckResult.modelIdIsNull;
    }

    // 获取要更新的 model
    final List<T> queryResult = await ModelManager.queryRowsAsModels(
      tableName: modelTableName,
      where: 'id = ?',
      whereArgs: <Object?>[modelId],
      connectTransaction: transactionMark.transaction,
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
    final List<MUpload> uploadModels = await ModelManager.queryRowsAsModels<MUpload>(
      tableName: forKey.tableName,
      where: '${forKey.for_row_id} = ? AND ${forKey.for_table_name} = ?',
      whereArgs: <Object?>[modelId, modelTableName],
      connectTransaction: transactionMark.transaction,
    );

    if (uploadModels.isNotEmpty) {
      getUploadModel(uploadModels.first);
      // 若为 uploading 状态，则需要先判断是否已经 upload 成功，成功则修改成 uploaded 后才能继续。
      if (uploadModels.first.get_upload_status == UploadStatus.uploading.index) {
        //TODO: 从 mysql 中对照是否 upload 成功过，若成功过则设为 uploaded，若未成功过则进行 upload 后再设为 uploaded
        throw 'TODO...';
      }
    } else {
      return CheckResult.uploadModelIsNotExist;
    }

    return CheckResult.ok;
  }

  ///
  ///
  ///
  ///
  ///

  /// 筛选出需要同时删除的 关联该表的其他表对应的 row。
  Future<void> _toDeleteMany({required T model, required TransactionMark transactionMark}) async {

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
        transactionMark: transactionMark,
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
          transactionMark: transactionMark,
        );
      } else if (model.get_aiid != null && model.get_uuid == null) {
        fkColumnName += '_aiid';
        fkColumnValue = model.get_aiid!;
        await _recursionDelete(
          fkTableName: fkTableName,
          fkColumnName: fkColumnName,
          fkColumnValue: fkColumnValue,
          transactionMark: transactionMark,
        );
      }
    }
  }

  /// 递归删除。
  Future<void> _recursionDelete({
    required String fkTableName,
    required String fkColumnName,
    required Object fkColumnValue,
    required TransactionMark transactionMark,
  }) async {
    // 查询关联该表的对应 row 模型
    final List<ModelBase> queryResult = await ModelManager.queryRowsAsModels(
      tableName: fkTableName,
      where: '$fkColumnName = ?',
      whereArgs: <Object>[fkColumnValue],
      connectTransaction: transactionMark.transaction,
    );
    // 把查询到的进行递归 delete
    for (int i = 0; i < queryResult.length; i++) {
      await SqliteCurd<ModelBase>().deleteRow(modelTableName: queryResult[i].tableName, modelId: queryResult[i].get_id!, transactionMark: transactionMark);
    }
  }

  ///
}
