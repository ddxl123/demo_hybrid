import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/transfer/executor/SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'TransferListener.dart';

class DataCenterTransferListener extends TransferListener {
  @override
  Future<SingleResult<Object?>?> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    return await _sqliteCurdTransaction(returnResult, operationId, operationData) ?? await _httpCurd(returnResult, operationId, operationData);
  }

  Future<SingleResult<Object?>?> _sqliteCurdTransaction(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    switch (operationId) {
      case OUniform.SQLITE_CURD_TRANSACTION:
        final SqliteCurdTransactionQueue queue = SqliteCurdTransactionQueue.createForCutFromJson(operationData!.quickCast());
        for (int i = 0; i < queue.members.length; i++) {
          final String memberId = queue.members.keys.elementAt(i);
          final QueueMember member = queue.members.values.elementAt(i);
          final SingleResult<Object> curdResult = await SqliteCurd.fromCurdWrapperJson(curdWrapper: member.curdWrapper);
          // 逆向请求。
        }
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
