import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurdWrapper.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/transfer/executor/SqliteCurdTransaction/SqliteCurdTransactionQueue.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

import '../TransferManager.dart';

enum CheckUserResultType {
  /// 检查全部通过：用户已登陆、用户初始数据已下载。
  pass,

  /// 用户未登陆。
  notLogin,

  /// 用户已登录，但初始数据未下载。
  notDownload,
}

/// 可以在任何引擎中执行。
class SomethingTransferExecutor {
  ///

  /// 检查用户是否已登陆、检查用户初始数据是否已被下载。
  ///
  /// [onPass]：全部检查通过。
  ///
  /// [onNotPass]：未通过。表示用户未登录或未下载初始数据。
  ///
  /// [onError]：发生了异常。
  ///   - 弹出框时发生了异常也会被 [onError] 捕获。
  ///
  /// [isCheckOnly]：是否只检查，而不进行 push。
  ///
  Future<SingleResult<CheckUserResultType>> checkUser({required bool isCheckOnly}) async {
    final SingleResult<CheckUserResultType> returnResult = SingleResult<CheckUserResultType>();

    final SingleResult<bool> queryResult = await TransferManager.instance.transferExecutor.executeSqliteCurd.executeCurdTransaction(
      putWrapper: () => SqliteCurdTransactionQueue.createRootInRequester(
        putMembers: (SqliteCurdTransactionQueue queue) => <QueueMember>[
          QueueMember<QueryWrapper<MUser>>.createInRequester(
            queue: queue,
            // TODO: 把 MUser().tableName 改成静态调用。
            curdWrapper: QueryWrapper<MUser>(tableName: MUser().tableName),
            laterFunction: (QueueMember<QueryWrapper<MUser>> queueMember) async {
              final List<MUser> curdResult = queueMember.curdWrapper.getCurdResult();

              if (curdResult.isEmpty) {
                // 先配置不通过，再进行弹出操作。
                returnResult.setSuccess(putData: () => CheckUserResultType.notLogin);
                if (!isCheckOnly) {
                  // TODO: 弹出登陆页面引擎。
                  final SingleResult<bool> pushResult = await TransferManager.instance.transferExecutor.executeWithOnlyView<void>(
                    executeForWhichEngine: EngineEntryName.LOGIN_AND_REGISTER,
                    startViewParams: (ViewParams lastViewParams, SizeInt screenSize) {
                      return ViewParams(width: 500, height: 1000, x: 200, y: 200, isFocus: true);
                    },
                    endViewParams: (ViewParams lastViewParams, SizeInt screenSize) {
                      return ViewParams(width: 500, height: 1000, x: 200, y: 200, isFocus: true);
                    },
                    closeViewAfterSeconds: null,
                  );
                  await pushResult.handle(
                    doSuccess: (bool isPushSuccess) async {
                      if (!isPushSuccess) {
                        // TODO: 弹出的成功与失败，不能配置 returnResult，而需要另其独立配置。
                        // returnResult.setError(vm: '弹出登陆页面异常！', descp: Description(''), e: Exception('isPushSuccess 不为 true！'), st: null);
                      }
                    },
                    doError: (SingleResult<bool> errorResult) async {
                      // TODO: 弹出的成功与失败，不能配置 returnResult，而需要另其独立配置。
                      SbLogger(c: null, vm: null, data: null, descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
                      // returnResult.setError(
                      //     vm: errorResult.getRequiredVm(), descp: errorResult.getRequiredDescp(), e: errorResult.getRequiredE(), st: errorResult.stackTrace);
                    },
                  );
                }
              } else {
                if (curdResult.first.get_is_downloaded_init_data == 1) {
                  returnResult.setSuccess(putData: () => CheckUserResultType.pass);
                } else {
                  // 先配置不通过，再进行弹出操作。
                  returnResult.setSuccess(putData: () => CheckUserResultType.notDownload);
                  if (!isCheckOnly) {
                    // TODO: 弹出初始化数据下载页面引擎。
                    // TODO: 弹出的成功与失败，不能配置 returnResult，而需要另其独立配置。
                    SbLogger(c: null, vm: null, data: null, descp: Description(''), e: Exception('弹出失败！'), st: null);
                  }
                }
              }
            },
          ),
        ],
      ),
    );

    await queryResult.handle(
      doSuccess: (bool successData) async {},
      doError: (SingleResult<bool> errorResult) async {},
    );

    return returnResult;
  }

  /// 获取当前引擎的 window 大小(非 flutter 实际大小)
  Future<SingleResult<ViewParams>> getNativeWindowViewParams(String whichEngine) async {
    return await TransferManager.instance.transferExecutor.toNative<String, ViewParams>(
      operationId: OToNative.GET_NATIVE_WINDOW_VIEW_PARAMS,
      setSendData: () => whichEngine,
      resultDataCast: (Object result) => ViewParams.fromJson(result.quickCast()),
    );
  }

  /// 获取屏幕的物理像素大小。
  Future<SingleResult<SizeInt>> getScreenSize() async {
    return await TransferManager.instance.transferExecutor.toNative<void, SizeInt>(
      operationId: OToNative.GET_SCREEN_SIZE,
      setSendData: () {},
      resultDataCast: (Object resultData) {
        final Map<String, int> castData = resultData.quickCast().cast<String, int>();
        return SizeInt(castData['width']!, castData['height']!);
      },
    );
  }
}
