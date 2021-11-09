import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/engine/datatransfer/root/execute/ExecuteHttpCurd.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

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
  /// 关于 [operationId]：
  ///
  ///   > - 若引擎【已启动】或【刚启动】，且其引擎【第一帧被执行完成】后，需要进行的 operation 操作。
  ///
  ///   > - 若 [operationId] 为空，即不传递 operation，则 [R] 必须为 [bool] 类型。
  ///
  /// 关于 [setOperationData]：
  ///
  ///   > - 当 [operationId] 不为空时要传递的数据。
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
    required String? operationId,
    required S setOperationData(),
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData)?,
  }) async {
    final SingleResult<R> executeResult = SingleResult<R>();

    if (executeForWhichEngine == EngineEntryName.NATIVE || executeForWhichEngine == EngineEntryName.MAIN) {
      return executeResult.setError(
        vm: '入口函数错误！',
        descp: Description(''),
        e: Exception('executeForWhichEngine 不能为 ${EngineEntryName.NATIVE} 或 ${EngineEntryName.MAIN}！'),
        st: null,
      );
    }

    // 检测是否已启动引擎，若未启动，则启动。
    final SingleResult<bool> bootResult = await DataTransferManager.instance.sendMessageToOther<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OToNative.START_ENGINE,
      setSendData: () => <String, Object?>{'start_which_engine': executeForWhichEngine},
      resultDataCast: null,
    );
    await bootResult.handle<void>(
      doSuccess: (bool isBoot) async {
        // 引擎已启动或已触发启动引擎，则得到 true。
        if (isBoot) {
          await (await _isPushedEngineOnReady(executeForWhichEngine)).handle<void>(
            doSuccess: (bool isReadySuccess) async {
              // 为 true 时，已准备好；为 false 时，准备失败。
              if (isReadySuccess) {
                await _handleViewAndOperation<S, R>(
                  executeResult: executeResult,
                  executeForWhichEngine: executeForWhichEngine,
                  operationId: operationId,
                  setOperationData: setOperationData,
                  startViewParams: startViewParams,
                  endViewParams: endViewParams,
                  closeViewAfterSeconds: closeViewAfterSeconds,
                  resultDataCast: resultDataCast,
                );
              } else {
                executeResult.setError(vm: '准备失败！', descp: Description(''), e: Exception('isReadySuccess 始终为 false！'), st: null);
              }
            },
            doError: (SingleResult<bool> errorResult) async {
              executeResult.setError(
                vm: errorResult.getRequiredVm(),
                descp: errorResult.getRequiredDescp(),
                e: errorResult.getRequiredE(),
                st: errorResult.stackTrace,
              );
            },
          );
        } else {
          executeResult.setError(vm: '启动失败！', descp: Description(''), e: Exception('启动引擎发生了异常！result 不为 true！'), st: null);
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        executeResult.setError(
          vm: errorResult.getRequiredVm(),
          descp: errorResult.getRequiredDescp(),
          e: errorResult.getRequiredE(),
          st: errorResult.stackTrace,
        );
      },
    );
    return executeResult;
  }

  Future<void> _handleViewAndOperation<S, R extends Object>({
    required SingleResult<R> executeResult,
    required String executeForWhichEngine,
    required String? operationId,
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
        doError: (SingleResult<ViewParams> errorResult) async {
          executeResult.setError(
              vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
          return null;
        },
      );
      if (lastViewParams == null) {
        return;
      }

      final SingleResult<SizeInt> screenSizeResult = await DataTransferManager.instance.transfer.executeSomething.getScreenSize();
      screenSize = await screenSizeResult.handle<SizeInt?>(
        doSuccess: (SizeInt size) async {
          return size;
        },
        doError: (SingleResult<SizeInt> errorResult) async {
          executeResult.setError(
              vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
          return null;
        },
      );
      if (screenSize == null) {
        return;
      }
    }

    final SingleResult<bool> setViewParamsResult = await DataTransferManager.instance.sendMessageToOther<Map<String, Object?>, bool>(
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
    await setViewParamsResult.handle<void>(
      doSuccess: (bool isSetViewParamsSuccess) async {
        if (isSetViewParamsSuccess) {
          // 配置 view 成功，进行 operation 配置。
          if (operationId != null) {
            final SingleResult<R> operationResult = await DataTransferManager.instance.sendMessageToOther<S, R>(
              sendToWhichEngine: executeForWhichEngine,
              operationId: operationId,
              setSendData: setOperationData,
              resultDataCast: resultDataCast,
            );
            await operationResult.handle(
              doSuccess: (R successResult) async {
                executeResult.setSuccess(setResult: () => successResult);
              },
              doError: (SingleResult<R> errorResult) async {
                executeResult.setError(
                    vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
              },
            );
          }

          // 配置 view 成功，无需进行 operation 配置。
          else {
            executeResult.setSuccess(setResult: () => true as R);
          }
        } else {
          // 配置 view 失败。
          executeResult.setError(vm: '视口配置异常！', descp: Description(''), e: Exception('isSetViewParamsSuccess 不为 true'), st: null);
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        executeResult.setError(
            vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
        ;
      },
    );
  }

  /// 检查对应引擎的第一帧是否已被初始化完成。
  ///
  /// 返回独立的 [SingleResult]。其中的 bool：为 true，则表示已准备好；为 false，则为准备失败。
  Future<SingleResult<bool>> _isPushedEngineOnReady(String whichEngine) async {
    final Future<SingleResult<bool>> Function() putIsOnReady = () async {
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
      // 新的 SingleResult 对象。
      // 为空表示未 onReady，并继续循环。
      final SingleResult<bool>? isOnReadyResult = await (await putIsOnReady()).handle<SingleResult<bool>?>(
        doSuccess: (bool successResult) async {
          if (successResult) {
            return SingleResult<bool>().setSuccess(setResult: () => true);
          } else {
            await Future<void>.delayed(delayed);
          }
        },
        doError: (SingleResult<bool> errorResult) async {
          return SingleResult<bool>().setError(
            vm: errorResult.getRequiredVm(),
            descp: errorResult.getRequiredDescp(),
            e: errorResult.getRequiredE(),
            st: errorResult.stackTrace,
          );
        },
      );
      if (isOnReadyResult != null) {
        return isOnReadyResult;
      }
    }
    return SingleResult<bool>().setSuccess(setResult: () => false);
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
