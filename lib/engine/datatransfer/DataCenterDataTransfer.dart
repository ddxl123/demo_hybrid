import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/util/SbHelper.dart';

class DataCenterDataTransfer extends BaseDataTransfer {
  @override
  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data) async {
    return await _sqliteCurd(operationId, data) ?? await _httpCurd(operationId, data);
  }

  Future<Object?> _sqliteCurd(String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.SQLITE_QUERY_ROW_AS_JSONS:
        final Map<String, Object?> dataMap = data! as Map<String, Object?>;
        final SingleResult<List<Map<String, Object?>>> queryResult = await SqliteCurd.queryRowsAsJsons(
          queryWrapper: QueryWrapper.fromJson(dataMap),
          connectTransactionMark: null,
        );
        return await queryResult.handle<List<Map<String, Object?>>>(
          doSuccess: (List<Map<String, Object?>> successResult) async {
            return successResult;
          },
          doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
            //TODO: 这种方式没法获取 description，预采用 exception 内包含 description 的方式。
            throw errorResult.getRequiredE();
          },
        );
      case OUniform.SQLITE_INSERT_ROW:
        final Map dataMap = data! as Map;
        final SingleResult<ModelBase> insertRowResult = await SqliteCurd.insertRow(
          model: ModelManager.createEmptyModelByTableName(dataMap['table_name']! as String)..setRowJson = dataMap['model_data']! as Map<String, Object?>,
          connectTransactionMark: null,
        );
        return await insertRowResult.handle<Map<String, Object?>>(
          doSuccess: (ModelBase successResult) async {
            return successResult.getRowJson;
          },
          doError: (SingleResult<ModelBase> errorResult) async {
            throw errorResult.getRequiredE();
          },
        );
      case OUniform.SQLITE_UPDATE_ROW:
        final Map dataMap = data! as Map;
        final SingleResult<ModelBase> updateRowResult = await SqliteCurd.updateRow(
          modelTableName: dataMap['model_table_name']! as String,
          modelId: dataMap['model_id']! as int,
          updateContent: dataMap['update_content']! as Map<String, Object?>,
          connectTransactionMark: null,
        );
        return await updateRowResult.handle<Map<String, Object?>>(
          doSuccess: (ModelBase successResult) async {
            return successResult.getRowJson;
          },
          doError: (SingleResult<ModelBase> errorResult) async {
            throw errorResult.getRequiredE();
          },
        );
      case OUniform.SQLITE_DELETE_ROW:
        final Map dataMap = data! as Map;
        final SingleResult<bool> deleteRowResult = await SqliteCurd.deleteRow(
          modelTableName: dataMap['model_table_name']! as String,
          modelId: dataMap['model_id']! as int,
          connectTransactionMark: null,
        );
        return await deleteRowResult.handle<bool>(
          doSuccess: (bool successResult) async {
            return successResult;
          },
          doError: (SingleResult<bool> errorResult) async {
            throw errorResult.getRequiredE();
          },
        );
    }
  }

  Future<Object?> _httpCurd(String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.HTTP_CURD:
        final Map dataMap = data! as Map;

        final Map httpStoreJson = dataMap['putHttpStore']! as Map;
        final String? sameNotConcurrent = dataMap['sameNotConcurrent'] as String?;
        final bool isBanAllOtherRequest = dataMap['isBanAllOtherRequest']! as bool;

        return (await HttpCurd.sendRequest(
          httpStore: HttpStore.fromJson(httpStoreJson),
          sameNotConcurrent: sameNotConcurrent,
          isBanAllOtherRequest: isBanAllOtherRequest,
        ))
            .toJson();
    }
  }
}
