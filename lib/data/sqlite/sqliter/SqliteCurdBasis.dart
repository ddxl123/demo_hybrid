// ignore_for_file: avoid_classes_with_only_static_members

import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import 'SqliteCurdDetail.dart';
import 'SqliteCurdObtainModel.dart';
import 'SqliteCurdWrapper.dart';

class SqliteCurdBasis {
  ///

  /// 只需要 [CurdWrapper] 即可获取 [SqliteCurdBasis] 结果。
  static Future<SingleResult<Object>> fromCurdWrapperJson({required CurdWrapper curdWrapper, required TransactionWrapper transactionWrapper}) async {
    final SingleResult<Object> returnResult = SingleResult<Object>();

    try {
      switch (curdWrapper.curdType) {
        case 'C':
          returnResult
              .setCompleteClone(await insertRowReturnJson(putInsertWrapper: () => curdWrapper as InsertWrapper, transactionWrapper: transactionWrapper));
          break;
        case 'U':
          returnResult
              .setCompleteClone(await updateRowReturnJson(putUpdateWrapper: () => curdWrapper as UpdateWrapper, transactionWrapper: transactionWrapper));
          break;
        case 'R':
          returnResult.setCompleteClone(await queryRowsReturnJson(putQueryWrapper: () => curdWrapper as QueryWrapper, transactionWrapper: transactionWrapper));
          break;
        case 'D':
          returnResult.setCompleteClone(await deleteRow(putDeleteWrapper: () => curdWrapper as DeleteWrapper, transactionWrapper: transactionWrapper));
          break;
        default:
          throw '未知 curdType！';
      }
    } catch (e, st) {
      returnResult.setError(vm: '动态数据操作异常！', descp: Description(''), e: e, st: st);
    }
    return returnResult;
  }

  ///
  ///
  ///
  ///
  /// C
  ///
  /// [SqliteCurdObtainModel.insertRow]
  static Future<SingleResult<Map<String, Object?>>> insertRowReturnJson<M extends ModelBase>({
    required InsertWrapper<M> putInsertWrapper(),
    required TransactionWrapper? transactionWrapper,
  }) async {
    final SingleResult<Map<String, Object?>> returnResult = SingleResult<Map<String, Object?>>();

    final SingleResult<M> insertRowResult = await SqliteCurdObtainModel.insertRow<M>(
      putInsertWrapper: putInsertWrapper,
      connectTransactionMark: transactionWrapper,
    );
    await insertRowResult.handle(
      doSuccess: (M successData) async {
        returnResult.setSuccess(putData: () => successData.getRowJson);
      },
      doError: (SingleResult<M> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );

    return returnResult;
  }

  /// [SqliteCurdObtainModel.insertRow]
  static Future<SingleResult<M>> insertRowReturnModel<M extends ModelBase>({
    required InsertWrapper<M> putInsertWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    return await SqliteCurdObtainModel.insertRow<M>(putInsertWrapper: putInsertWrapper, connectTransactionMark: connectTransactionMark);
  }

  ///
  ///
  ///
  ///
  ///
  /// U
  ///
  /// [SqliteCurdObtainModel.updateRow]
  static Future<SingleResult<Map<String, Object?>>> updateRowReturnJson<M extends ModelBase>({
    required UpdateWrapper putUpdateWrapper(),
    required TransactionWrapper? transactionWrapper,
  }) async {
    final SingleResult<Map<String, Object?>> returnResult = SingleResult<Map<String, Object?>>();

    final SingleResult<M> updateRowResult = await SqliteCurdObtainModel.updateRow<M>(
      putUpdateWrapper: putUpdateWrapper,
      connectTransactionMark: transactionWrapper,
    );
    await updateRowResult.handle(
      doSuccess: (M successData) async {
        returnResult.setSuccess(putData: () => successData.getRowJson);
      },
      doError: (SingleResult<M> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );

    return returnResult;
  }

  /// [SqliteCurdObtainModel.updateRow]
  static Future<SingleResult<M>> updateRowReturnModel<M extends ModelBase>({
    required UpdateWrapper putUpdateWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    return await SqliteCurdObtainModel.updateRow<M>(putUpdateWrapper: putUpdateWrapper, connectTransactionMark: connectTransactionMark);
  }

  ///
  ///
  ///
  ///
  ///
  /// R
  ///
  /// [SqliteCurdDetail._queryRowsAsJsons]
  static Future<SingleResult<List<Map<String, Object?>>>> queryRowsReturnJson<M extends ModelBase>({
    required QueryWrapper<M> putQueryWrapper(),
    required TransactionWrapper? transactionWrapper,
  }) async {
    return await SqliteCurdDetail.queryRowsAsJsons(putQueryWrapper: putQueryWrapper, connectTransactionMark: transactionWrapper);
  }

  /// [SqliteCurdObtainModel._queryRowsAsModels]
  static Future<SingleResult<List<M>>> queryRowsReturnModel<M extends ModelBase>({
    required QueryWrapper<M> putQueryWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    return await SqliteCurdObtainModel.queryRowsAsModels<M>(putQueryWrapper: putQueryWrapper, connectTransactionMark: connectTransactionMark);
  }

  ///
  ///
  ///
  ///
  ///
  /// D
  ///
  /// [SqliteCurdObtainModel.deleteRow]
  static Future<SingleResult<bool>> deleteRow<M extends ModelBase>({
    required DeleteWrapper putDeleteWrapper(),
    required TransactionWrapper? transactionWrapper,
  }) async {
    return await SqliteCurdObtainModel.deleteRow(putDeleteWrapper: putDeleteWrapper, connectTransactionMark: transactionWrapper);
  }
}
