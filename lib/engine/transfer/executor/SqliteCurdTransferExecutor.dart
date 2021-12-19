import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurdWrapper.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';
import 'SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';

/// 向数据中心请求 Sqlite 的 CURD。
class SqliteCurdTransferExecutor {
  ///

  Future<SingleResult<bool>> executeCurdTransaction(SqliteCurdTransactionQueue putWrapper()) async {
    await TransferManager.instance.transferExecutor.executeAndOperation<Map<String, Map<String, Object?>>, String>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_TRANSACTION,
      setOperationData: () => putWrapper().toNeedSendJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData as String,
    );
  }

  ///
  ///
  ///
  /// 查看 [SqliteCurd._queryRowsAsJsons]
  Future<SingleResult<List<Map<String, Object?>>>> queryRowsAsJsons<T extends ModelBase>(QueryWrapper putQueryWrapper()) async {
    final SingleResult<List<Map<String, Object?>>> returnResult = SingleResult<List<Map<String, Object?>>>();

    final SingleResult<List<Map<String, Object?>>> queryResult =
        await TransferManager.instance.transferExecutor.executeAndOperation<Map<String, Object?>, List<Map<String, Object?>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_QUERY_ROW_AS_JSONS,
      setOperationData: () => putQueryWrapper().toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as List<Object?>).cast<Map<String, Object?>>(),
    );

    await queryResult.handle<void>(
      doSuccess: (List<Map<String, Object?>> successData) async {
        returnResult.setSuccess(putData: () => successData);
      },
      doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );

    return returnResult;
  }

  ///
  ///
  ///
  /// 查看 [queryRowsAsJsons]、[SqliteCurd._queryRowsAsModels]
  Future<SingleResult<List<T>>> queryRowsAsModels<T extends ModelBase>(QueryWrapper putQueryWrapper()) async {
    final SingleResult<List<T>> returnResult = SingleResult<List<T>>();

    late final QueryWrapper queryWrapper;
    try {
      queryWrapper = putQueryWrapper();
    } catch (e, st) {
      return returnResult.setError(vm: '查询包装器异常！', descp: Description(''), e: e, st: st);
    }

    await (await queryRowsAsJsons(() => queryWrapper)).handle<void>(
      doSuccess: (List<Map<String, Object?>> successResult) async {
        returnResult.setSuccess(
          putData: () {
            final List<T> list = <T>[];
            for (final Map<String, Object?> item in successResult) {
              list.add(ModelManager.createEmptyModelByTableName<T>(queryWrapper.tableName)..setRowJson = item);
            }
            return list;
          },
        );
      },
      doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  ///
  ///
  ///
  /// 查看 [SqliteCurd.insertRow] 注释。
  Future<SingleResult<T>> insertRow<T extends ModelBase>(InsertWrapper<T> putInsertWrapper()) async {
    final SingleResult<T> returnResult = SingleResult<T>();

    late final InsertWrapper<T> insertWrapper;
    try {
      insertWrapper = putInsertWrapper();
    } catch (e, st) {
      return returnResult.setError(vm: '插入模型异常！', descp: Description(''), e: e, st: st);
    }

    final SingleResult<Map<String, Object?>> insertResult =
        await TransferManager.instance.transferExecutor.executeAndOperation<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_INSERT_ROW,
      setOperationData: () => insertWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData.quickCast(),
    );

    await insertResult.handle<void>(
      doSuccess: (Map<String, Object?> successResult) async {
        returnResult.setSuccess(putData: () => ModelManager.createEmptyModelByTableName<T>(insertWrapper.model.tableName)..setRowJson = successResult);
      },
      doError: (SingleResult<Map<String, Object?>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  ///
  ///
  ///
  /// 查看 [SqliteCurd.updateRow] 注释。
  Future<SingleResult<T>> updateRow<T extends ModelBase>(UpdateWrapper putUpdateWrapper()) async {
    final SingleResult<T> returnResult = SingleResult<T>();

    late final UpdateWrapper updateWrapper;
    try {
      updateWrapper = putUpdateWrapper();
    } catch (e, st) {
      return returnResult.setError(vm: '修改模型异常！', descp: Description(''), e: e, st: st);
    }

    final SingleResult<Map<String, Object?>> updateResult =
        await TransferManager.instance.transferExecutor.executeAndOperation<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_UPDATE_ROW,
      setOperationData: () => updateWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData.quickCast(),
    );

    await updateResult.handle(
      doSuccess: (Map<String, Object?> successResult) async {
        returnResult.setSuccess(putData: () => ModelManager.createEmptyModelByTableName(updateWrapper.modelTableName)..setRowJson = successResult);
      },
      doError: (SingleResult<Map<String, Object?>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  /// 查看 [SqliteCurd.deleteRow] 注释
  Future<SingleResult<bool>> deleteRow(DeleteWrapper putDeleteWrapper()) async {
    final SingleResult<bool> returnResult = SingleResult<bool>();

    late final DeleteWrapper deleteWrapper;
    try {
      deleteWrapper = putDeleteWrapper();
    } catch (e, st) {
      return returnResult.setError(vm: '删除模型异常！', descp: Description(''), e: e, st: st);
    }

    final SingleResult<bool> deleteResult = await TransferManager.instance.transferExecutor.executeAndOperation<Map<String, Object?>, bool>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_DELETE_ROW,
      setOperationData: () => deleteWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData as bool,
    );
    await deleteResult.handle<void>(
      doSuccess: (bool successResult) async {
        returnResult.setSuccess(putData: () => successResult);
      },
      doError: (SingleResult<bool> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }
}
