import 'package:flutter/material.dart';
import 'OverlayContainer.dart';
import 'OverlayFuture.dart' show OverlayFuture;
import 'OverlayWrapper.dart' show overlayContextMap;

OverlayFuture currentOverlay;

/*
 * 用于全局弹窗
 * 比如自己重写 showOverlay 进行显示，然后调用 hideOverlay 关闭
 */
void showOverlay({ 
  BuildContext context,
  Widget child,
  WidgetBuilder builder,
  OverlayAnimationBuilder animationBuilder,
  Duration animationDuration,
  VoidCallback onDismiss,
  Function success
}) {
  context ??= overlayContextMap.values.first;
  GlobalKey key = new GlobalKey();

  Widget toast = OverlayContainer(
    key: key,
    animationBuilder: animationBuilder,
    animationDuration: animationDuration,
    child: Container(
      color: Colors.black54,
      child: builder != null ? builder(context) : child ?? new Container(),
    ),
  );
  
  OverlayEntry entry = OverlayEntry(
    builder: (ctx) => toast,
  );

  overlayContextMap[context] = entry;
  OverlayFuture future = OverlayFuture(entry, onDismiss, key);

  Overlay.of(context).insert(entry);
  currentOverlay = future;
}

void hideOverlay() {
  currentOverlay?.dismiss();
}
