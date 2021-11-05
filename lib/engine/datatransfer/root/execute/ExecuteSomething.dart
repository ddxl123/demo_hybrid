import 'package:hybrid/data/sqlite/mmodel/MUser.dart';
import 'package:hybrid/data/sqlite/sqliter/SqliteCurd.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/util/SbHelper.dart';

import '../DataTransferManager.dart';

/// 可以在任何引擎中执行。
class ExecuteSomething {
  ///

  /// 检查用户是否已登陆、检查用户初始数据是否已被下载。
  ///
  /// [onSuccess]：全部检查通过。
  ///
  /// [onNotPass]：未通过。表示用户未登录或未下载初始数据。
  ///
  /// [onError]：发生了异常。
  ///   - 弹出框时发生了异常也会被 [onError] 捕获。
  ///
  /// [isCheckOnly]：是否只检查，而不进行 push。
  ///
  Future<void> checkUser({
    required Future<void> onSuccess(),
    required Future<void> onNotPass(),
    required Future<void> onError(Object? exception, StackTrace? stackTrace),
    required bool isCheckOnly,
  }) async {
    final SingleResult<List<MUser>> queryResult = await DataTransferManager.instance.transfer.executeSqliteCurd.queryRowsAsModels<MUser>(
      QueryWrapper(tableName: MUser().tableName),
    );
    await queryResult.handle<void>(
      doSuccess: (List<MUser> successResult) async {
        if (successResult.isEmpty) {
          if (!isCheckOnly) {
            await onNotPass();

            // TODO: 弹出登陆页面引擎。
            final SingleResult<bool> pushResult = await DataTransferManager.instance.transfer.execute<void, bool>(
              executeForWhichEngine: EngineEntryName.LOGIN_AND_REGISTER,
              operationIdWhenEngineOnReady: null,
              setOperationData: () {},
              startViewParams: (ViewParams lastViewParams, SizeInt screenSize) {
                return ViewParams(width: 500, height: 1000, x: 200, y: 200, isFocus: true);
              },
              endViewParams: (ViewParams lastViewParams, SizeInt screenSize) {
                return ViewParams(width: 500, height: 1000, x: 200, y: 200, isFocus: true);
              },
              closeViewAfterSeconds: null,
              resultDataCast: null,
            );
            await pushResult.handle(
              doSuccess: (bool successResult) async {
                if (!successResult) {
                  throw Exception('result 不为 true！');
                }
              },
              doError: (Object? exception, StackTrace? stackTrace) async {
                // 弹出异常，则抛出。
                throw Exception(exception);
              },
            );
          }
        } else {
          if (successResult.first.get_is_downloaded_init_data == 1) {
            await onSuccess();
          } else {
            await onNotPass();
            if (!isCheckOnly) {
              // TODO: 弹出初始化数据下载页面引擎。
            }
          }
        }
      },
      doError: (Object? exception, StackTrace? stackTrace) async {
        await onError(exception, stackTrace);
      },
    );
  }

  /// 获取当前引擎的 window 大小(非 flutter 实际大小)
  Future<SingleResult<ViewParams>> getNativeWindowViewParams(String whichEngine) async {
    return await DataTransferManager.instance.transfer.toNative<String, ViewParams>(
      operationId: OToNative.GET_NATIVE_WINDOW_VIEW_PARAMS,
      setSendData: () => whichEngine,
      resultDataCast: (Object result) => ViewParams.fromJson((result as Map<Object?, Object?>).cast<String, dynamic>()),
    );
  }

  /// 获取屏幕的物理像素大小。
  Future<SingleResult<SizeInt>> getScreenSize() async {
    return await DataTransferManager.instance.transfer.toNative<void, SizeInt>(
      operationId: OToNative.GET_SCREEN_SIZE,
      setSendData: () {},
      resultDataCast: (Object resultData) {
        final Map<String, int> castData = (resultData as Map<Object?, Object?>).cast<String, int>();
        return SizeInt(castData['width']!, castData['height']!);
      },
    );
  }
}
