import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';

/// 向数据中心请求 Sqlite 的 CURD。
class ExecuteSqliteCurd {
  ///

  /// 查看 [SqliteCurd.queryRowsAsJsons]
  Future<SingleResult<List<Map<String, Object?>>>> queryRowsAsJsons<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<Map<String, Object?>>> queryRowResult =
        await DataTransferManager.instance.transfer.execute<Map<String, Object?>, List<Map<String, Object?>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_QUERY_ROW_AS_JSONS,
      setOperationData: () => queryWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as List<Object?>).cast<Map<String, Object?>>(),
    );
    return await queryRowResult.handle<SingleResult<List<Map<String, Object?>>>>(
      doSuccess: (List<Map<String, Object?>> successResult) async {
        return await SingleResult<List<Map<String, Object?>>>.empty().setSuccess(setResult: () async => successResult.cast<Map<String, Object?>>());
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        return SingleResult<List<Map<String, Object?>>>.empty().setError(e: exception, st: stackTrace);
      },
    );
  }

  /// 查看 [SqliteCurd.queryRowsAsModels]
  Future<SingleResult<List<T>>> queryRowsAsModels<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<Map<String, Object?>>> queryRowResult = await queryRowsAsJsons(queryWrapper);
    return await queryRowResult.handle<SingleResult<List<T>>>(
      doSuccess: (List<Map<String, Object?>> successResult) async {
        return await SingleResult<List<T>>.empty().setSuccess(
          setResult: () async {
            final List<T> list = <T>[];
            for (final Map<String, Object?> item in successResult) {
              list.add(ModelManager.createEmptyModelByTableName<T>(queryWrapper.tableName)..setRowJson = item);
            }
            return list;
          },
        );
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        return SingleResult<List<T>>.empty().setError(e: exception, st: stackTrace);
      },
    );
  }

  /// 查看 [SqliteCurd.insertRow] 注释。
  Future<SingleResult<T>> insertRow<T extends ModelBase>(T insertModel) async {
    final SingleResult<Map<String, Object?>> insertRowResult = await DataTransferManager.instance.transfer.execute<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_INSERT_ROW,
      setOperationData: () => <String, Object?>{
        'table_name': insertModel.tableName,
        'model_data': insertModel.getRowJson,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as Map<Object?, Object?>).cast<String, Object?>(),
    );
    return await insertRowResult.handle<SingleResult<T>>(
      doSuccess: (Map<String, Object?> successResult) async {
        try {
          return await SingleResult<T>.empty().setSuccess(
            setResult: () async => ModelManager.createEmptyModelByTableName<T>(insertModel.tableName)..setRowJson = successResult,
          );
        } catch (e, st) {
          return SingleResult<T>.empty().setError(e: e, st: st);
        }
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        return SingleResult<T>.empty().setError(e: exception, st: stackTrace);
      },
    );
  }

  /// 查看 [SqliteCurd.updateRow] 注释。
  Future<SingleResult<T>> updateRow<T extends ModelBase>({
    required String modelTableName,
    required int modelId,
    required Map<String, Object?> updateContent,
  }) async {
    final SingleResult<Map<String, Object?>> updateRowResult = await DataTransferManager.instance.transfer.execute<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_UPDATE_ROW,
      setOperationData: () => <String, Object?>{
        'model_table_name': modelTableName,
        'model_id': modelId,
        'update_content': updateContent,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as Map<Object?, Object?>).cast<String, Object?>(),
    );
    return await updateRowResult.handle<SingleResult<T>>(
      doSuccess: (Map<String, Object?> successResult) async {
        return SingleResult<T>.empty().setSuccess(
          setResult: () async => ModelManager.createEmptyModelByTableName(modelTableName)..setRowJson = successResult,
        );
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        return SingleResult<T>.empty().setError(e: exception, st: stackTrace);
      },
    );
  }

  /// 查看 [SqliteCurd.deleteRow] 注释
  Future<SingleResult<bool>> deleteRow({
    required String modelTableName,
    required int? modelId,
  }) async {
    final SingleResult<bool> deleteRowResult = await DataTransferManager.instance.transfer.execute<Map<String, Object?>, bool>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_DELETE_ROW,
      setOperationData: () => <String, Object?>{
        'model_table_name': modelTableName,
        'model_id': modelId,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: null,
    );
    return await deleteRowResult.handle<SingleResult<bool>>(
      doSuccess: (bool successResult) async {
        if (deleteRowResult.result!) {
          return SingleResult<bool>.empty().setSuccess(setResult: () async => deleteRowResult.result!);
        } else {
          return SingleResult<bool>.empty().setError(e: Exception('result 不为 true！'), st: null);
        }
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        return SingleResult<bool>.empty().setError(e: deleteRowResult.exception, st: deleteRowResult.stackTrace);
      },
    );
  }
}
