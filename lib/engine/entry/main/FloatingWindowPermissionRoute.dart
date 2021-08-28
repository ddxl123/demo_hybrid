import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hybrid/engine/constant/EngineEntryName.dart';
import 'package:hybrid/engine/constant/OMain.dart';
import 'package:hybrid/engine/datatransfer/root/BaseDataTransfer.dart';
import 'package:hybrid/engine/datatransfer/root/DataTransferBinding.dart';
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

  // 以每秒一次的频率，检查是否已允许悬浮窗权限。
  // 若已允许，则进行 pop；若未允许，则继续检查。
  void _timer() {
    Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) async {
        if (!timer.isActive) {
          return;
        }

        final MessageResult<bool> result = await DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
          sendToWhichEngine: EngineEntryName.native,
          operationId: OMain_FlutterSend.check_floating_window_permission,
          data: null,
        );

        result.handle(
          (bool data) async {
            if (!timer.isActive) {
              return;
            }

            if (data) {
              timer.cancel();

              isAllowed = true;
              sbRouteSetState();

              SbHelper.getNavigator!.pop<SbPopResult>(SbPopResult(popResultSelect: PopResultSelect.one, value: null));
              return;
            } else {
              isAllowed = false;
              sbRouteSetState();
            }
          },
          (Object? exception, StackTrace? stackTrace) async {
            if (timer.isActive) {
              return;
            }

            isAllowed = null;
            sbRouteSetState();
            SbLogger(
              code: null,
              viewMessage: null,
              data: null,
              description: Description('检查是否已允许悬浮窗权限发生异常！'),
              exception: exception,
              stackTrace: stackTrace,
            ).withRecord();
          },
        );
      },
    );
  }

  Future<void> _checkAndPush() async {
    // 进入该 route 时，立即检查并弹出悬浮窗权限页面。
    final MessageResult<bool> result = await DataTransferBinding.instance.currentDataTransfer.sendMessageToOtherEngine<void, bool>(
      sendToWhichEngine: EngineEntryName.native,
      operationId: OMain_FlutterSend.check_and_push_page_floating_window_permission,
      data: null,
    );

    result.handle(
      (bool data) async {
        // 无论 true 或 false，都不进行处理，都已经交付给 timer 处理了。
      },
      (Object? exception, StackTrace? stackTrace) async {
        // 该错误提示最多存在一秒。
        isAllowed = null;
        sbRouteSetState();
        SbLogger(
          code: null,
          viewMessage: null,
          data: null,
          description: Description('检查是否已允许悬浮窗权限（若未允许则弹出权限设置页面）发生异常！'),
          exception: exception,
          stackTrace: stackTrace,
        ).withRecord();
      },
    );
  }

  @override
  List<Widget> body() {
    return <Widget>[
      SbRoundedBox(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(() {
                if (isAllowed == null) {
                  return '出现错误！';
                }
                if (isAllowed!) {
                  return '已允许！';
                }
                return '您未允许悬浮窗权限！';
              }()),
            ],
          ),
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
