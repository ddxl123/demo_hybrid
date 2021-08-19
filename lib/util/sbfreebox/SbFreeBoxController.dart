import 'package:flutter/material.dart';

import 'Global.dart';

class FreeBoxCamera {
  FreeBoxCamera({
    required this.easyPosition,
    required this.scale,
  });

  /// 缩放值。
  double scale;

  /// 简易位置。
  Offset easyPosition;

  /// 获取实际位置。
  Offset getActualPosition() => easyPosition - sbFreeBoxBodyOffset;
}

class SbFreeBoxController {
  ///

  /// 当前相机
  FreeBoxCamera freeBoxCamera = FreeBoxCamera(easyPosition: Offset.zero, scale: 1);

  /// 整个 box 的 setState。
  late final void Function(void Function()) sbFreeBoxSetState;

  /// 惯性滑动的动画控制器，
  late final AnimationController inertialSlideAnimationController;

  /// 目标滑动的动画控制器。
  late final AnimationController targetSlideAnimationController;

  /// 有关位置的动画片段。
  late Animation<Offset> _offsetAnimation;

  /// 有关缩放的动画片段。
  late Animation<double> _scaleAnimation;

  /// 有关缩放的变换标记。
  double _lastTempScale = 1;

  /// 有关位置的缩放标记。
  Offset _lastTempTouchPosition = const Offset(0, 0);

  /// 是否禁用触摸事件
  bool _isDisableTouch = false;

  /// 是否禁用 end 触摸事件。目的是为了防止接触禁用后，end 函数体内任务仍然被触发
  bool _isDisableEndTouch = false;

  void dispose() {
    inertialSlideAnimationController.dispose();
    targetSlideAnimationController.dispose();
  }

  /// touch 事件
  void onScaleStart(ScaleStartDetails details) {
    if (_isDisableTouch) {
      return;
    }

    /// 停止所有滑动动画
    _stopAll();

    /// 重置上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = 1;
    _lastTempTouchPosition = details.localFocalPoint;

    sbFreeBoxSetState(() {});
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    if (_isDisableTouch) {
      return;
    }

    /// 进行缩放
    final double deltaScale = details.scale - _lastTempScale;
    freeBoxCamera.scale *= 1 + deltaScale;

    /// 缩放后的位置偏移
    final Offset pivotDeltaOffset = (freeBoxCamera.getActualPosition() - details.localFocalPoint) * deltaScale;
    freeBoxCamera.easyPosition += pivotDeltaOffset;

    /// 非缩放的位置偏移
    final Offset deltaOffset = details.localFocalPoint - _lastTempTouchPosition;
    freeBoxCamera.easyPosition += deltaOffset;

    /// 变换上一次 [临时缩放] 和 [临时触摸位置]
    _lastTempScale = details.scale;
    _lastTempTouchPosition = details.localFocalPoint;

    sbFreeBoxSetState(() {});
  }

  void onScaleEnd(ScaleEndDetails details) {
    if (_isDisableTouch || _isDisableEndTouch) {
      _isDisableEndTouch = false;
      return;
    }
    _inertialSlide(details);
  }

  /// 惯性滑动
  void _inertialSlide(ScaleEndDetails details) {
    // 持续时间
    inertialSlideAnimationController.duration = const Duration(milliseconds: 500);
    // 结束的位置
    final Offset endEasyOffset = freeBoxCamera.easyPosition + Offset(details.velocity.pixelsPerSecond.dx / 10, details.velocity.pixelsPerSecond.dy / 10);
    // 配置惯性滑动 --- 当前到目标
    _offsetAnimation = inertialSlideAnimationController.drive(CurveTween(curve: Curves.easeOutCubic)).drive(
          Tween<Offset>(begin: freeBoxCamera.easyPosition, end: endEasyOffset),
        );

    // 执行惯性滑动
    inertialSlideAnimationController.forward(from: 0.0);
    inertialSlideAnimationController.addListener(_inertialSlideListener);
  }

  /// 惯性滑动监听
  void _inertialSlideListener() {
    freeBoxCamera.easyPosition = _offsetAnimation.value;

    /// 被 stop() 或 动画播放完成 时, removeListener()
    if (inertialSlideAnimationController.isDismissed || inertialSlideAnimationController.isCompleted) {
      inertialSlideAnimationController.removeListener(_inertialSlideListener);
    }

    sbFreeBoxSetState(() {});
  }

  /// 禁用触摸事件。
  void disableTouch(bool isDisable) {
    if (isDisable) {
      _isDisableTouch = true;
      _isDisableEndTouch = true;
    } else {
      _isDisableTouch = false;
    }
  }

  /// 屏幕坐标转盒子坐标
  ///
  /// 减去 [sbFreeBoxBodyOffset] 目的之一是为了不让 多位数 的结果存储，而只存储非偏移的数据，例如，只存 Offset(123,456)，而不存 Offset(10123,10456)。
  ///
  /// 注意，是基于 [screenPosition]\ [position]\[scale] 属性定位。
  Offset screenToBoxActual(Offset screenPosition) {
    return (screenPosition - freeBoxCamera.getActualPosition()) / freeBoxCamera.scale - sbFreeBoxBodyOffset;
  }

  /// 滑动至目标位置。
  ///
  /// 初始化时要滑动到 负 [sbFreeBoxBodyOffset] 的位置，原因是左上位置是界限，元素会被切除渲染。
  void targetSlide({required FreeBoxCamera targetCamera, required bool rightNow}) {
    // 停止全部动画（同时会移除其他监听）。
    _stopAll();
    if (rightNow) {
      freeBoxCamera.easyPosition = targetCamera.easyPosition;
      freeBoxCamera.scale = targetCamera.scale;
      sbFreeBoxSetState(() {});
      return;
    }

    // 持续时间。
    targetSlideAnimationController.duration = const Duration(seconds: 1);
    // 从当前到目标。
    _offsetAnimation = targetSlideAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween<Offset>(
          begin: freeBoxCamera.easyPosition,
          end: targetCamera.easyPosition,
        ));
    _scaleAnimation = targetSlideAnimationController.drive(CurveTween(curve: Curves.easeInOutBack)).drive(Tween<double>(
          begin: freeBoxCamera.scale,
          end: targetCamera.scale,
        ));
    targetSlideAnimationController.forward(from: 0.4);
    targetSlideAnimationController.addListener(_targetSlideListener);
  }

  /// 滑动至目标位置监听
  void _targetSlideListener() {
    freeBoxCamera.easyPosition = _offsetAnimation.value;
    freeBoxCamera.scale = _scaleAnimation.value;

    /// 被 stop() 或 动画播放完成 时, removeListener()
    if (targetSlideAnimationController.isDismissed || targetSlideAnimationController.isCompleted) {
      targetSlideAnimationController.removeListener(_targetSlideListener);
    }

    sbFreeBoxSetState(() {});
  }

  /// 停止所有滑动动画。
  ///
  /// 被停止同时会被 removeListener，因为 addListener 的函数对象内都对 isDismissed（是否被 stop）进行了判断。
  void _stopAll() {
    inertialSlideAnimationController.stop();
    targetSlideAnimationController.stop();
  }
}
