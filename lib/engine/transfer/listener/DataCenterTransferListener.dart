import 'package:hybrid/data/mysql/http/HttpCurd.dart';
import 'package:hybrid/data/mysql/httpstore/handler/HttpStore.dart';
import 'package:hybrid/data/sqlite/sqliter/OpenSqlite.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurdBasis.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurdWrapper.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/engine/transfer/executor/SqliteCurdTransferExecutor.dart';
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
      case OUniform.SQLITE_CURD_TRANSACTION_CREATE:
        try {
          await db.transaction<void>(
            (Transaction txn) async {
              final SqliteCurdTransactionChain chain = SqliteCurdTransactionChain.createInDataCenter(operationData!.quickCast(), TransactionWrapper(txn));
              // 主动响应事务创建成功消息。
              final SingleResult<bool> completeResult = await TransferManager.instance.transferExecutor.executeWithViewAndOperation<String, bool>(
                executeForWhichEngine: chain.requesterEngineEntryName,
                startEngineWhenClose: false,
                operationId: OUniform.SQLITE_CURD_TRANSACTION_CREATE_RESULT,
                setOperationData: () => chain.chainId,
                startViewParams: null,
                endViewParams: null,
                closeViewAfterSeconds: null,
                resultDataCast: (Object resultData) => resultData as bool,
              );
              await completeResult.handle<void>(
                doSuccess: (bool successData) async {
                  if (!successData) {
                    throw '结果不为 true';
                  }
                },
                doError: (SingleResult<bool> errorResult) async {
                  throw errorResult;
                },
              );
            },
          );
          return returnResult.setSuccess(putData: () => true);
        } catch (e, st) {
          if (e is SingleResult) {
            return returnResult.setErrorClone(e);
          }
          return returnResult.setError(vm: '事务操作异常，请尝试重启应用！', descp: Description(''), e: e, st: st);
        }
      case OUniform.SQLITE_CURD_TRANSACTION_CURD:
        try {
          final Map<String, Object?> dataMap = operationData!.quickCast();
          final String chainId = dataMap['chainId']! as String;
          final CurdWrapper curdWrapper = CurdWrapper.fromJsonToChildInstance(dataMap['curdWrapper']!.quickCast());
          if (!TransferManager.instance.sqliteCurdTransactionsInDataCenter.containsKey(chainId)) {
            return returnResult.setError(vm: '事务处理异常！', descp: Description(''), e: Exception('事务 curd 时，不存在该 chainId！'), st: null);
          }

          return await SqliteCurdBasis.fromCurdWrapperJson(
            curdWrapper: curdWrapper,
            transactionWrapper: TransferManager.instance.sqliteCurdTransactionsInDataCenter[chainId]!,
          );
        } catch (e, st) {
          return returnResult.setError(vm: '事务处理异常！', descp: Description(''), e: e, st: st);
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
          final HttpStore_Any httpStoreSingle = await HttpCurd.sendRequest(
            httpStore: HttpStore_Any.fromJson(dataMap['putHttpStore']!.quickCast()),
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
