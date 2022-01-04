import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/constant/execute/OToNative.dart';
import 'package:hybrid/engine/entry/main/MainEntry.dart';
import 'package:hybrid/engine/transfer/TransferManager.dart';
import 'package:hybrid/muc/getcontroller/MainEntryGetController.dart';
import 'package:hybrid/util/SbHelper.dart';
import 'package:hybrid/util/sblogger/SbLogger.dart';
import 'package:hybrid/util/sbroundedbox/SbRoundedBox.dart';
import 'package:hybrid/util/sbroute/SbPopResult.dart';
import 'package:hybrid/util/sbroute/SbRoute.dart';

class FloatingWindowPermissionRoute extends SbRoute {
  ///

  /// 悬浮窗权限是否已允许。为 null 时代表出现异常。
  bool? isAllowed = false;

  @override
  void onInit() {
    _timer();
  }

  // 进入该 route 时，立即检查并弹出悬浮窗权限页面。
  Future<void> _checkAndPush() async {
    final SingleResult<bool> checkAndPushResult = await TransferManager.instance.transferExecutor.toNative<void, bool>(
      operationId: OToNative.check_and_push_page_floating_window_permission,
      setSendData: () {},
      resultDataCast: (Object resultData) => resultData as bool,
    );
    await checkAndPushResult.handle<void>(
      doSuccess: (bool successResult) async {
        // 无论 true 或 false，都不进行处理，都已经交付给 timer 处理了。
      },
      doError: (SingleResult<bool> errorResult) async {
        // 该错误提示最多存在一秒，因为 timer 每秒一次。
        isAllowed = null;
        sbRouteSetState();
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

  /// 以每秒一次的频率，检查是否已允许悬浮窗权限。
  /// 若已允许，则进行 pop，并将 [MainEntry] 设为初始化成功；若未允许，则继续检查。
  void _timer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        final SingleResult<bool> checkResult = await TransferManager.instance.transferExecutor.toNative<void, bool>(
          operationId: OToNative.check_floating_window_permission,
          setSendData: () {},
          resultDataCast: (Object resultData) => resultData as bool,
        );
        if (!timer.isActive) {
          return;
        }
        await checkResult.handle<void>(
          doSuccess: (bool successResult) async {
            if (successResult) {
              timer.cancel();
              isAllowed = true;
              sbRouteSetState();
              // 触发 已允许悬浮窗权限，并进行应用数据初始化。
              SbHelper.getNavigator!.pop(SbPopResult(popResultSelect: PopResultSelect.one, value: null));
              final MainEntryGetController mainEntryGetController = Get.find<MainEntryGetController>();
              mainEntryGetController.setInitStatus(MainEntryInitStatus.appDataInitializing);
            } else {
              isAllowed = false;
              sbRouteSetState();
            }
          },
          doError: (SingleResult<bool> errorResult) async {
            // 该错误提示最多存在一秒，因为 timer 每秒一次。
            isAllowed = null;
            sbRouteSetState();
            SbLogger(
              c: null,
              vm: errorResult.getRequiredVm(),
              data: null,
              descp: errorResult.getRequiredDescp(),
              e: errorResult.getRequiredE(),
              st: errorResult.stackTrace,
            );
          },
        );
      },
    );
  }

  @override
  List<Widget> body() {
    return <Widget>[
      SbRoundedBox(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        width: 200,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  () {
                    if (isAllowed == null) {
                      return '出现错误！';
                    }
                    if (isAllowed!) {
                      return '已允许悬浮窗权限！';
                    }
                    return '未允许悬浮窗权限！';
                  }(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          if (isAllowed == null || !isAllowed!)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    child: const Text('允许'),
                    onPressed: () {
                      _checkAndPush();
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: const Text('退出'),
                    onPressed: () {
                      exit(0);
                    },
                  ),
                ),
              ],
            )
        ],
      ),
    ];
  }

  @override
  bool whenException(Object? exception, StackTrace? stackTrace) {
    exit(0);
  }

  @override
  Future<bool> whenPop(SbPopResult? popResult) async {
    if (popResult == null) {
      exit(0);
    }
    if (popResult.popResultSelect == PopResultSelect.one) {
      return true;
    }
    return false;
  }
}
