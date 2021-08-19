import 'dart:async';

import 'package:flutter/material.dart';

import 'Global.dart';

enum OnStatus { none, up, down, moving }

class SbButtonApp extends StatelessWidget {
  const SbButtonApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SbButton(
      child: child,
      isIndependentOnDown: true,
      onDown: (PointerDownEvent downEvent) {
        touchPosition = downEvent.localPosition;
        if (onDownEvents.isNotEmpty) {
          onDownEvents.first.call();
          onDownEvents.clear();
        }
      },
      isIndependentOnUp: true,
      onUp: (PointerUpEvent upEvent) {
        touchPosition = upEvent.localPosition;
        if (onUpEvents.isNotEmpty) {
          onUpEvents.first.call();
          onUpEvents.clear();
        }
      },
      isIndependentOnLongPressed: true,
      onLongPressed: (PointerDownEvent downEvent) {
        touchPosition = downEvent.localPosition;
        if (onLongPressedEvents.isNotEmpty) {
          onLongPressedEvents.first.call();
          onLongPressedEvents.clear();
        }
      },
    );
  }
}

/// 当 [SbButton] 被触发 setState，并不会 setState child，因为 child 是一个对象
///
/// [isIndependentOnDown]\[isIndependentOnUp]\[isIndependentOnLongPressed]：是否为独立 button。
///   - 若为 true，嵌套 [SbButton] 时，无论该 [SbButton] 处在那一层，只要触发必然触发事件。
///   - 若为 false，嵌套 [SbButton] 只会触发最上层的事件。为 false 时，顶层 [MaterialApp] 必须被 [SbButtonApp] 包裹。
///
/// [backgroundColor]：正常情况下的背景颜色。
///
/// [downBackgroundColor]：触发 down 时的背景颜色。
class SbButton extends StatefulWidget {
  const SbButton({
    required this.child,
    this.onDown,
    this.onUp,
    this.onLongPressed,
    this.onMove,
    this.isIndependentOnDown = false,
    this.isIndependentOnUp = false,
    this.isIndependentOnLongPressed = false,
  });

  final Widget child;
  final void Function(PointerDownEvent details)? onDown;
  final void Function(PointerUpEvent details)? onUp;
  final void Function(PointerDownEvent details)? onLongPressed;
  final void Function(PointerMoveEvent details)? onMove;
  final bool isIndependentOnDown;
  final bool isIndependentOnUp;
  final bool isIndependentOnLongPressed;

  @override
  State<StatefulWidget> createState() {
    return _SbButton();
  }
}

class _SbButton extends State<SbButton> {
  Offset _onDownPosition = Offset.zero;
  OnStatus _onStatus = OnStatus.none;
  Timer? _timer;

  final int _longPressedTime = 1000;
  final double _moveRange = 5.0;

  @override
  Widget build(BuildContext context) {
    return Listener(
      child: widget.child,
      onPointerDown: (PointerDownEvent details) {
        _onDownPosition = details.position;
        _timer = Timer(Duration(milliseconds: _longPressedTime), () {
          setLongPressedStatus(details);
        });
        _onStatus = OnStatus.down;
        setDownStatus(details);
      },
      onPointerUp: (PointerUpEvent details) {
        // 若长按被触发后触发了 up
        if (!(_timer?.isActive ?? true)) {
          setState(() {});
          return;
        }

        // 当被移动到触发区外时，
        if (_onStatus == OnStatus.none) {
          return;
        }

        // 当按下未移动，或按下后移动且仍处在 [moving 区] 内时，
        else if (_onStatus == OnStatus.down || _onStatus == OnStatus.moving) {
          _timer?.cancel();
          setUpStatus(details);
        }
      },
      onPointerMove: (PointerMoveEvent event) {
        widget.onMove?.call(event);

        // 若长按被触发后触发了 move
        if (!(_timer?.isActive ?? true)) {
          return;
        }

        // 处在 [moving 区] 外时，
        final Offset delta = event.position - _onDownPosition;
        if (delta.dx > _moveRange || delta.dy > _moveRange || delta.dx < -_moveRange || delta.dy < -_moveRange) {
          _onStatus = OnStatus.none;
          _timer?.cancel();
          setNoneStatus();
        }

        // 处在 [moving 区] 内时，
        // 移动出 [moving 区] 后又回来还是会被触发 up
        else {
          _onStatus = OnStatus.moving;
          setMovingStatus();
        }
      },
    );
  }

  void setNoneStatus() {}

  void setMovingStatus() {}

  void setDownStatus(PointerDownEvent details) {
    final Function event = () {
      widget.onDown?.call(details);
    };
    if (widget.isIndependentOnDown) {
      event();
    } else {
      onDownEvents.add(event);
    }
  }

  void setUpStatus(PointerUpEvent details) {
    final Function event = () {
      widget.onUp?.call(details);
    };
    if (widget.isIndependentOnUp) {
      event();
    } else {
      onUpEvents.add(event);
    }
  }

  void setLongPressedStatus(PointerDownEvent details) {
    final Function event = () {
      widget.onLongPressed?.call(details);
    };
    if (widget.isIndependentOnLongPressed) {
      event();
    } else {
      onLongPressedEvents.add(event);
    }
  }
}
