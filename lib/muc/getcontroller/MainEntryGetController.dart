import 'dart:async';

import 'package:get/get.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/entry/main/FloatingWindowPermissionRoute.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/engine/transfer/executor/SomethingTransferExecutor.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';

enum MainEntryInitStatus {
  ok,

  /// 权限检查中
  permissionChecking,

  /// 初始化应用数据中
  appDataInitializing,

  /// 初始化用户数据中
  userDataInitializing,

  /// 异常
  error,
}

class MainEntryGetController extends GetxController {
  MainEntryInitStatus mainEntryInitStatus = MainEntryInitStatus.error;
  String currentInitStatusInfo = 'unknown';

  Future<void> setInitStatus(MainEntryInitStatus meis, [String? errorInfo]) async {
    mainEntryInitStatus = meis;
    switch (mainEntryInitStatus) {
      case MainEntryInitStatus.ok:
        currentInitStatusInfo = '初始化完成。';
        update();
        break;
      case MainEntryInitStatus.permissionChecking:
        currentInitStatusInfo = '检查权限中...';
        update();
        await _permissionCheck();
        break;
      case MainEntryInitStatus.appDataInitializing:
        currentInitStatusInfo = '正在初始化应用数据中...';
        update();
        await _appDataInitializing();
        break;
      case MainEntryInitStatus.userDataInitializing:
        currentInitStatusInfo = '正在初始化用户数据中...';
        update();
        await _userDataInitializing();
        break;
      default:
        currentInitStatusInfo = errorInfo ?? currentInitStatusInfo;
        update();
    }
  }

  /// 权限检查。
  ///
  /// 主要检查悬浮窗权限。
  Future<void> _permissionCheck() async {
    final SingleResult<bool> checkResult = await TransferManager.instance.transferExecutor.toNative<void, bool>(
      operationId: OToNative.check_floating_window_permission,
      setSendData: () {},
      resultDataCast: (Object resultData) => resultData as bool,
    );
    await checkResult.handle<void>(
      doSuccess: (bool successResult) async {
        if (successResult) {
          // 进行应用数据初始化。
          await setInitStatus(MainEntryInitStatus.appDataInitializing);
        } else {
          // 让用户获取悬浮窗权限。
          SbHelper.getNavigator!.push(FloatingWindowPermissionRoute());
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        await setInitStatus(MainEntryInitStatus.error, '权限检查发生异常！');
        SbLogger(
          c: null,
          vm: errorResult.getRequiredVm(),
          data: null,
          descp: errorResult.getRequiredDescp(),
          e: errorResult.getRequiredE(),
          st: errorResult.stackTrace,
        ).withRecord();
      },
    );
  }

  /// 应用数据初始化。
  ///
  /// 主要启动数据中心引擎。
  Future<void> _appDataInitializing() async {
    final SingleResult<bool> startDataCenterResult = await TransferManager.instance.transferExecutor.executeWithOnlyView(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
    );
    await startDataCenterResult.handle<void>(
      doSuccess: (bool successResult) async {
        if (successResult) {
          // 用户数据初始化。
          await setInitStatus(MainEntryInitStatus.userDataInitializing);
        } else {
          await setInitStatus(MainEntryInitStatus.error, '应用数据初始化异常！');
          SbLogger(
            c: null,
            vm: null,
            data: successResult,
            descp: Description('result 不为 true！'),
            e: null,
            st: null,
          ).withRecord();
        }
      },
      doError: (SingleResult<bool> errorResult) async {
        await setInitStatus(MainEntryInitStatus.error, '应用数据初始化异常！');
        SbLogger(
          c: null,
          vm: errorResult.getRequiredVm(),
          data: null,
          descp: errorResult.getRequiredDescp(),
          e: errorResult.getRequiredE(),
          st: errorResult.stackTrace,
        ).withRecord();
      },
    );
  }

  /// 用户数据初始化。
  ///
  /// 主要检查用户是否已登录、用户数据是否已下载。
  Future<void> _userDataInitializing() async {
    final Future<SingleResult<CheckUserResultType>> Function(bool isCheckOnly) checkUser = (bool isCheckOnly) async {
      return await TransferManager.instance.transferExecutor.executeSomething.checkUser(isCheckOnly: isCheckOnly);
    };

    // 这一部分是进行检查并需要弹出时弹出。
    final SingleResult<CheckUserResultType> checkResult = await checkUser(false);
    await checkResult.handle(
      doSuccess: (CheckUserResultType successResult) async {
        if (successResult == CheckUserResultType.pass) {
          setInitStatus(MainEntryInitStatus.ok);
        } else if (successResult == CheckUserResultType.notLogin || successResult == CheckUserResultType.notDownload) {
        } else {
          setInitStatus(MainEntryInitStatus.error, '未知检查类型！');
        }
      },
      doError: (SingleResult<CheckUserResultType> errorResult) async {
        setInitStatus(MainEntryInitStatus.error, errorResult.getRequiredVm());
      },
    );

    // 这一部分是只进行检查。
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        final SingleResult<CheckUserResultType> timerResult = await checkUser(true);
        if (!timer.isActive) {
          return;
        }
        await timerResult.handle(
          doSuccess: (CheckUserResultType successResult) async {
            if (successResult == CheckUserResultType.pass) {
              setInitStatus(MainEntryInitStatus.ok);
              timer.cancel();
            }
            // 否则保持不变，继续循环。
          },
          doError: (SingleResult<CheckUserResultType> errorResult) async {
            setInitStatus(MainEntryInitStatus.error, '检查时出现异常！');
            timer.cancel();
          },
        );
      },
    );
  }
}
