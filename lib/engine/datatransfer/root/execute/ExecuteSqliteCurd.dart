import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

/// 向数据中心请求 Sqlite 的 CURD。
class ExecuteSqliteCurd {
  ///

  /// 查看 [SqliteCurd.queryRowsAsJsons]
  Future<SingleResult<List<Map>>> queryRowsAsJsons<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<Map>> queryRowsAsJsonsResult = SingleResult<List<Map>>();
    final SingleResult<List<Map>> result = await DataTransferManager.instance.transfer.execute<Map, List<Map>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_QUERY_ROW_AS_JSONS,
      setOperationData: () => queryWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as List).cast<Map>(),
    );
    await result.handle<void>(
      doSuccess: (List<Map> successResult) async {
        queryRowsAsJsonsResult.setSuccess(setResult: () => successResult);
      },
      doError: (SingleResult<List<Map>> errorResult) async {
        queryRowsAsJsonsResult.setErrorClone(errorResult);
      },
    );
    return queryRowsAsJsonsResult;
  }

  /// 查看 [SqliteCurd.queryRowsAsModels]
  Future<SingleResult<List<T>>> queryRowsAsModels<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<T>> queryRowsAsModelsResult = SingleResult<List<T>>();
    final SingleResult<List<Map>> result = await queryRowsAsJsons(queryWrapper);
    await result.handle<void>(
      doSuccess: (List<Map> successResult) async {
        queryRowsAsModelsResult.setSuccess(setResult: () {
          final List<T> list = <T>[];
          for (final Map item in successResult) {
            list.add(ModelManager.createEmptyModelByTableName<T>(queryWrapper.tableName)..setRowJson = item.cast());
          }
          return list;
        });
      },
      doError: (SingleResult<List<Map>> errorResult) async {
        queryRowsAsModelsResult.setErrorClone(errorResult);
      },
    );
    return queryRowsAsModelsResult;
  }

  /// 查看 [SqliteCurd.insertRow] 注释。
  Future<SingleResult<T>> insertRow<T extends ModelBase>(T insertModel) async {
    final SingleResult<T> insertRowResult = SingleResult<T>();
    final SingleResult<Map> result = await DataTransferManager.instance.transfer.execute<Map, Map>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_INSERT_ROW,
      setOperationData: () => <String, Object?>{
        'table_name': insertModel.tableName,
        'model_data': insertModel.getRowJson,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData as Map,
    );
    await result.handle<void>(
      doSuccess: (Map successResult) async {
        try {
          insertRowResult.setSuccess(setResult: () => ModelManager.createEmptyModelByTableName<T>(insertModel.tableName)..setRowJson = successResult.cast());
        } catch (e, st) {
          insertRowResult.setError(vm: '插入异常！', descp: Description(''), e: e, st: st);
        }
      },
      doError: (SingleResult<Map> errorResult) async {
        insertRowResult.setErrorClone(errorResult);
      },
    );
    return insertRowResult;
  }

  /// 查看 [SqliteCurd.updateRow] 注释。
  Future<SingleResult<T>> updateRow<T extends ModelBase>(
      {required String modelTableName, required int modelId, required Map<String, Object?> updateContent}) async {
    final SingleResult<T> updateRowResult = SingleResult<T>();
    final SingleResult<Map> result = await DataTransferManager.instance.transfer.execute<Map, Map>(
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
      resultDataCast: (Object resultData) => resultData as Map,
    );
    await result.handle<void>(
      doSuccess: (Map successResult) async {
        updateRowResult.setSuccess(setResult: () => ModelManager.createEmptyModelByTableName(modelTableName)..setRowJson = successResult.cast());
      },
      doError: (SingleResult<Map> errorResult) async {
        updateRowResult.setErrorClone(errorResult);
      },
    );
    return updateRowResult;
  }

  /// 查看 [SqliteCurd.deleteRow] 注释
  Future<SingleResult<bool>> deleteRow({required String modelTableName, required int? modelId}) async {
    final SingleResult<bool> deleteRowResult = SingleResult<bool>();
    final SingleResult<bool> result = await DataTransferManager.instance.transfer.execute<Map, bool>(
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
    await result.handle<void>(
      doSuccess: (bool successResult) async {
        if (deleteRowResult.result!) {
          deleteRowResult.setSuccess(setResult: () => deleteRowResult.result!);
        } else {
          deleteRowResult.setError(vm: '删除异常！', descp: Description(''), e: Exception('successResult 不为 true！'), st: null);
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        deleteRowResult.setErrorClone(errorResult);
      },
    );
    return deleteRowResult;
  }
}
