
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';
import 'package:zyh_flutter_components/utils/index.dart';

LinkedHashMap _contextMap = LinkedHashMap();
LinkedHashMap _entryMap = LinkedHashMap();
LinkedHashMap _keyMap = LinkedHashMap();
Duration toastAnimationDuration = Duration(milliseconds: 300);

class MyToast extends StatefulWidget {
  final Widget child;
  MyToast({ Key key, this.child }) : super(key: key);

  @override
  _MyToastState createState() => new _MyToastState();
}

class _MyToastState extends State<MyToast> {
  @override
  void dispose() {
    _contextMap.remove(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var overlay = Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (ctx) {
            _contextMap[this] = ctx;
            return widget.child;
          },
        ),
      ],
    );

    return overlay;
  }
}

void showToast(
  String msg, { 
  BuildContext context,
  bool mask = false,
  WidgetBuilder builder,
  Function success
}) {
  context ??= _contextMap.values.first;
  GlobalKey key = new GlobalKey();

  /// 内容部分
  Widget container = builder != null ? builder(context) : new Container(
    padding: EdgeInsets.symmetric(vertical: px(20), horizontal: px(25)),
    decoration: new BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(px(8))),
    ),
    child: normalText(msg, 24),
  );

  /// 背景部分
  Widget toast = _MyToastContainer(
    key: key,
    child: Container(
      color: Colors.black54,
      child: new Align(
        child: container,
        alignment: Alignment.center,
      ),
    ),
  );

  /// 是否可点击背景关闭
  if (!mask) {
    toast = new GestureDetector(
      onTap: () => hideToast(),
      child: toast,
    );
  }
  
  /// 拼凑元素完成
  OverlayEntry entry = OverlayEntry(
    builder: (ctx) => toast,
  );

  /// 显示弹窗
  _keyMap[context] = key;
  _entryMap[context] = entry;
  Overlay.of(context).insert(entry);
}

void hideToast({ BuildContext context }) {
  context ??= _contextMap.values.first;
  GlobalKey widgetKey = _keyMap[context];
  _MyToastContainerState _state = widgetKey?.currentState;
  _state?.showDismissAnim(() {
    _entryMap[context]?.remove();
    _entryMap.remove(context);
  });
}



class _MyToastContainer extends StatefulWidget {
  final Widget child;

  _MyToastContainer({ Key key, this.child }) : super(key: key);

  @override
  _MyToastContainerState createState() => _MyToastContainerState();
}
class _MyToastContainerState extends State<_MyToastContainer> with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: toastAnimationDuration,
      reverseDuration: toastAnimationDuration,
    );

    Future.delayed(const Duration(milliseconds: 30), () {
      if (!mounted) return;
      _animateTo(1.0);
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        return Opacity(
          child: child,
          opacity: _animationController.value ?? 0,
        );
      },
    );
  }

  void showDismissAnim([ Function callback ]) {
    _animateTo(0, callback);
  }

  _animateTo(double value, [ Function callback ]) async {
    if (!mounted) return;
    if (value == 0) {
      await _animationController?.animateTo(value);
    } else {
      await _animationController?.animateBack(value);
    }
    if (callback != null) callback();
  }
}

