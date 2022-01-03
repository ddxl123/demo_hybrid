import 'package:hybrid/data/sqlite/sqliter/SqliteCurdWrapper.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';

typedef SqliteCurdTransactionChainFunction = Future<void> Function(SqliteCurdTransactionChain chain);

class SqliteCurdTransactionChain {
  /// 不能被 try 捕获，否则无法中断事务。
  SqliteCurdTransactionChain.createInRequester(SqliteCurdTransactionChainFunction curdRequest) {
    chainId = hashCode.toString();
    requesterEngineEntryName = TransferManager.instance.currentEntryPointName;
    _curdRequestFunction = curdRequest;
    if (TransferManager.instance.sqliteCurdTransactionsInRequester.containsKey(chainId)) {
      throw 'createInRequester chainId 重复';
    }
    TransferManager.instance.sqliteCurdTransactionsInRequester.addAll(
      <String, SqliteCurdTransactionChain>{chainId: this},
    );
  }

  SqliteCurdTransactionChain.createInDataCenter(Map<String, Object?> json, TransactionWrapper transactionWrapper) {
    chainId = json['chainId']! as String;
    requesterEngineEntryName = json['requesterEngineEntryName']! as String;

    if (!TransferManager.instance.sqliteCurdTransactionsInDataCenter.containsKey(chainId)) {
      throw 'createInDataCenter chainId 重复！';
    }
    TransferManager.instance.sqliteCurdTransactionsInDataCenter.addAll(<String, TransactionWrapper>{chainId: transactionWrapper});
  }

  late final String chainId;
  late final String requesterEngineEntryName;

  late final SqliteCurdTransactionChainFunction _curdRequestFunction;

  /// [curd] 异常会在这个函数内部捕获。
  Future<SingleResult<Object?>> executeCurdRequestFunction(SingleResult<Object?> returnResult) async {
    try {
      await _curdRequestFunction(this);
      return returnResult.setSuccess(putData: () => true);
    } catch (e, st) {
      if (e is SingleResult) {
        return returnResult.setErrorClone(e);
      }
      return returnResult.setError(vm: '事务请求异常！', descp: Description(''), e: e, st: st);
    }
  }

  /// 异常会被 [executeCurdRequestFunction] 捕获。
  Future<CW> curd<CW extends CurdWrapper>(CW curdWrapper) async {
    final SingleResult<Object> curdResult = await TransferManager.instance.transferExecutor.executeWithViewAndOperation<Map<String, Object?>, Object>(
      executeForWhichEngine: requesterEngineEntryName,
      startEngineWhenClose: false,
      operationId: OUniform.SQLITE_CURD_TRANSACTION_CURD,
      setOperationData: () => <String, Object?>{
        'chainId': chainId,
        'requesterEngineEntryName': requesterEngineEntryName,
        'curdWrapper': curdWrapper.toJson(),
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData,
    );
    await curdResult.handle<void>(
      doSuccess: (Object successData) async {
        curdWrapper.resultData = successData;
      },
      doError: (SingleResult<Object> errorResult) async {
        throw errorResult;
      },
    );
    return curdWrapper;
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'chainId': chainId,
      'requesterEngineEntryName': requesterEngineEntryName,
    };
  }
}

/// 向数据中心请求 Sqlite 的 CURD。
class SqliteCurdTransferExecutor {
  ///

  /// [requestChain] 内部不能捕获异常，否则事务无法中断。
  Future<SingleResult<bool>> curdTransaction({required SqliteCurdTransactionChainFunction requestChain}) async {
    return await TransferManager.instance.transferExecutor.executeWithViewAndOperation<Map<String, Object?>, bool>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationId: OUniform.SQLITE_CURD_TRANSACTION_CREATE,
      startEngineWhenClose: false,
      setOperationData: () => SqliteCurdTransactionChain.createInRequester(requestChain).toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => resultData as bool,
    );
  }
}
