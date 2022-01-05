// ignore_for_file: avoid_classes_with_only_static_members
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:sqflite/sqflite.dart';

import 'OpenSqlite.dart';
import 'SqliteCurdDetail.dart';
import 'SqliteCurdWrapper.dart';

class SqliteCurdObtainModel {
  ///

  /// [returnWhere]: 对每个 model 进行格外操作。
  static Future<SingleResult<List<M>>> queryRowsAsModels<M extends ModelBase>({
    required QueryWrapper<M> putQueryWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    final SingleResult<List<M>> returnResult = SingleResult<List<M>>();

    Future<void> handle(QueryWrapper<M> queryWrapper, TransactionWrapper tm) async {
      final SingleResult<List<Map<String, Object?>>> queryRowsAsJsonsResult = await SqliteCurdDetail.queryRowsAsJsons(
        connectTransactionMark: tm,
        putQueryWrapper: () => queryWrapper,
      );
      await queryRowsAsJsonsResult.handle(
        doSuccess: (List<Map<String, Object?>> successResult) async {
          final List<M> models = <M>[];
          for (final Map<String, Object?> row in successResult) {
            final M newModel = ModelManager.createEmptyModelByTableName<M>(queryWrapper.tableName);
            newModel.getRowJson.addAll(row);
            models.add(newModel);
          }
          returnResult.setSuccess(putData: () => models);
        },
        doError: (SingleResult<List<Map<String, Object?>>> errorResult) async {
          throw errorResult.getRequiredE();
        },
      );
    }

    try {
      final QueryWrapper<M> queryWrapper = putQueryWrapper();

      if (connectTransactionMark != null) {
        await handle(queryWrapper, connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(queryWrapper, TransactionWrapper(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地查询异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  /// 查看 [_toInsertRow] 注释。
  ///
  /// 会自动根据 [ModelManager.isLocal] 进行判断是使用原生非原生。
  static Future<SingleResult<M>> insertRow<M extends ModelBase>({
    required InsertWrapper<M> putInsertWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    final SingleResult<M> returnResult = SingleResult<M>();

    Future<void> handle(InsertWrapper<M> insertWrapper, TransactionWrapper tm) async {
      if (ModelManager.isLocal(insertWrapper.model.tableName)) {
        // 注意用事务进行插入
        final int rowId = await tm.transaction.insert(insertWrapper.model.tableName, insertWrapper.model.getRowJson);
        insertWrapper.model.getRowJson['id'] = rowId;
      } else {
        await SqliteCurdDetail.toInsertRow(model: insertWrapper.model, transactionMark: tm);
      }
      returnResult.setSuccess(putData: () => insertWrapper.model);
    }

    try {
      final InsertWrapper<M> insertWrapper = putInsertWrapper();

      if (connectTransactionMark != null) {
        await handle(insertWrapper, connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(insertWrapper, TransactionWrapper(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地插入异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  /// 查看 [_toUpdateRow] 注释。
  ///
  /// 当 [connectTransactionMark] 不为空时，内部的异常会 rethrow。
  ///
  /// 无论 [connectTransactionMark] 是否为空，[onError] 都会接收到内部的异常。
  static Future<SingleResult<M>> updateRow<M extends ModelBase>({
    required UpdateWrapper putUpdateWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    final SingleResult<M> returnResult = SingleResult<M>();

    Future<void> handle(UpdateWrapper updateWrapper, TransactionWrapper tm) async {
      if (ModelManager.isLocal(updateWrapper.modelTableName)) {
        await tm.transaction.update(updateWrapper.modelTableName, updateWrapper.updateContent, where: 'id = ?', whereArgs: <Object?>[updateWrapper.modelId]);
        final SingleResult<List<M>> queryRowsAsModelsResult = await SqliteCurdObtainModel.queryRowsAsModels<M>(
          connectTransactionMark: tm,
          putQueryWrapper: () => QueryWrapper<M>(tableName: updateWrapper.modelTableName, where: 'id = ?', whereArgs: <Object?>[updateWrapper.modelId]),
        );
        await queryRowsAsModelsResult.handle<void>(
          doSuccess: (List<M> successResult) async {
            returnResult.setSuccess(putData: () => successResult.first);
          },
          doError: (SingleResult<List<M>> errorResult) async {
            throw errorResult.getRequiredE();
          },
        );
      } else {
        final M tur = await SqliteCurdDetail.toUpdateRow(updateWrapper: updateWrapper, connectTransactionMark: tm);
        returnResult.setSuccess(putData: () => tur);
      }
    }

    try {
      final UpdateWrapper updateWrapper = putUpdateWrapper();

      if (connectTransactionMark != null) {
        await handle(updateWrapper, connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(updateWrapper, TransactionWrapper(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地更新异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }

  /// {@macro RSqliteCurd.deleteRow}
  ///
  /// 返回的结果要么为 true，要么为异常，并不存在为 false 的情况。
  ///
  /// 当 [connectTransactionMark] 不为空时，内部的异常始终会 rethrow。
  ///
  /// 无论 [connectTransactionMark] 是否为空，[onError] 都会接收到内部的异常。
  static Future<SingleResult<bool>> deleteRow({
    required DeleteWrapper putDeleteWrapper(),
    required TransactionWrapper? connectTransactionMark,
  }) async {
    final SingleResult<bool> returnResult = SingleResult<bool>();

    Future<void> handle(DeleteWrapper deleteWrapper, TransactionWrapper tm) async {
      if (ModelManager.isLocal(deleteWrapper.modelTableName)) {
        final int deleteCount = await tm.transaction.delete(deleteWrapper.modelTableName, where: 'id = ?', whereArgs: <Object?>[deleteWrapper.modelId]);
        if (deleteCount != 1) {
          throw '删除数量异常！$deleteCount';
        }
      } else {
        await SqliteCurdDetail.toDeleteRow(deleteWrapper: deleteWrapper, connectTransactionMark: tm);
      }
      returnResult.setSuccess(putData: () => true);
    }

    try {
      final DeleteWrapper deleteWrapper = putDeleteWrapper();

      if (connectTransactionMark != null) {
        await handle(deleteWrapper, connectTransactionMark);
      } else {
        await db.transaction<void>(
          (Transaction txn) async {
            await handle(deleteWrapper, TransactionWrapper(txn));
          },
        );
      }
    } catch (e, st) {
      if (connectTransactionMark != null) {
        rethrow;
      } else {
        returnResult.setError(vm: '本地删除异常！', descp: Description(''), e: e, st: st);
      }
    }
    return returnResult;
  }
}
