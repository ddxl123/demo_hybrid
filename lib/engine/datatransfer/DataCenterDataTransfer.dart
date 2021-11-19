import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
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
        final Map<String, Object?> dataMap = data!.quickCast();
        return (await SqliteCurd.queryRowsAsJsons(
          queryWrapper: QueryWrapper.fromJson(dataMap),
          connectTransactionMark: null,
        ))
            .toJson();
      case OUniform.SQLITE_INSERT_ROW:
        final Map<String, Object?> dataMap = data!.quickCast();
        return (await SqliteCurd.insertRow(
          model: ModelManager.createEmptyModelByTableName(dataMap['table_name']! as String)..setRowJson = dataMap['model_data']!.quickCast(),
          connectTransactionMark: null,
        ))
            .toJson();
      case OUniform.SQLITE_UPDATE_ROW:
        final Map<String, Object?> dataMap = data!.quickCast();
        return (await SqliteCurd.updateRow(
          modelTableName: dataMap['model_table_name']! as String,
          modelId: dataMap['model_id']! as int,
          updateContent: dataMap['update_content']!.quickCast(),
          connectTransactionMark: null,
        ))
            .toJson();
      case OUniform.SQLITE_DELETE_ROW:
        final Map<String, Object?> dataMap = data!.quickCast();
        return (await SqliteCurd.deleteRow(
          modelTableName: dataMap['model_table_name']! as String,
          modelId: dataMap['model_id']! as int,
          connectTransactionMark: null,
        ))
            .toJson();
    }
  }

  Future<Object?> _httpCurd(String operationId, Object? data) async {
    switch (operationId) {
      case OUniform.HTTP_CURD:
        final Map<String, Object?> dataMap = data!.quickCast();
        return (await HttpCurd.sendRequest(
          httpStore: HttpStore_Single.fromJson(dataMap['putHttpStore']!.quickCast()),
          sameNotConcurrent: dataMap['sameNotConcurrent'] as String?,
          isBanAllOtherRequest: dataMap['isBanAllOtherRequest']! as bool,
        ))
            .toJson();
    }
  }
}
