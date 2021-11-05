import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStoreClone.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class DataCenterDataTransfer extends BaseDataTransfer {
  @override
  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data) async {
    return await _sqliteCurd(operationId, data) ?? await _httpCurd(operationId, data);
  }

  Future<Object?> _sqliteCurd(String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.SQLITE_QUERY_ROW_AS_JSONS:
        final Map<String, Object?> dataMap = (data! as Map<Object?, Object?>).cast<String, Object?>();
        final SingleResult<List<Map<String, Object?>>> queryResult = await SqliteCurd.queryRowsAsJsons(
          queryWrapper: QueryWrapper.fromJson(dataMap),
          connectTransaction: null,
        );
        return await queryResult.handle<List<Map<String, Object?>>>(
          doSuccess: (List<Map<String, Object?>> successResult) async {
            return successResult;
          },
          doError: (Object? exception, StackTrace? stackTrace) async {
            throw exception!;
          },
        );
      case OUniform.SQLITE_INSERT_ROW:
        final Map<String, Object?> dataMap = (data! as Map<Object?, Object?>).cast<String, Object?>();
        final SingleResult<ModelBase> insertRowResult = await SqliteCurd.insertRow(
          model: ModelManager.createEmptyModelByTableName(dataMap['table_name']! as String)..setRowJson = dataMap['model_data']! as Map<String, Object?>,
          transactionMark: null,
        );
        return await insertRowResult.handle<Map<String, Object?>>(
          doSuccess: (ModelBase successResult) async {
            return successResult.getRowJson;
          },
          doError: (Object? exception, StackTrace? stackTrace) async {
            throw exception!;
          },
        );
      case OUniform.SQLITE_UPDATE_ROW:
        final Map<String, Object?> dataMap = (data! as Map<Object?, Object?>).cast<String, Object?>();
        final SingleResult<ModelBase> updateRowResult = await SqliteCurd.updateRow(
          modelTableName: dataMap['model_table_name']! as String,
          modelId: dataMap['model_id']! as int,
          updateContent: dataMap['update_content']! as Map<String, Object?>,
          transactionMark: null,
        );
        return await updateRowResult.handle<Map<String, Object?>>(
          doSuccess: (ModelBase successResult) async {
            return successResult.getRowJson;
          },
          doError: (Object? exception, StackTrace? stackTrace) async {
            throw exception!;
          },
        );
      case OUniform.SQLITE_DELETE_ROW:
        final Map<String, Object?> dataMap = (data! as Map<Object?, Object?>).cast<String, Object?>();
        final SingleResult<bool> deleteRowResult = await SqliteCurd.deleteRow(
          modelTableName: dataMap['model_table_name']! as String,
          modelId: dataMap['model_id']! as int,
          transactionMark: null,
        );
        return await deleteRowResult.handle<bool>(
          doSuccess: (bool successResult) async {
            return successResult;
          },
          doError: (Object? exception, StackTrace? stackTrace) async {
            throw exception!;
          },
        );
    }
  }

  Future<Object?> _httpCurd(String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.HTTP_CURD:
        final Map<String, Object?> dataMap = (data! as Map<Object?, Object?>).cast<String, Object?>();

        final Map<String, Object?> httpStoreJson = (dataMap['putHttpStore']! as Map<Object?, Object?>).cast<String, Object?>();
        final String? sameNotConcurrent = dataMap['sameNotConcurrent'] as String?;
        final bool isBanAllOtherRequest = dataMap['isBanAllOtherRequest']! as bool;

        final HttpStore_Clone requestResult = await HttpCurd.sendRequest<HttpStore_Clone>(
          httpStore: HttpStore_Clone.fromJson(httpStoreJson),
          sameNotConcurrent: sameNotConcurrent,
          isBanAllOtherRequest: isBanAllOtherRequest,
        );
        return requestResult.toJson();
    }
  }
}
