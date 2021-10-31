import 'dart:async';

import 'package:get/get.dart';
import 'package:hybrid/engine/constant/execute/EngineEntryName.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/engine/entry/main/FloatingWindowPermissionRoute.dart';
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
    final SingleResult<bool> checkResult = await DataTransferManager.instance.transfer.toNative<void, bool>(
      operationId: OToNative.check_floating_window_permission,
      setSendData: () {},
      resultDataCast: null,
    );
    await checkResult.handle<void>(
      onSuccess: (bool successResult) async {
        if (successResult) {
          // 进行应用数据初始化。
          await setInitStatus(MainEntryInitStatus.appDataInitializing);
        } else {
          // 让用户获取悬浮窗权限。
          SbHelper.getNavigator!.push(FloatingWindowPermissionRoute());
        }
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        await setInitStatus(MainEntryInitStatus.error, '权限检查发生异常！');
        SbLogger(
          c: null,
          vm: null,
          data: null,
          descp: Description('发生异常！'),
          e: exception,
          st: stackTrace,
        ).withRecord();
      },
    );
  }

  /// 应用数据初始化。
  ///
  /// 主要启动数据中心引擎。
  Future<void> _appDataInitializing() async {
    final SingleResult<bool> startDataCenterResult = await DataTransferManager.instance.transfer.execute<void, bool>(
      executeForWhichEngine: EngineEntryName.DATA_CENTER,
      operationIdWhenEngineOnReady: null,
      setOperationData: () {},
      startViewParams: null,
      endViewParams: null,
      closeViewAfterSeconds: null,
      resultDataCast: null,
    );
    await startDataCenterResult.handle<void>(
      onSuccess: (bool successResult) async {
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
      onError: (Object? exception, StackTrace? stackTrace) async {
        await setInitStatus(MainEntryInitStatus.error, '应用数据初始化异常！');
        SbLogger(
          c: null,
          vm: null,
          data: null,
          descp: Description('发生异常！'),
          e: exception,
          st: stackTrace,
        ).withRecord();
      },
    );
  }

  /// 用户数据初始化。
  ///
  /// 主要检查用户是否已登录、用户数据是否已下载。
  Future<void> _userDataInitializing() async {
    final Future<bool?> Function(bool isCheckOnly) checkUser = (bool isCheckOnly) async {
      // 为 null 表示异常。
      bool? isPass = false;
      await DataTransferManager.instance.transfer.executeSomething.checkUser(
        onSuccess: () async {
          isPass = true;
        },
        onNotPass: () async {
          isPass = false;
        },
        onError: (Object? exception, StackTrace? stackTrace) async {
          isPass = null;
          SbLogger(
            c: null,
            vm: null,
            data: null,
            descp: Description('发生异常！'),
            e: exception,
            st: stackTrace,
          ).withRecord();
        },
        isCheckOnly: isCheckOnly,
      );
      return isPass;
    };

    final bool? checkResult = await checkUser(false);
    if (checkResult == true) {
      setInitStatus(MainEntryInitStatus.ok);
      return;
    } else if (checkResult == null) {
      setInitStatus(MainEntryInitStatus.error, '用户数据初始化发生了异常！');
      return;
    }
    // checkResult 为 false 时，会弹出操作框。

    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        final bool? timerResult = await checkUser(true);
        if (!timer.isActive) {
          return;
        }
        if (timerResult == true) {
          setInitStatus(MainEntryInitStatus.ok);
          timer.cancel();
        } else if (timerResult == null) {
          setInitStatus(MainEntryInitStatus.error, '用户数据初始化发生了异常！');
          timer.cancel();
        }
        // timerResult 为 false 时，会继续循环。
      },
    );
  }
}
