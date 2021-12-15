import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteWrapper.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';

class SqliteCurdByTransactionWrapper {
  SqliteCurdByTransactionWrapper() {
    scbtId = hashCode.toString();
    for (int i = 0; i < 20; i++) {
      if (!DataTransferManager.instance.transferExecutor.executeSqliteCurd.curdByTransactionWrappers.containsKey(scbtId)) {
        DataTransferManager.instance.transferExecutor.executeSqliteCurd.curdByTransactionWrappers
            .addAll(<String, SqliteCurdByTransactionWrapper>{scbtId: this});
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
  final Map<String, SqliteCurdQueueMember> curdQueueMembers = <String, SqliteCurdQueueMember>{};

  /// 向队列中添加成员。
  void addQueueMember(SqliteCurdQueueMember member) {
    member.sqliteCurdByTransactionWrapper = this;
    member.scqId = member.hashCode.toString();
    for (int i = 0; i < 20; i++) {
      if (!curdQueueMembers.containsKey(member.scqId)) {
        curdQueueMembers.addAll(<String, SqliteCurdQueueMember>{member.scqId: member});
        break;
      }
      member.scqId += '1';
    }
  }

  Map<String, Map<String, Object?>> transformToNeedSendMap() {
    final Map<String, Map<String, Object?>> curdQueueMembersJson = <String, Map<String, Object?>>{};
    curdQueueMembers.forEach(
      (String key, SqliteCurdQueueMember value) {
        curdQueueMembersJson.addAll(
          <String, Map<String, Object?>>{
            key: <String, Object?>{
              'type': value.type,
              'wrapper': value.wrapper,
            },
          },
        );
      },
    );
    return <String, Map<String, Object?>>{
      scbtId: <String, Object?>{
        'formWhichEntryPointName': formWhichEntryPointName,
        'curdQueueMembers': curdQueueMembersJson,
      },
    };
  }
}

class SqliteCurdQueueMember {
  SqliteCurdQueueMember({
    required this.type,
    required this.wrapper,
    required this.laterFunction,
  });

  late final SqliteCurdByTransactionWrapper sqliteCurdByTransactionWrapper;

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
class SqliteCurdTransferExecutor {
  ///

  /// 1. 在 data_center 引擎中是存储来自其他引擎的 sqlite curd 操作。
  ///
  /// 2. 在其他引擎中是存储当前引擎的每次 sqlite curd 操作。
  // final Map<String, SqliteCurdByTransactionWrapper> curdByTransactionWrappers = <String, SqliteCurdByTransactionWrapper>{};
  //
  // Future<SingleResult<bool>> executeCurdByTransaction(SqliteCurdByTransactionWrapper wrapper) async {
  //   await DataTransferManager.instance.transferExecutor.execute<Map<String, Map<String, Object?>>, String>(
  //     executeForWhichEngine: EngineEntryName.DATA_CENTER,
  //     operationId: OUniform.NEW_SQLITE_TRANSACTION,
  //     setOperationData: () => wrapper.transformToNeedSendMap(),
  //     startViewParams: null,
  //     endViewParams: null,
  //     closeViewAfterSeconds: null,
  //     resultDataCast: (Object resultData) => resultData as String,
  //   );
  // }

  ///
  ///
  ///
  /// 查看 [SqliteCurd.queryRowsAsJsons]
  Future<SingleResult<List<Map<String, Object?>>>> queryRowsAsJsons<T extends ModelBase>(QueryWrapper putQueryWrapper()) async {
    final SingleResult<List<Map<String, Object?>>> returnResult = SingleResult<List<Map<String, Object?>>>();

    final SingleResult<SingleResult<List<Map<String, Object?>>>> queryResult =
        await DataTransferManager.instance.transferExecutor.execute<Map<String, Object?>, SingleResult<List<Map<String, Object?>>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_QUERY_ROW_AS_JSONS,
      setOperationData: () => putQueryWrapper().toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => SingleResult<List<Map<String, Object?>>>.fromJson(
        resultJson: resultData.quickCast(),
        dataCast: (Object result) => (result as List<Object?>).cast<Map<String, Object?>>(),
      ),
    );

    await queryResult.handle(
      doSuccess: (SingleResult<List<Map<String, Object?>>> querySuccessResult) async {
        await querySuccessResult.handle(
          doSuccess: (List<Map<String, Object?>> successResult) async {
            returnResult.setSuccess(putData: () => successResult);
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

  ///
  ///
  ///
  /// 查看 [queryRowsAsJsons]、[SqliteCurd.queryRowsAsModels]
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
  Future<SingleResult<T>> insertRow<T extends ModelBase>(T putInsertModel()) async {
    final SingleResult<T> returnResult = SingleResult<T>();

    late final T insertModel;
    try {
      insertModel = putInsertModel();
    } catch (e, st) {
      return returnResult.setError(vm: '插入模型异常！', descp: Description(''), e: e, st: st);
    }

    final SingleResult<SingleResult<Map<String, Object?>>> insertResult =
        await DataTransferManager.instance.transferExecutor.execute<Map<String, Object?>, SingleResult<Map<String, Object?>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_INSERT_ROW,
      setOperationData: () => <String, Object?>{
        'table_name': insertModel.tableName,
        'model_data': insertModel.getRowJson,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) =>
          SingleResult<Map<String, Object?>>.fromJson(resultJson: resultData.quickCast(), dataCast: (Object result) => result.quickCast()),
    );

    await insertResult.handle<void>(
      doSuccess: (SingleResult<Map<String, Object?>> insertSuccessResult) async {
        await insertSuccessResult.handle<void>(
          doSuccess: (Map<String, Object?> successResult) async {
            returnResult.setSuccess(putData: () => ModelManager.createEmptyModelByTableName<T>(insertModel.tableName)..setRowJson = successResult);
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

  ///
  ///
  ///
  /// 查看 [SqliteCurd.updateRow] 注释。
  Future<SingleResult<T>> updateRow<T extends ModelBase>({
    required String modelTableName,
    required int modelId,
    required Map<String, Object?> updateContent,
  }) async {
    final SingleResult<T> returnResult = SingleResult<T>();

    final SingleResult<SingleResult<Map<String, Object?>>> updateResult =
        await DataTransferManager.instance.transferExecutor.execute<Map<String, Object?>, SingleResult<Map<String, Object?>>>(
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
      resultDataCast: (Object resultData) =>
          SingleResult<Map<String, Object?>>.fromJson(resultJson: resultData.quickCast(), dataCast: (Object result) => result.quickCast()),
    );

    await updateResult.handle(
      doSuccess: (SingleResult<Map<String, Object?>> updateSuccessResult) async {
        await updateSuccessResult.handle(
          doSuccess: (Map<String, Object?> successResult) async {
            returnResult.setSuccess(putData: () => ModelManager.createEmptyModelByTableName(modelTableName)..setRowJson = successResult);
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
    final SingleResult<SingleResult<bool>> deleteResult = await DataTransferManager.instance.transferExecutor.execute<Map<String, Object?>, SingleResult<bool>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_DELETE_ROW,
      setOperationData: () => <String, Object?>{
        'model_table_name': modelTableName,
        'model_id': modelId,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => SingleResult<bool>.fromJson(resultJson: resultData.quickCast(), dataCast: (Object result) => result as bool),
    );
    await deleteResult.handle<void>(
      doSuccess: (SingleResult<bool> deleteSuccessResult) async {
        await deleteSuccessResult.handle(
          doSuccess: (bool successResult) async {
            if (successResult) {
              returnResult.setSuccess(putData: () => successResult);
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
