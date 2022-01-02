import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurdWrapper.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/engine/transfer/executor/SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:sqflite_common/sqlite_api.dart';

import 'TransferListener.dart';

class DataCenterTransferListener extends TransferListener {
  @override
  Future<SingleResult<Object?>> listenerMessageFormOtherFlutterEngine(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    await _sqliteCurdTransaction(returnResult, operationId, operationData);
    await _httpCurd(returnResult, operationId, operationData);
    return returnResult;
  }

  Future<SingleResult<Object?>> _sqliteCurdTransaction(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
    switch (operationId) {
      case OUniform.SQLITE_CURD_TRANSACTION:
        // 响应 true 表示成功，否则异常。
        final SqliteCurdTransactionQueue queue = SqliteCurdTransactionQueue.createRootInDataCenter(operationData!.quickCast());
        try {
          await db.transaction<void>(
            (Transaction txn) async {
              final TransactionWrapper transactionWrapper = TransactionWrapper(txn);

              for (int i = 0; i < queue.members.length; i++) {
                final QueueMember member = queue.members.values.elementAt(i);
                final SingleResult<Object> curdResult = await SqliteCurd.fromCurdWrapperJson(
                  curdWrapper: member.curdWrapper,
                  transactionWrapper: transactionWrapper,
                );
                final bool isContinueForEach = await curdResult.handle<bool>(
                  doSuccess: (Object successData) async {
                    // 逆向请求。
                    final SingleResult<bool> reverseResult =
                        await TransferManager.instance.transferExecutor.executeWithViewAndOperation<Map<String, Object?>, bool>(
                      executeForWhichEngine: member.queue.fromWhichEntryPoint,
                      startEngineWhenClose: false,
                      operationId: OUniform.SQLITE_CURD_TRANSACTION_REVERSE,
                      setOperationData: () => SqliteCurdTransactionQueue.parseReverseRequestInDataCenter(queue.queueId, member.memberId, successData),
                      startViewParams: null,
                      endViewParams: null,
                      closeViewAfterSeconds: null,
                      resultDataCast: (Object resultData) => resultData as bool,
                    );
                    return await reverseResult.handle<bool>(
                      doSuccess: (bool successData) async {
                        if (successData) {
                          // 继续 for 循环执行下一个成员。
                          return true;
                        }
                        throw '逆向请求响应结果不为 true！';
                      },
                      doError: (SingleResult<bool> errorResult) async {
                        returnResult.setErrorClone(errorResult);
                        return false;
                      },
                    );
                  },
                  doError: (SingleResult<Object> errorResult) async {
                    returnResult.setErrorClone(errorResult);
                    return false;
                  },
                );

                if (!isContinueForEach) {
                  throw returnResult;
                }
              }
            },
          );
          return returnResult.setSuccess(putData: () => true);
        } catch (e, st) {
          if (e is! SingleResult) {
            return returnResult.setError(vm: '事务未知异常！', descp: Description(''), e: e, st: st);
          }
          return returnResult;
        }
      default:
        return returnResult;
    }
  }

  Future<SingleResult<Object?>> _httpCurd(SingleResult<Object?> returnResult, String operationId, Object? operationData) async {
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
      default:
        return returnResult;
    }
  }
}
