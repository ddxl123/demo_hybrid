import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hybrid/engine/constant/OAndroidPermission.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferManager.dart';
import 'package:hybrid/engine/entry/main/MainEntry.dart';
import 'package:hybrid/muc/getcontroller/SingleGetController.dart';
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
    super.onInit();

    _checkAndPush();
    _timer();
  }

  /// 以每秒一次的频率，检查是否已允许悬浮窗权限。
  /// 若已允许，则进行 pop，并将 [MainEntry] 设为初始化成功；若未允许，则继续检查。
  void _timer() {
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        final SingleResult<bool> checkResult = await DataTransferManager.instance.executeToNative<void, bool>(
          operationId: OAndroidPermission_FlutterSend.check_floating_window_permission,
          setSendData: () {},
          resultDataCast: null,
        );
        if (!timer.isActive) {
          return;
        }
        await checkResult.handle<void>(
          onSuccess: (bool successResult) async {
            if (successResult) {
              timer.cancel();
              isAllowed = true;
              sbRouteSetState();
              // 触发 已允许悬浮窗权限，并进行应用数据初始化。
              final SingleGetController singleGetController = Get.find<SingleGetController>(tag: SingleGetController.tag.MAIN_ENTRY_INIT);
              (singleGetController.any['set2']! as Function(SingleGetController))(singleGetController);
              SbHelper.getNavigator!.pop(SbPopResult(popResultSelect: PopResultSelect.one, value: null));
            } else {
              isAllowed = false;
              sbRouteSetState();
            }
          },
          onError: (Object? exception, StackTrace? stackTrace) async {
            // 该错误提示最多存在一秒，因为 timer 每秒一次。
            isAllowed = null;
            sbRouteSetState();
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('检查悬浮窗时发生了异常！'),
              exception: exception,
              stackTrace: stackTrace,
            );
          },
        );
      },
    );
  }

  // 进入该 route 时，立即检查并弹出悬浮窗权限页面。
  Future<void> _checkAndPush() async {
    final SingleResult<bool> checkAndPushResult = await DataTransferManager.instance.executeToNative<void, bool>(
      operationId: OAndroidPermission_FlutterSend.check_and_push_page_floating_window_permission,
      setSendData: () {},
      resultDataCast: null,
    );
    await checkAndPushResult.handle<void>(
      onSuccess: (bool successResult) async {
        // 无论 true 或 false，都不进行处理，都已经交付给 timer 处理了。
      },
      onError: (Object? exception, StackTrace? stackTrace) async {
        // 该错误提示最多存在一秒，因为 timer 每秒一次。
        isAllowed = null;
        sbRouteSetState();
        SbLogger(
          code: null,
          viewMessage: null,
          data: null,
          description: Description('检查是否已允许悬浮窗权限（若未允许则弹出权限设置页面）发生异常！'),
          exception: checkAndPushResult.exception,
          stackTrace: checkAndPushResult.stackTrace,
        ).withRecord();
      },
    );
  }

  @override
  List<Widget> body() {
    return <Widget>[
      SbRoundedBox(
        whenSizeChanged: (SizeInt newSizeInt) {},
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(() {
                if (isAllowed == null) {
                  return '出现错误！';
                }
                if (isAllowed!) {
                  return '已允许悬浮窗权限！';
                }
                return '您未允许悬浮窗权限！';
              }()),
            ],
          ),
          if (isAllowed == null || !isAllowed!)
            Row(
              children: <Widget>[
                TextButton(
                  child: const Text('获取'),
                  onPressed: () {
                    _checkAndPush();
                  },
                ),
                TextButton(
                  child: const Text('退出'),
                  onPressed: () {
                    exit(0);
                  },
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
