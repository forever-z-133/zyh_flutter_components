import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/utils/index.dart';

class BaseWidget extends StatefulWidget {
  BaseWidget({ Key key }) : super(key: key);
  State controller;
  void bindState(State state) {
    controller = state;
  }

  @override
  BaseWidgetState createState() {
    this.onBeforeCreate();
    return new BaseWidgetState();
  }

  void onBeforeCreate() {}
  void onCreated(state) {}
  void onBeforeMount() {}
  void onMounted() {}
  void onBeforeUpdate() {}
  void onUpdated() {}
  void onBeforeDestroy() {}
  void onDestroyed() {}
  // Function setData;

  Widget render(BuildContext context, Map<String, dynamic> state) {
    return new Container();
  }
}

class BaseWidgetState<T extends BaseWidget> extends State<T> {
  bool enter = false;
  final Map<String, dynamic> _state = {};
  Timer _timer;

  @override
  initState() {
    widget.onCreated(_state);
    widget.bindState(this);
    super.initState();
    // _timer = setInterval(() {
      // if (mounted) return;
    //   if (isDifferentState(_state, widget.state)) setState(() { });
    // }, 300);
    print('initState');
  }

  @override
  didUpdateWidget(oldWidget) {
    widget.onBeforeUpdate();
    super.didUpdateWidget(oldWidget);
    widget.onUpdated();
    print('didUpdateWidget');
  }

  @override
  didChangeDependencies() {
    enter = !enter;
    enter ? widget.onBeforeMount() : widget.onBeforeDestroy();
    super.didChangeDependencies();
    if (!enter) widget.onDestroyed();
    print('didChangeDependencies');
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
    print('dispose');
  }

  @override
  Widget build(BuildContext context) {
    setTimeout(() {
      if (enter) widget.onMounted();
    }, 100);
    return widget.render(context, _state);
  }

  bool isDifferentState(Map newState, Map oldState) {
    newState.forEach((key, value) {

    });
    return true;
  }
}
