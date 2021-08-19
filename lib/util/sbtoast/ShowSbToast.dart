import 'package:flutter/material.dart';

import 'SbToastWidget.dart';

void showSbToast<T>({required OverlayState overlayState, required String text}) {
  final OverlayEntry entry = OverlayEntry(
    maintainState: true,
    builder: (_) {
      return SbToastWidget(text: text);
    },
  );
  overlayState.insert(entry);
  Future<void>.delayed(const Duration(seconds: 1), () {
    entry.remove();
  });
}
