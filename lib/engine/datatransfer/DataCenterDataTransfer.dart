import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/OExecute.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

class DataCenterDataTransfer extends BaseDataTransfer {
  @override
  Future<Object?> listenerMessageFormOtherFlutterEngine(String operationId, Object? data) async {
    if (operationId == OExecute_FlutterSend.SQLITE_INSERT_ROW) {
      if (data is Map<String, Object?>) {
        final SingleResult<ModelBase> insertRowResult = await SqliteCurd.insertRow(
          model: ModelManager.createEmptyModelByTableName(data['table_name']! as String)..setRowJson = data['model_data']! as Map<String, Object?>,
          transactionMark: null,
        );
        if (!insertRowResult.hasError) {
          return insertRowResult.result!.getRowJson;
        } else {
          SbLogger(
            code: null,
            viewMessage: '插入数据异常！',
            data: data,
            description: Description('insert row 时发生了异常！'),
            exception: insertRowResult.exception,
            stackTrace: insertRowResult.stackTrace,
          );
        }
      } else {
        SbLogger(
          code: null,
          viewMessage: '插入时解析数据异常！',
          data: data,
          description: Description('insert row 时，传来的 data 类型异常：${data.runtimeType}'),
          exception: null,
          stackTrace: null,
        );
      }
    }
  }
}
