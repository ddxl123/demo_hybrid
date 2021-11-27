import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class SqliteCurdByTransactionWrapper {
  SqliteCurdByTransactionWrapper() {
    scbtId = hashCode.toString();
    for (int i = 0; i < 20; i++) {
      if (!DataTransferManager.instance.transferTool.executeSqliteCurd.curdByTransactionWrappers.containsKey(scbtId)) {
        DataTransferManager.instance.transferTool.executeSqliteCurd.curdByTransactionWrappers.addAll(<String, SqliteCurdByTransactionWrapper>{scbtId: this});
        break;
      }
      scbtId += '1';
    }
  }

  /// 传
  /// 便于快速查找该对象。
  late final String scbtId;

  /// 传
  /// 来自哪个引擎入口。
  final String formWhichEntryPointName = DataTransferManager.instance.currentEntryPointName;

  /// curd 队列。
  final Map<String, SqliteCurdQueueMember> curdQueueMember = <String, SqliteCurdQueueMember>{};

  /// 向队列中添加成员。
  void addQueueMember(SqliteCurdQueueMember member) {
    member.sqliteCurdByTransaction = this;
    member.scqId = member.hashCode.toString();
    for (int i = 0; i < 20; i++) {
      if (!curdQueueMember.containsKey(member.scqId)) {
        curdQueueMember.addAll(<String, SqliteCurdQueueMember>{member.scqId: member});
        break;
      }
      member.scqId += '1';
    }
  }
}

class SqliteCurdQueueMember {
  SqliteCurdQueueMember({
    required this.type,
    required this.wrapper,
    required this.laterFunction,
  });

  late final SqliteCurdByTransactionWrapper sqliteCurdByTransaction;

  /// 传
  /// 便于快速查找该对象。
  late final String scqId;

  /// 传
  /// curd 类型：C U R D。
  late final String type;

  /// 传
  /// curd 的包装：QueryWrapper 等。
  late final Map<String, Object?> wrapper;

  /// 不传
  /// curd 后要执行的函数。
  late final Function laterFunction;

  /// 不传
  /// curd 后获取到的 result。
  late final Object? result;
}

/// 向数据中心请求 Sqlite 的 CURD。
class ExecuteSqliteCurd {
  ///

  /// 1. 在 data_center 引擎中是存储来自其他引擎的 sqlite curd 操作。
  ///
  /// 2. 在其他引擎中是存储当前引擎的每次 sqlite curd 操作。
  final Map<String, SqliteCurdByTransactionWrapper> curdByTransactionWrappers = <String, SqliteCurdByTransactionWrapper>{};

  Future<SingleResult<bool>> executeCurdByTransaction(SqliteCurdByTransactionWrapper wrapper) async {
    await DataTransferManager.instance.transferTool.execute<Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.NEW_SQLITE_TRANSACTION,
      setOperationData: () => <String, Object?>{},
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: null,
    );
  }

  /// 查看 [SqliteCurd.queryRowsAsJsons]
  Future<SingleResult<List<Map<String, Object?>>>> queryRowsAsJsons<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<Map<String, Object?>>> returnResult = SingleResult<List<Map<String, Object?>>>();
    final SingleResult<SingleResult<List<Map<String, Object?>>>> queryResult =
        await DataTransferManager.instance.transferTool.execute<Map<String, Object?>, SingleResult<List<Map<String, Object?>>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_QUERY_ROW_AS_JSONS,
      setOperationData: () => queryWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => SingleResult<List<Map<String, Object?>>>.fromJson(resultData.quickCast()),
    );
    await queryResult.handle(
      doSuccess: (SingleResult<List<Map<String, Object?>>> querySuccessResult) async {
        await querySuccessResult.handle(
          doSuccess: (List<Map<String, Object?>> successResult) async {
            returnResult.setSuccess(setResult: () => successResult);
          },
          doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
            returnResult.setErrorClone(errorResult);
          },
        );
      },
      doError: (SingleResult<SingleResult<List<Object?>>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  /// 查看 [SqliteCurd.queryRowsAsModels]
  Future<SingleResult<List<T>>> queryRowsAsModels<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<T>> returnResult = SingleResult<List<T>>();
    final SingleResult<List<Map<String, Object?>>> queryResult = await queryRowsAsJsons(queryWrapper);
    await queryResult.handle<void>(
      doSuccess: (List<Map<String, Object?>> successResult) async {
        returnResult.setSuccess(
          setResult: () {
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

  /// 查看 [SqliteCurd.insertRow] 注释。
  Future<SingleResult<T>> insertRow<T extends ModelBase>(T insertModel) async {
    final SingleResult<T> returnResult = SingleResult<T>();
    final SingleResult<SingleResult<Map<String, Object?>>> insertResult =
        await DataTransferManager.instance.transferTool.execute<Map<String, Object?>, SingleResult<Map<String, Object?>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_INSERT_ROW,
      setOperationData: () => <String, Object?>{
        'table_name': insertModel.tableName,
        'model_data': insertModel.getRowJson,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => SingleResult<Map<String, Object?>>.fromJson(resultData.quickCast()),
    );
    await insertResult.handle<void>(
      doSuccess: (SingleResult<Map<String, Object?>> insertSuccessResult) async {
        await insertSuccessResult.handle<void>(
          doSuccess: (Map<String, Object?> successResult) async {
            returnResult.setSuccess(setResult: () => ModelManager.createEmptyModelByTableName<T>(insertModel.tableName)..setRowJson = successResult);
          },
          doError: (SingleResult<Map<String, Object?>> errorResult) async {
            returnResult.setErrorClone(errorResult);
          },
        );
      },
      doError: (SingleResult<SingleResult<Map<String, Object?>>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  /// 查看 [SqliteCurd.updateRow] 注释。
  Future<SingleResult<T>> updateRow<T extends ModelBase>(
      {required String modelTableName, required int modelId, required Map<String, Object?> updateContent}) async {
    final SingleResult<T> returnResult = SingleResult<T>();
    final SingleResult<SingleResult<Map<String, Object?>>> updateResult =
        await DataTransferManager.instance.transferTool.execute<Map<String, Object?>, SingleResult<Map<String, Object?>>>(
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
      resultDataCast: (Object resultData) => SingleResult<Map<String, Object?>>.fromJson(resultData.quickCast()),
    );
    await updateResult.handle(
      doSuccess: (SingleResult<Map<String, Object?>> updateSuccessResult) async {
        await updateSuccessResult.handle(
          doSuccess: (Map<String, Object?> successResult) async {
            returnResult.setSuccess(setResult: () => ModelManager.createEmptyModelByTableName(modelTableName)..setRowJson = successResult);
          },
          doError: (SingleResult<Map<String, Object?>> errorResult) async {
            returnResult.setErrorClone(errorResult);
          },
        );
      },
      doError: (SingleResult<SingleResult<Map<String, Object?>>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  /// 查看 [SqliteCurd.deleteRow] 注释
  Future<SingleResult<bool>> deleteRow({required String modelTableName, required int? modelId}) async {
    final SingleResult<bool> returnResult = SingleResult<bool>();
    final SingleResult<SingleResult<bool>> deleteResult = await DataTransferManager.instance.transferTool.execute<Map<String, Object?>, SingleResult<bool>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_DELETE_ROW,
      setOperationData: () => <String, Object?>{
        'model_table_name': modelTableName,
        'model_id': modelId,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => SingleResult<bool>.fromJson(resultData.quickCast()),
    );
    await deleteResult.handle<void>(
      doSuccess: (SingleResult<bool> deleteSuccessResult) async {
        await deleteSuccessResult.handle(
          doSuccess: (bool successResult) async {
            if (successResult) {
              returnResult.setSuccess(setResult: () => successResult);
            } else {
              returnResult.setError(vm: '删除异常！', descp: Description(''), e: Exception('successResult 不为 true！'), st: null);
            }
          },
          doError: (SingleResult<bool> errorResult) async {
            returnResult.setErrorClone(errorResult);
          },
        );
      },
      doError: (SingleResult<SingleResult<bool>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }
}
