import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../TransferManager.dart';
import 'SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';

/// 向数据中心请求 Sqlite 的 CURD。
class SqliteCurdTransferExecutor {
  ///

  Future<SingleResult<bool>> executeCurdTransaction(SqliteCurdTransactionQueue putWrapper()) async {
    await TransferManager.instance.transferExecutor.executeWithViewAndOperation<Map<String, Map<String, Object?>>, String>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_CURD_TRANSACTION,
      setOperationData: () => putWrapper().toNeedSendJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData as String,
    );
  }
}
