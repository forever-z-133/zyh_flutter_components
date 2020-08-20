import 'package:flutter/material.dart';
import 'OverlayContainer.dart' show OverlayContainerState;

/*
 * 存储 overlay 的回调，外放 dismiss 出去用
 */
class OverlayFuture {
  final OverlayEntry _entry;
  final VoidCallback _onDismiss;
  final GlobalKey _containerKey;

  OverlayFuture(
    this._entry,
    this._onDismiss,
    this._containerKey,
  );

  void dismiss({bool showAnim = false}) {
    OverlayContainerState state = _containerKey.currentState;
    if (state != null) {
      state.showDismissAnim(() {
        _entry.remove();
        _onDismiss?.call();
      });
    } else {
      _entry.remove();
      _onDismiss?.call();
    }
  }
}
