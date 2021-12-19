import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteTool.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurdWrapper.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/transfer/executor/SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'TransferListener.dart';

class DataCenterTransferListener extends TransferListener {
  @override
  Future<SingleResult<Object?>?> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    return await _sqliteCurdByTransaction(returnResult, operationId, operationData) ??
        await _sqliteCurd(returnResult, operationId, operationData) ??
        await _httpCurd(returnResult, operationId, operationData);
  }

  Future<SingleResult<Object?>?> _sqliteCurdByTransaction(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    switch (operationId) {
      case OUniform.SQLITE_TRANSACTION:
        final SqliteCurdTransactionQueue queue = SqliteCurdTransactionQueue.createForCutFromJson(operationData!.quickCast());
        queue.members.forEach(
              (String memberId, QueueMember member) {
            final CurdWrapper curdWrapper = CurdWrapper.byCurdTypeFromJson(member.curdWrapper.toJson());
            SqliteCurd.insertRow(putModel: putModel, connectTransactionMark: connectTransactionMark)
          },
        );
    }
  }

  Future<SingleResult<Object?>?> _sqliteCurd(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    switch (operationId) {
      case OUniform.SQLITE_QUERY_ROW_AS_JSONS:
        return returnResult.setAnyClone(
          await SqliteCurd.queryRowsReturnJson(
            putQueryWrapper: () => QueryWrapper.fromJson(operationData!.quickCast()),
            connectTransactionMark: null,
          ),
        );
      case OUniform.SQLITE_INSERT_ROW:
        final Map<String, Object?> dataMap = operationData!.quickCast();
        return returnResult.setAnyClone(
          await SqliteCurd.insertRowReturnJson(
            putInsertWrapper: () =>
                InsertWrapper(ModelManager.createEmptyModelByTableName(dataMap['table_name']! as String)
                  ..setRowJson = dataMap['model_data']!.quickCast(),),
            connectTransactionMark: null,
          ),
        );
      case OUniform.SQLITE_UPDATE_ROW:
        final Map<String, Object?> dataMap = operationData!.quickCast();
        return returnResult.setAnyClone(
          await SqliteCurd.updateRow(
            putUpdateWrapper: () =>
                UpdateWrapper(
                  modelTableName: dataMap['model_table_name']! as String,
                  modelId: dataMap['model_id']! as int,
                  updateContent: dataMap['update_content']!.quickCast(),
                ),
            connectTransactionMark: null,
          ),
        );
      case OUniform.SQLITE_DELETE_ROW:
        final Map<String, Object?> dataMap = operationData!.quickCast();
        return returnResult.setAnyClone(
          await SqliteCurd.deleteRow(
            putDeleteWrapper: () =>
                DeleteWrapper(
                  modelTableName: dataMap['model_table_name']! as String,
                  modelId: dataMap['model_id']! as int,
                ),
            connectTransactionMark: null,
          ),
        );
    }
  }

  Future<SingleResult<Object?>?> _httpCurd(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    switch (operationId) {
      case OUniform.HTTP_CURD:
        final Map<String, Object?> dataMap = operationData!.quickCast();
        try {
          final HttpStore_Single httpStoreSingle = await HttpCurd.sendRequest(
            httpStore: HttpStore_Single.fromJson(dataMap['putHttpStore']!.quickCast()),
            sameNotConcurrent: dataMap['sameNotConcurrent'] as String?,
            isBanAllOtherRequest: dataMap['isBanAllOtherRequest']! as bool,
          );
          return returnResult.setSuccess(putData: () => httpStoreSingle);
        } catch (e, st) {
          return returnResult.setError(vm: '请求异常！', descp: Description(''), e: e, st: st);
        }
    }
  }
}
