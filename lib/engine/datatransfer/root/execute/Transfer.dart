import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/execute/ExecuteHttpCurd.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../DataTransferManager.dart';
import 'ExecuteSomething.dart';
import 'ExecuteSqliteCurd.dart';

class Transfer {
  ///

  final ExecuteSqliteCurd executeSqliteCurd = ExecuteSqliteCurd();

  final ExecuteSomething executeSomething = ExecuteSomething();

  final ExecuteHttpCurd executeHttpCurd = ExecuteHttpCurd();

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
  ///   > - 若为 [EngineEntryName.NATIVE]，则使用 [toNative] 代替。
  ///
  /// 关于 [operationIdWhenEngineOnReady]：
  ///
  ///   > - 若引擎已启动或已触发启动，且其引擎第一帧被执行完成后，需要进行的 operation 操作。
  ///
  ///   > - 若 [operationIdWhenEngineOnReady] 为空，即不传递 operation，则 [R] 必须为 [bool] 类型。
  ///
  /// 关于 [setOperationData]：
  ///
  ///   > - 当 [operationIdWhenEngineOnReady] 不为空时要传递的数据。
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
    required String? operationIdWhenEngineOnReady,
    required S setOperationData(),
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData)?,
  }) async {
    final SingleResult<R> executeResult = SingleResult<R>.empty();

    if (executeForWhichEngine == EngineEntryName.NATIVE || executeForWhichEngine == EngineEntryName.MAIN) {
      return executeResult.setError(e: 'executeForWhichEngine 不能为 ${EngineEntryName.NATIVE} 或 ${EngineEntryName.MAIN}！', st: null);
    }

    // 检测是否已启动引擎，若未启动，则启动。
    final SingleResult<bool> messageResult = await DataTransferManager.instance.sendMessageToOther<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OToNative.START_ENGINE,
      setSendData: () => <String, Object?>{'start_which_engine': executeForWhichEngine},
      resultDataCast: null,
    );
    await messageResult.handle<void>(
      doSuccess: (bool successResult) async {
        // 引擎已启动或已触发启动引擎，则得到 true。
        if (successResult) {
          final SingleResult<bool> isReadyResult = await _isPushedEngineOnReady(executeForWhichEngine);
          await isReadyResult.handle<void>(
            doSuccess: (bool successResult) async {
              if (successResult) {
                await _handleViewAndOperation<S, R>(
                  executeResult: executeResult,
                  executeForWhichEngine: executeForWhichEngine,
                  operationIdIfEngineFirstFrameInitialized: operationIdWhenEngineOnReady,
                  setOperationData: setOperationData,
                  startViewParams: startViewParams,
                  endViewParams: endViewParams,
                  closeViewAfterSeconds: closeViewAfterSeconds,
                  resultDataCast: resultDataCast,
                );
              } else {
                executeResult.setError(e: Exception('启动引擎后的检查第一帧是否已被初始化发生了异常：result 不为 true！'), st: null);
              }
            },
            doError: (Object? exception, StackTrace? stackTrace) async {
              executeResult.setError(
                e: Exception('启动引擎后的检查第一帧是否已被初始化发生了异常：未知异常！' + exception.toString()),
                st: stackTrace,
              );
            },
          );
        } else {
          executeResult.setError(e: Exception('启动引擎发生了异常！result 不为 true！'), st: null);
        }
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        executeResult.setError(e: exception, st: stackTrace);
      },
    );
    return executeResult;
  }

  Future<void> _handleViewAndOperation<S, R extends Object>({
    required SingleResult<R> executeResult,
    required String executeForWhichEngine,
    required String? operationIdIfEngineFirstFrameInitialized,
    required S setOperationData(),
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData)?,
  }) async {
    ViewParams? lastViewParams;
    SizeInt? screenSize;
    if (startViewParams != null || endViewParams != null) {
      final SingleResult<ViewParams> lastViewParamsResult =
          await DataTransferManager.instance.transfer.executeSomething.getNativeWindowViewParams(executeForWhichEngine);
      lastViewParams = await lastViewParamsResult.handle<ViewParams?>(
        doSuccess: (ViewParams successResult) async {
          return successResult;
        },
        doError: (Object? exception, StackTrace? stackTrace) async {
          executeResult.setError(e: 'lastViewParamsResult 异常！ $exception', st: stackTrace);
          return null;
        },
      );

      final SingleResult<SizeInt> screenSizeResult = await DataTransferManager.instance.transfer.executeSomething.getScreenSize();
      screenSize = await screenSizeResult.handle<SizeInt?>(
        doSuccess: (SizeInt size) async {
          return size;
        },
        doError: (Object? exception, StackTrace? stackTrace) async {
          executeResult.setError(e: 'screenSizeResult 异常！ $exception', st: stackTrace);
          return null;
        },
      );
    }

    final SingleResult<bool> viewResult = await DataTransferManager.instance.sendMessageToOther<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OToNative.SET_VIEW_PARAMS,
      setSendData: () => <String, Object?>{
        'set_which_engine_view': executeForWhichEngine,
        'start_view_params': startViewParams?.call(lastViewParams!, screenSize!).toJson(),
        'end_view_params': endViewParams?.call(lastViewParams!, screenSize!).toJson(),
        'close_view_after_seconds': closeViewAfterSeconds,
      },
      resultDataCast: null,
    );
    await viewResult.handle<void>(
      doSuccess: (bool successResult) async {
        // view set 完成。
        if (successResult) {
          if (operationIdIfEngineFirstFrameInitialized != null) {
            final SingleResult<R> operationResult = await DataTransferManager.instance.sendMessageToOther<S, R>(
              sendToWhichEngine: executeForWhichEngine,
              operationId: operationIdIfEngineFirstFrameInitialized,
              setSendData: setOperationData,
              resultDataCast: resultDataCast,
            );
            operationResult.cloneTo(executeResult);
          } else {
            await executeResult.setSuccess(setResult: () async => true as R);
          }
        } else {
          executeResult.setError(e: Exception('data 不为 true！'), st: null);
        }
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        executeResult.setError(e: exception, st: stackTrace);
      },
    );
  }

  /// 检查对应引擎的第一帧是否已被初始化完成。
  Future<SingleResult<bool>> _isPushedEngineOnReady(String whichEngine) async {
    final Future<SingleResult<bool>> Function() send = () async {
      return await DataTransferManager.instance.sendMessageToOther<void, bool>(
        sendToWhichEngine: whichEngine,
        operationId: OUniform.IS_ENGINE_ON_READY,
        setSendData: () {},
        resultDataCast: null,
      );
    };

    // 每0.5s检测一次。
    const Duration delayed = Duration(milliseconds: 500);
    for (int i = 0; i < 20; i++) {
      final SingleResult<bool> sendResult = await send();
      final SingleResult<bool>? singleResultBool = await sendResult.handle<SingleResult<bool>?>(
        doSuccess: (bool successResult) async {
          if (successResult) {
            return await SingleResult<bool>.empty().setSuccess(setResult: () async => true);
          } else {
            await Future<void>.delayed(delayed);
          }
        },
        doError: (Object? exception, StackTrace? stackTrace) async {
          return SingleResult<bool>.empty().setError(e: 'singleResultBool 异常！$exception', st: stackTrace);
        },
      );
      if (singleResultBool != null) {
        return singleResultBool;
      }
    }
    return await SingleResult<bool>.empty().setSuccess(setResult: () async => false);
  }

  Future<SingleResult<R>> toNative<S, R extends Object>({
    required String operationId,
    required S setSendData(),
    required R resultDataCast(Object resultData)?,
  }) async {
    return await DataTransferManager.instance.sendMessageToOther<S, R>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: operationId,
      setSendData: setSendData,
      resultDataCast: resultDataCast,
    );
  }

  Future<SingleResult<R>> toMain<S, R extends Object>({
    required String operationId,
    required S setSendData(),
    required R resultDataCast(Object resultData)?,
  }) async {
    return await DataTransferManager.instance.sendMessageToOther<S, R>(
      sendToWhichEngine: EngineEntryName.MAIN,
      operationId: operationId,
      setSendData: setSendData,
      resultDataCast: resultDataCast,
    );
  }
}
