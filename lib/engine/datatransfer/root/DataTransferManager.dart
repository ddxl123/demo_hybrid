import 'dart:async';

import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelBase.dart';
import 'package:hybrid/data/sqlite/mmodel/ModelManager.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OExecute.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/push/PushTo.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'DataTransferManager.g.dart';

@JsonSerializable()
class ViewParams {
  ViewParams({
    required this.width,
    required this.height,
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
    required this.isFocus,
  });

  factory ViewParams.fromJson(Map<String, Object?> json) => _$ViewParamsFromJson(json);

  Map<String, Object?> toJson() => _$ViewParamsToJson(this);

  final int width;
  final int height;
  final int? left;
  final int? right;
  final int? top;
  final int? bottom;
  @JsonKey(name: 'is_focus')
  final bool? isFocus;
}

class DataTransferManager {
  DataTransferManager._();

  static DataTransferManager instance = DataTransferManager._();

  late String currentEntryPointName;

  late BaseDataTransfer currentDataTransfer;

  /// [currentEntryPointName] 必须比 [currentDataTransfer] 更先进行初始化，
  /// 因为 [currentDataTransfer] 需要 [currentEntryPointName]。
  ///
  /// [dataTransfer] 不能用对象传入，而必须用函数传入。
  /// 因为如果用对象传入，则会导致执行 [binding] 前 [BaseDataTransfer] 会先被构造，这时 [currentEntryPointName] 还并未初始化过，从而导致程序出错。
  void binding(String entryName, BaseDataTransfer dataTransfer()) {
    currentEntryPointName = entryName;
    currentDataTransfer = dataTransfer();
  }

  /// 向其他 flutter 引擎发消息，并接收返回值。
  ///
  /// [S] 发送的数据类型。 using the Flutter standard binary encoding.
  ///
  /// [R] 返回的正确数据类型。 using the Flutter standard binary encoding.
  ///
  /// [sendToWhichEngine] 发送消息到哪个引擎上。
  ///   - 固定：[EngineEntryName.MAIN] -> main 引擎，[EngineEntryName.NATIVE] -> 仅原生。
  ///
  /// [operationId] 操作的唯一标识。
  ///
  /// [data] 发送的附带数据。
  ///
  /// [resultDataCast] 将原始类型手动转化为 [R]，若为空，则自动转化。
  ///
  Future<SingleResult<R>> _sendMessageToOtherEngine<S, R extends Object>({
    required String sendToWhichEngine,
    required String operationId,
    required S data,
    required R resultDataCast(Object resultData)?,
  }) async {
    final SingleResult<R> sendResult = SingleResult<R>.empty();
    try {
      final Map<String, Object?> messageMap = <String, Object?>{
        'send_to_which_engine': sendToWhichEngine,
        'operation_id': operationId,
        'data': data,
      };
      final Object? resultData = await currentDataTransfer.basicMessageChannel.send(messageMap);
      if (resultData == null) {
        throw Exception('''
                
        来自原生的响应数据为 null！
        可能的原因如下：
          1. 消息通道异常。--- 直接返回了 null，而未抛出如何异常，没有错误 log 输出
          2. 原生发生了异常：
            1) 未发现引擎 sendToWhichEngine: $sendToWhichEngine。
            2) 未对 operationId: $operationId 进行处理。
          3. 接收者发生了异常
            1) listenerMessageFormOtherFlutterEngine 内部异常！
            2) 未对 operationId: $operationId 进行处理。
        ''');
      } else {
        await sendResult.setSuccess(setResult: () async => resultDataCast == null ? resultData as R : resultDataCast(resultData));
      }
    } catch (e, st) {
      sendResult.setError(exception: e, stackTrace: st);
    }
    return sendResult;
  }

  /// 检查对应引擎的第一帧是否已被初始化完成。
  Future<SingleResult<bool>> _isPushedEngineFirstFrameInitialized(String whichEngine) async {
    final Future<SingleResult<bool>> Function() send = () async {
      return await _sendMessageToOtherEngine<String, bool>(
        sendToWhichEngine: EngineEntryName.NATIVE,
        operationId: OExecute_FlutterSend.IS_FIRST_FRAME_INITIALIZED,
        data: whichEngine,
        resultDataCast: null,
      );
    };

    // 每0.5s检测一次。
    const Duration delayed = Duration(milliseconds: 500);
    for (int i = 0; i < 20; i++) {
      final SingleResult<bool> sendResult = await send();
      if (!sendResult.hasError) {
        if (sendResult.result!) {
          return await SingleResult<bool>.empty().setSuccess(setResult: () async => true);
        } else {
          await Future<void>.delayed(delayed);
        }
      } else {
        return SingleResult<bool>.empty().setError(exception: sendResult.exception, stackTrace: sendResult.stackTrace);
      }
    }
    return await SingleResult<bool>.empty().setSuccess(setResult: () async => false);
  }

  Future<void> _handleViewAndOperation<S, R extends Object>({
    required SingleResult<R> executeResult,
    required String executeForWhichEngine,
    required String? operationIdIfEngineFirstFrameInitialized,
    required S operationData,
    required ViewParams? startViewParams,
    required ViewParams? endViewParams,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData)?,
  }) async {
    final SingleResult<bool> viewResult = await _sendMessageToOtherEngine<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OExecute_FlutterSend.SET_VIEW,
      data: <String, Object?>{
        'set_which_engine_view': executeForWhichEngine,
        'start_view_params': startViewParams?.toJson(),
        'end_view_params': endViewParams?.toJson(),
        'close_view_after_seconds': closeViewAfterSeconds,
      },
      resultDataCast: null,
    );
    if (!viewResult.hasError) {
      // view set 完成。
      if (viewResult.result!) {
        if (operationIdIfEngineFirstFrameInitialized != null) {
          final SingleResult<R> operationResult = await _sendMessageToOtherEngine<S, R>(
            sendToWhichEngine: executeForWhichEngine,
            operationId: operationIdIfEngineFirstFrameInitialized,
            data: operationData,
            resultDataCast: resultDataCast,
          );
          operationResult.cloneTo(executeResult);
        } else {
          await executeResult.setSuccess(setResult: () async => true as R);
        }
      } else {
        executeResult.setError(exception: Exception('data 不为 true！'), stackTrace: null);
      }
    } else {
      executeResult.setError(exception: viewResult.exception, stackTrace: viewResult.stackTrace);
    }
  }

  /// 在当前引擎中对其他引擎进行 operation。
  ///
  /// 若未启动引擎，则先启动引擎。
  ///
  /// 关于 [executeForWhichEngine]：
  ///
  ///   > - 要对哪个引擎进行操作。
  ///
  ///   > - 若为 [EngineEntryName.MAIN]，则 [startViewParams]、[endViewParams]、[closeViewAfterSeconds] 变得没有意义。
  ///
  ///   > - 若为 [EngineEntryName.NATIVE]，则使用 [executeToNative] 代替。
  ///
  /// 关于 [operationIdIfEngineFirstFrameInitialized]：
  ///
  ///   > - 若引擎已启动或已触发启动，且其引擎第一帧被执行完成时，需要进行的 operation 操作。
  ///
  ///   > - 若 [operationIdIfEngineFirstFrameInitialized] 为空，即不传递 operation，则 [R] 必须为 [bool] 类型。
  ///
  /// 关于 [operationData]：
  ///
  ///   > - 当 [operationIdIfEngineFirstFrameInitialized] 不为空时要传递的数据。
  ///
  /// 关于 [startViewParams]：
  ///
  ///   > - 从 [startViewParams] 配置过渡到 [endViewParams] 配置。
  ///
  ///   > - 当 [startViewParams] 为空，[endViewParams] 不为空时，表示从上一次配置过渡到 [endViewParams] 配置。
  ///
  ///   > - 当 [startViewParams] 不为空，[endViewParams] 为空时，表示从 [startViewParams] 配置过渡到上一次配置。
  ///
  ///   > - 当 [startViewParams] 为空，[endViewParams] 为空时，表示保持上一次配置不变。
  ///
  /// 关于 [closeViewAfterSeconds]：
  ///
  ///   > - 一旦 [startViewParams]，多少秒后关闭 view。
  ///
  ///   > - 为空或为负数时，保持现状不关闭。
  ///
  Future<SingleResult<R>> execute<S, R extends Object>({
    required String executeForWhichEngine,
    required String? operationIdIfEngineFirstFrameInitialized,
    required S operationData,
    required ViewParams? startViewParams,
    required ViewParams? endViewParams,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData)?,
  }) async {
    final SingleResult<R> executeResult = SingleResult<R>.empty();

    if (executeForWhichEngine == EngineEntryName.NATIVE || executeForWhichEngine == EngineEntryName.MAIN) {
      return executeResult.setError(exception: 'executeForWhichEngine 不能为 ${EngineEntryName.NATIVE} 或 ${EngineEntryName.MAIN}！', stackTrace: null);
    }

    // 检测是否已启动引擎，若未启动，则启动。
    final SingleResult<bool> messageResult = await _sendMessageToOtherEngine<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OExecute_FlutterSend.START_ENGINE,
      data: <String, Object?>{'start_which_engine': executeForWhichEngine},
      resultDataCast: null,
    );

    if (!messageResult.hasError) {
      // 引擎已启动或已触发启动引擎，则得到 true。
      if (messageResult.result!) {
        final SingleResult<bool> isInitializedResult = await _isPushedEngineFirstFrameInitialized(executeForWhichEngine);
        if (!isInitializedResult.hasError) {
          if (isInitializedResult.result!) {
            await _handleViewAndOperation<S, R>(
              executeResult: executeResult,
              executeForWhichEngine: executeForWhichEngine,
              operationIdIfEngineFirstFrameInitialized: operationIdIfEngineFirstFrameInitialized,
              operationData: operationData,
              startViewParams: startViewParams,
              endViewParams: endViewParams,
              closeViewAfterSeconds: closeViewAfterSeconds,
              resultDataCast: resultDataCast,
            );
          } else {
            executeResult.setError(exception: Exception('启动引擎后的第一帧初始化发生了异常！result 不为 true！'), stackTrace: null);
          }
        } else {
          executeResult.setError(
            exception: Exception('启动引擎后的第一帧初始化发生了异常！未知异常！' + isInitializedResult.exception.toString()),
            stackTrace: isInitializedResult.stackTrace,
          );
        }
      } else {
        executeResult.setError(exception: Exception('启动引擎发生了异常！result 不为 true！'), stackTrace: null);
      }
    } else {
      executeResult.setError(exception: messageResult.exception, stackTrace: messageResult.stackTrace);
    }
    return executeResult;
  }

  Future<SingleResult<R>> executeToNative<S, R extends Object>({
    required String operationId,
    required S data,
    required R resultDataCast(Object resultData)?,
  }) async {
    return await _sendMessageToOtherEngine<S, R>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: operationId,
      data: data,
      resultDataCast: resultDataCast,
    );
  }

  Future<SingleResult<R>> executeToMain<S, R extends Object>({
    required String operationId,
    required S data,
    required R resultDataCast(Object resultData)?,
  }) async {
    return await _sendMessageToOtherEngine<S, R>(
      sendToWhichEngine: EngineEntryName.MAIN,
      operationId: operationId,
      data: data,
      resultDataCast: resultDataCast,
    );
  }

  final ExecuteSqliteCurd executeSqliteCurd = ExecuteSqliteCurd();

  final ExecuteSomething executeSomething = ExecuteSomething();
}

class ExecuteSqliteCurd {
  ///

  /// 查看 [SqliteCurd.queryRowsAsJsons]
  Future<SingleResult<List<Map<String, Object?>>>> queryRowsAsJsons<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<Map<String, Object?>>> queryRowResult =
        await DataTransferManager.instance.execute<Map<String, Object?>, List<Map<String, Object?>>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationIdIfEngineFirstFrameInitialized: OExecute_FlutterSend.SQLITE_QUERY_ROW_AS_JSONS,
      operationData: queryWrapper.toJson(),
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as List<Object?>).cast<Map<String, Object?>>(),
    );
    if (!queryRowResult.hasError) {
      return await SingleResult<List<Map<String, Object?>>>.empty().setSuccess(setResult: () async => queryRowResult.result!.cast<Map<String, Object?>>());
    } else {
      return SingleResult<List<Map<String, Object?>>>.empty().setError(exception: queryRowResult.exception, stackTrace: queryRowResult.stackTrace);
    }
  }

  /// 查看 [SqliteCurd.queryRowsAsModels]
  Future<SingleResult<List<T>>> queryRowsAsModels<T extends ModelBase>(QueryWrapper queryWrapper) async {
    final SingleResult<List<Map<String, Object?>>> queryRowResult = await queryRowsAsJsons(queryWrapper);
    if (!queryRowResult.hasError) {
      return await SingleResult<List<T>>.empty().setSuccess(
        setResult: () async {
          final List<T> list = <T>[];
          for (final Map<String, Object?> item in queryRowResult.result!) {
            list.add(ModelManager.createEmptyModelByTableName<T>(queryWrapper.tableName)..setRowJson = item);
          }
          return list;
        },
      );
    } else {
      return SingleResult<List<T>>.empty().setError(exception: queryRowResult.exception, stackTrace: queryRowResult.stackTrace);
    }
  }

  /// 查看 [SqliteCurd.insertRow] 注释。
  Future<SingleResult<T>> insertRow<T extends ModelBase>(T insertModel) async {
    final SingleResult<Map<String, Object?>> insertRowResult = await DataTransferManager.instance.execute<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationIdIfEngineFirstFrameInitialized: OExecute_FlutterSend.SQLITE_INSERT_ROW,
      operationData: <String, Object?>{
        'table_name': insertModel.tableName,
        'model_data': insertModel.getRowJson,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as Map<Object?, Object?>).cast<String, Object?>(),
    );
    if (!insertRowResult.hasError) {
      try {
        return await SingleResult<T>.empty().setSuccess(
          setResult: () async => ModelManager.createEmptyModelByTableName<T>(insertModel.tableName)..setRowJson = insertRowResult.result!,
        );
      } catch (e, st) {
        return SingleResult<T>.empty().setError(exception: e, stackTrace: st);
      }
    } else {
      return SingleResult<T>.empty().setError(exception: insertRowResult.exception, stackTrace: insertRowResult.stackTrace);
    }
  }

  /// 查看 [SqliteCurd.updateRow] 注释。
  Future<SingleResult<T>> updateRow<T extends ModelBase>({
    required String modelTableName,
    required int modelId,
    required Map<String, Object?> updateContent,
  }) async {
    final SingleResult<Map<String, Object?>> updateRowResult = await DataTransferManager.instance.execute<Map<String, Object?>, Map<String, Object?>>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationIdIfEngineFirstFrameInitialized: OExecute_FlutterSend.SQLITE_UPDATE_ROW,
      operationData: <String, Object?>{
        'model_table_name': modelTableName,
        'model_id': modelId,
        'update_content': updateContent,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: (Object resultData) => (resultData as Map<Object?, Object?>).cast<String, Object?>(),
    );
    if (!updateRowResult.hasError) {
      return SingleResult<T>.empty().setSuccess(
        setResult: () async => ModelManager.createEmptyModelByTableName(modelTableName)..setRowJson = updateRowResult.result!,
      );
    } else {
      return SingleResult<T>.empty().setError(exception: updateRowResult.exception, stackTrace: updateRowResult.stackTrace);
    }
  }

  /// 查看 [SqliteCurd.deleteRow] 注释
  Future<SingleResult<bool>> deleteRow({
    required String modelTableName,
    required int? modelId,
  }) async {
    final SingleResult<bool> deleteRowResult = await DataTransferManager.instance.execute<Map<String, Object?>, bool>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationIdIfEngineFirstFrameInitialized: OExecute_FlutterSend.SQLITE_DELETE_ROW,
      operationData: <String, Object?>{
        'model_table_name': modelTableName,
        'model_id': modelId,
      },
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: null,
    );
    if (!deleteRowResult.hasError) {
      if (deleteRowResult.result!) {
        return SingleResult<bool>.empty().setSuccess(setResult: () async => deleteRowResult.result!);
      } else {
        return SingleResult<bool>.empty().setError(exception: Exception('result 不为 true！'), stackTrace: null);
      }
    } else {
      return SingleResult<bool>.empty().setError(exception: deleteRowResult.exception, stackTrace: deleteRowResult.stackTrace);
    }
  }
}

class ExecuteSomething {
  /// 检查是否存在用户数据、初始化数据是否已被下载。
  ///
  /// [onSuccess]：全部检查通过。
  ///
  /// [onNotPass]：未通过。
  ///
  /// [onError]：发生了异常。
  ///
  /// [isCheckOnly]：是否只检查，而不进行 push。
  Future<void> checkUser({
    required Future<void> onSuccess(),
    required Future<void> onNotPass(),
    required Future<void> onError(Object? exception, StackTrace? stackTrace),
    required bool isCheckOnly,
  }) async {
    final SingleResult<List<MUser>> queryResult = await DataTransferManager.instance.executeSqliteCurd.queryRowsAsModels<MUser>(
      QueryWrapper(tableName: MUser().tableName),
    );
    if (!queryResult.hasError) {
      final List<MUser> users = queryResult.result!;
      if (users.isEmpty) {
        if (!isCheckOnly) {
          // TODO: 弹出登陆页面引擎。
          PushTo.loginAndRegister();
        }
        await onNotPass();
      } else {
        if (users.first.get_is_downloaded_init_data != 1) {
          if (!isCheckOnly) {
            // TODO: 弹出初始化数据下载页面引擎。
          }
          await onNotPass();
        } else {
          await onSuccess();
        }
      }
    } else {
      await onError(queryResult.exception, queryResult.stackTrace);
    }
  }
}
