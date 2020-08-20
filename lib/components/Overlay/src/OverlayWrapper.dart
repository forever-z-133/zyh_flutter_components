import 'dart:collection';
import 'package:flutter/material.dart';

LinkedHashMap overlayContextMap = LinkedHashMap();

/*
 * 套在最外层接收 context 用的
 */
class OverlayWrapper extends StatefulWidget {
  final Widget child;
  OverlayWrapper({ Key key, this.child }) : super(key: key);

  @override
  _OverlayWrapperState createState() => new _OverlayWrapperState();
}

class _OverlayWrapperState extends State<OverlayWrapper> {
  @override
  void dispose() {
    overlayContextMap.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (ctx) {
            overlayContextMap[this] = ctx;
            return widget.child;
          },
        ),
      ],
    );

    return overlay;
  }
}