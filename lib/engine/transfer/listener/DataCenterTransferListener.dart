import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteWrapper.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'TransferListener.dart';

class DataCenterTransferListener extends TransferListener {
  @override
  Future<SingleResult<Object?>?> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> listenerResult, String operationId, Object? data) async {
    return await _sqliteCurdByTransaction(listenerResult, operationId, data) ??
        await _sqliteCurd(listenerResult, operationId, data) ??
        await _httpCurd(listenerResult, operationId, data);
  }

  Future<SingleResult<Object?>?> _sqliteCurdByTransaction(SingleResult<Object?> listenerResult, String operationId, Object? data) async {}

  Future<SingleResult<Object?>?> _sqliteCurd(SingleResult<Object?> listenerResult, String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.SQLITE_QUERY_ROW_AS_JSONS:
        return listenerResult.setAnyClone(
          await SqliteCurd.queryRowsAsJsons(
            putQueryWrapper: () => QueryWrapper.fromJson(data!.quickCast()),
            connectTransactionMark: null,
          ),
        );
      case OUniform.SQLITE_INSERT_ROW:
        final Map<String, Object?> dataMap = data!.quickCast();
        return listenerResult.setAnyClone(
          await SqliteCurd.insertRow(
            putModel: () => ModelManager.createEmptyModelByTableName(dataMap['table_name']! as String)..setRowJson = dataMap['model_data']!.quickCast(),
            connectTransactionMark: null,
          ),
        );
      case OUniform.SQLITE_UPDATE_ROW:
        final Map<String, Object?> dataMap = data!.quickCast();
        return listenerResult.setAnyClone(
          await SqliteCurd.updateRow(
            putUpdateWrapper: () => UpdateWrapper(
              modelTableName: dataMap['model_table_name']! as String,
              modelId: dataMap['model_id']! as int,
              updateContent: dataMap['update_content']!.quickCast(),
            ),
            connectTransactionMark: null,
          ),
        );
      case OUniform.SQLITE_DELETE_ROW:
        final Map<String, Object?> dataMap = data!.quickCast();
        return listenerResult.setAnyClone(
          await SqliteCurd.deleteRow(
            putDeleteWrapper: () => DeleteWrapper(
              modelTableName: dataMap['model_table_name']! as String,
              modelId: dataMap['model_id']! as int,
            ),
            connectTransactionMark: null,
          ),
        );
    }
  }

  Future<SingleResult<Object?>?> _httpCurd(SingleResult<Object?> listenerResult, String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.HTTP_CURD:
        final Map<String, Object?> dataMap = data!.quickCast();
        try {
          final HttpStore_Single httpStoreSingle = await HttpCurd.sendRequest(
            httpStore: HttpStore_Single.fromJson(dataMap['putHttpStore']!.quickCast()),
            sameNotConcurrent: dataMap['sameNotConcurrent'] as String?,
            isBanAllOtherRequest: dataMap['isBanAllOtherRequest']! as bool,
          );
          return listenerResult.setSuccess(putData: () => httpStoreSingle);
        } catch (e, st) {
          return listenerResult.setError(vm: '请求异常！', descp: Description(''), e: e, st: st);
        }
    }
  }
}
