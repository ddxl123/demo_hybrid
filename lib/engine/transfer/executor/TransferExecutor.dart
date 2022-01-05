import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/constant/o/OUniform.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';
import 'HttpCurdTransferExecutor.dart';
import 'SomethingTransferExecutor.dart';
import 'SqliteCurdTransferExecutor.dart';

class TransferExecutor {
  ///

  final SqliteCurdTransferExecutor executeSqliteCurd = SqliteCurdTransferExecutor();

  final SomethingTransferExecutor executeSomething = SomethingTransferExecutor();

  final HttpCurdTransferExecutor executeHttpCurd = HttpCurdTransferExecutor();

  /// 向其他 flutter 引擎发消息，并接收返回值。（仅发送消息）
  ///
  /// 发送 [sendToWhichEngine]、[operationId]、[putOperationData]，响应得到 [SingleResult] 的 json 对象。
  ///
  /// [S] 发送的数据类型。 using the Flutter standard binary encoding.
  ///
  /// [R] 返回的正确数据类型。 using the Flutter standard binary encoding.
  ///
  /// [sendToWhichEngine] 发送消息到哪个引擎上。
  ///   - 固定：[EngineEntryName.MAIN] -> main 引擎，[EngineEntryName.NATIVE] -> 仅原生。
  ///
  /// [operationId] 操作的唯一标识。
  ///   - 与 [execute] 不同，这个函数的 [operationId] 不能为 null。
  ///
  /// [putOperationData] 发送的附带数据。
  ///   - 当 [S] 为 [void] 时，[putOperationData] 可以直接为 [(){}]。
  ///
  /// [resultDataCast] 将原始 result 类型手动转化为 [R]。
  ///   - 若 [sendToWhichEngine] 为 [EngineEntryName.NATIVE] 时，[resultDataCast] 为数据本身。
  ///   - 若 [sendToWhichEngine] 为其他时，[resultDataCast] 为 [SingleResult] 类型。
  ///
  Future<SingleResult<R>> _sendMessageToOther<S, R extends Object>({
    required String sendToWhichEngine,
    required String operationId,
    required S putOperationData(),
    required R resultDataCast(Object data),
  }) async {
    final SingleResult<R> returnResult = SingleResult<R>();
    try {
      if (sendToWhichEngine == EngineEntryName.NATIVE && R.toString().contains('SingleResult')) {
        return returnResult.setError(
            vm: '不规范异常！', descp: Description(''), e: Exception('当 sendToWhichEngine 为 EngineEntryName.NATIVE 时，R 类型不能为 SingleResult！'), st: null);
      }
      if (sendToWhichEngine != EngineEntryName.NATIVE && !R.toString().contains('SingleResult')) {
        return returnResult.setError(
            vm: '不规范异常！', descp: Description(''), e: Exception('当 sendToWhichEngine 不为 EngineEntryName.NATIVE 时，R 类型必须为 SingleResult！'), st: null);
      }

      final Map<String, Object?> messageMap = <String, Object?>{
        'send_to_which_engine': sendToWhichEngine,
        'operation_id': operationId,
        'operation_data': putOperationData(),
      };

      final Object? sendResult = await TransferManager.instance.transferListener.basicMessageChannel.send(messageMap);
      if (sendResult == null) {
        return returnResult.setError(
          vm: '通道传输异常！',
          descp: Description(''),
          e: Exception('sendResult 为 null！$messageMap'),
          st: null,
        );
      } else {
        return returnResult.setSuccess(putData: () => resultDataCast(sendResult));
      }
    } catch (e, st) {
      return returnResult.setError(vm: '通道传输异常！', descp: Description(''), e: e, st: st);
    }
  }

  /// 在当前引擎中对其他引擎进行 operation。(发送消息并对 view 操作)
  ///
  /// 若未启动引擎，则先启动引擎。
  ///
  /// 关于 [executeForWhichEngine]：
  ///
  ///   > - 要对哪个引擎进行操作。
  ///
  /// 关于 [startWhenClose]：
  ///
  ///   > - 若为 true，则当引擎未启动时，先进行启动，再 operation。
  ///
  ///   > - 若为 false，则当引擎未启动时，抛出异常。
  ///
  /// 关于 [operationId]：
  ///
  ///   > - 若引擎【已启动】或【刚启动】，且其引擎【第一帧被执行完成】后，需要进行的 operation 操作。
  ///
  ///   > - 若 [operationId] 为空，则表示仅启动引擎，不进行 operation，[R] 必须为 [bool] 类型。
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
  ///  TODO: 未整理 [resultDataCast]
  /// 关于 [resultDataCast]：
  ///
  ///   > - 如果 [R] 是 [SingleResult] 类型（即 [executeForWhichEngine] 非 [EngineEntryName.NATIVE] ），则 [resultDataCast] 的数据为 [SingleResult._data]。
  ///
  ///   > - 如果 [R] 不是 [SingleResult] 类型（即 [executeForWhichEngine] 为 [EngineEntryName.NATIVE] ），则 [resultDataCast] 的数据为 [R] 本身。
  ///
  Future<SingleResult<R>> _executeWithView<S, R extends Object>({
    required String executeForWhichEngine,
    required bool startWhenClose,
    required String? operationId,
    required S setOperationData()?,
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData),
  }) async {
    final SingleResult<R> returnResult = SingleResult<R>();

    if (executeForWhichEngine == EngineEntryName.NATIVE || executeForWhichEngine == EngineEntryName.MAIN) {
      return returnResult.setError(
        vm: '执行通道不规范！',
        descp: Description(''),
        e: Exception('${EngineEntryName.NATIVE} 或 ${EngineEntryName.MAIN} 通道的执行不应该使用该函数调用！'),
        st: null,
      );
    }

    if (operationId == null && R.toString() != 'bool') {
      return returnResult.setError(vm: '执行通道不规范', descp: Description(''), e: Exception('当 operationId 为 null 时，R 类型必须为 bool 类型！'), st: null);
    }

    // 检测是否已启动引擎，若未启动，则启动。
    final SingleResult<bool> bootResult = await _sendMessageToOther<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OToNative.START_ENGINE,
      putOperationData: () => <String, Object?>{
        'start_which_engine': executeForWhichEngine,
        'start_when_close': startWhenClose,
      },
      resultDataCast: (Object result) => result as bool,
    );

    await bootResult.handle<void>(
      doSuccess: (bool isBoot) async {
        // 引擎已启动，则得到 true。
        if (isBoot) {
          await (await _isPushedEngineOnReady(executeForWhichEngine)).handle<void>(
            doSuccess: (bool isReadySuccess) async {
              // 为 true 时，已准备好，否则准备失败。
              if (isReadySuccess) {
                await _handleViewAndOperation<S, R>(
                  returnResult: returnResult,
                  executeForWhichEngine: executeForWhichEngine,
                  operationId: operationId,
                  setOperationData: setOperationData,
                  startViewParams: startViewParams,
                  endViewParams: endViewParams,
                  closeViewAfterSeconds: closeViewAfterSeconds,
                  resultDataCast: resultDataCast,
                );
              } else {
                returnResult.setError(vm: '准备启动失败！', descp: Description(''), e: Exception('准备结果不为 true！'), st: null);
              }
            },
            doError: (SingleResult<bool> errorResult) async {
              returnResult.setErrorClone(errorResult);
            },
          );
        } else {
          returnResult.setError(vm: '窗口启动失败！', descp: Description(''), e: Exception('启动结果为 false！'), st: null);
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
    return returnResult;
  }

  Future<void> _handleViewAndOperation<S, R extends Object>({
    required SingleResult<R> returnResult,
    required String executeForWhichEngine,
    required String? operationId,
    required S setOperationData()?,
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData),
  }) async {
    ViewParams? lastViewParams;
    SizeInt? screenSize;
    if (startViewParams != null || endViewParams != null) {
      await (await TransferManager.instance.transferExecutor.executeSomething.getNativeWindowViewParams(executeForWhichEngine)).handle<void>(
        doSuccess: (ViewParams successResult) async {
          lastViewParams = successResult;
        },
        doError: (SingleResult<ViewParams> errorResult) async {
          returnResult.setErrorClone(errorResult);
          lastViewParams = null;
        },
      );
      if (lastViewParams == null) {
        return;
      }

      await (await TransferManager.instance.transferExecutor.executeSomething.getScreenSize()).handle<void>(
        doSuccess: (SizeInt size) async {
          screenSize = size;
        },
        doError: (SingleResult<SizeInt> errorResult) async {
          returnResult.setErrorClone(errorResult);
          screenSize = null;
        },
      );
      if (screenSize == null) {
        return;
      }
    }

    final SingleResult<bool> setViewParamsResult = await _sendMessageToOther<Map<String, Object?>, bool>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: OToNative.SET_VIEW_PARAMS,
      putOperationData: () => <String, Object?>{
        'set_which_engine_view': executeForWhichEngine,
        'start_view_params': startViewParams?.call(lastViewParams!, screenSize!).toJson(),
        'end_view_params': endViewParams?.call(lastViewParams!, screenSize!).toJson(),
        'close_view_after_seconds': closeViewAfterSeconds,
      },
      resultDataCast: (Object result) => result as bool,
    );

    await setViewParamsResult.handle<void>(
      doSuccess: (bool isSetViewParamsSuccess) async {
        if (isSetViewParamsSuccess) {
          // 配置 view 成功，进行 operation 配置。
          if (operationId != null) {
            final SingleResult<R> operationResult = await _sendMessageToOther<S, R>(
              sendToWhichEngine: executeForWhichEngine,
              operationId: operationId,
              putOperationData: setOperationData!,
              resultDataCast: resultDataCast,
            );
            returnResult.setCompleteClone(operationResult);
          }

          // 配置 view 成功，无需进行 operation 配置。
          else {
            returnResult.setSuccess(putData: () => true as R);
          }
        } else {
          // 配置 view 失败。
          returnResult.setError(vm: '视口配置异常！', descp: Description(''), e: Exception('isSetViewParamsSuccess 不为 true'), st: null);
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );
  }

  /// 检查对应引擎的第一帧是否已准备好（初始化完成）。
  ///
  /// 返回独立的 [SingleResult]。为 true 则成功，否则失败。
  Future<SingleResult<bool>> _isPushedEngineOnReady(String executeForWhichEngine) async {
    final SingleResult<bool> returnResult = SingleResult<bool>();

    final Future<SingleResult<SingleResult<bool>>> Function() checkIsOnReady = () async {
      return await _sendMessageToOther<void, SingleResult<bool>>(
        sendToWhichEngine: executeForWhichEngine,
        operationId: OUniform.IS_ENGINE_ON_READY,
        putOperationData: () {},
        resultDataCast: (Object result) => SingleResult<bool>.fromJson(
          json: result.quickCast(),
          dataCast: (Object data) => data as bool,
        ),
      );
    };

    // 每0.5s检测一次。
    const Duration delayed = Duration(milliseconds: 500);
    for (int i = 0; i < 20; i++) {
      // 为空表示未 onReady，并继续循环。
      final bool isBreakFor = await (await checkIsOnReady()).handle<bool>(
        doSuccess: (SingleResult<bool> successResult) async {
          return await successResult.handle<bool>(
            doSuccess: (bool isOnReady) async {
              if (isOnReady) {
                returnResult.setSuccess(putData: () => isOnReady);
                return true;
              } else {
                if (i >= 19) {
                  returnResult.setError(vm: '准备启动失败！', descp: Description(''), e: Exception('经过 10 秒后，始终为 false！'), st: null);
                  return true;
                }
                await Future<void>.delayed(delayed);
                return false;
              }
            },
            doError: (SingleResult<bool> errorResult) async {
              returnResult.setErrorClone(errorResult);
              return true;
            },
          );
        },
        doError: (SingleResult<SingleResult<bool>> errorResult) async {
          returnResult.setErrorClone(errorResult);
          return true;
        },
      );
      if (isBreakFor) {
        break;
      }
    }
    return returnResult;
  }

  /// 未启动则启动，已启动则保持启动。
  Future<SingleResult<bool>> executeWithOnlyView({
    required String executeForWhichEngine,
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
  }) async {
    return await _executeWithView<void, bool>(
      executeForWhichEngine: executeForWhichEngine,
      startWhenClose: true,
      operationId: null,
      setOperationData: null,
      startViewParams: startViewParams,
      endViewParams: endViewParams,
      closeViewAfterSeconds: closeViewAfterSeconds,
      resultDataCast: (Object resultData) => resultData as bool,
    );
  }

  Future<SingleResult<R>> executeWithViewAndOperation<S, R extends Object>({
    required String executeForWhichEngine,
    required bool startEngineWhenClose,
    required String operationId,
    required S setOperationData(),
    required ViewParams startViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required ViewParams endViewParams(ViewParams lastViewParams, SizeInt screenSize)?,
    required int? closeViewAfterSeconds,
    required R resultDataCast(Object resultData),
  }) async {
    final SingleResult<R> returnResult = SingleResult<R>();

    final SingleResult<SingleResult<R>> nestedResult = await _executeWithView<S, SingleResult<R>>(
      executeForWhichEngine: executeForWhichEngine,
      startWhenClose: startEngineWhenClose,
      operationId: operationId,
      setOperationData: setOperationData,
      startViewParams: startViewParams,
      endViewParams: endViewParams,
      closeViewAfterSeconds: closeViewAfterSeconds,
      resultDataCast: (Object resultData) => SingleResult<R>.fromJson(
        json: resultData.quickCast(),
        dataCast: resultDataCast,
      ),
    );
    await nestedResult.handle(
      doSuccess: (SingleResult<R> successData) async {
        await successData.handle(
          doSuccess: (R data) async {
            returnResult.setSuccess(putData: () => data);
          },
          doError: (SingleResult<R> errorResult) async {
            returnResult.setErrorClone(errorResult);
          },
        );
      },
      doError: (SingleResult<SingleResult<R>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );

    return returnResult;
  }

  /// 单独隔出这个函数的原因是，[EngineEntryName.MAIN] 引擎没有 [ViewParams]。
  Future<SingleResult<R>> toNative<S, R extends Object>({
    required String operationId,
    required S setSendData(),
    required R resultDataCast(Object resultData),
  }) async {
    return await _sendMessageToOther<S, R>(
      sendToWhichEngine: EngineEntryName.NATIVE,
      operationId: operationId,
      putOperationData: setSendData,
      resultDataCast: resultDataCast,
    );
  }

  /// 单独隔出这个函数的原因是，[EngineEntryName.MAIN] 引擎没有 [ViewParams]，但返回值为 [SingleResult]。
  Future<SingleResult<R>> toMain<S, R extends Object>({
    required String operationId,
    required S setSendData(),
    required R resultDataCast(Object resultData),
  }) async {
    final SingleResult<R> returnResult = SingleResult<R>();

    final SingleResult<SingleResult<R>> nestedResult = await _sendMessageToOther<S, SingleResult<R>>(
      sendToWhichEngine: EngineEntryName.MAIN,
      operationId: operationId,
      putOperationData: setSendData,
      resultDataCast: (Object data) => SingleResult<R>.fromJson(
        json: data.quickCast(),
        dataCast: resultDataCast,
      ),
    );
    await nestedResult.handle<void>(
      doSuccess: (SingleResult<R> successData) async {
        await successData.handle(
          doSuccess: (R data) async {
            returnResult.setSuccess(putData: () => data);
          },
          doError: (SingleResult<R> errorResult) async {
            returnResult.setErrorClone(errorResult);
          },
        );
      },
      doError: (SingleResult<SingleResult<R>> errorResult) async {
        returnResult.setErrorClone(errorResult);
      },
    );

    return returnResult;
  }
}
