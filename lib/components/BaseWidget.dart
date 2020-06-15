import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class BaseWidget extends StatefulWidget {
  BaseWidget({ Key key }) : super(key: key);

  @override
  BaseWidgetState createState() {
    this.onBeforeCreate();
    return new BaseWidgetState();
  }
  
  final Map<String, dynamic> state = {};

  void onBeforeCreate() {}
  void onCreated(state) {}
  void onBeforeMount() {}
  void onMounted() {}
  void onBeforeUpdate() {}
  void onUpdated() {}
  void onBeforeDestroy() {}
  void onDestroyed() {}

  Widget render(BuildContext context, state) {
    return new Container();
  }

  void onNetChange(ConnectivityResult result) {}
}

class BaseWidgetState<T extends BaseWidget> extends State<T> {
  bool enter = false;
  final Map<String, dynamic> _state = {};
  dynamic networkListener;

  @override
  initState() {
    widget.onCreated(widget.state);
    widget.state.forEach((key, value) {
      _state[key] = value;
    });
    super.initState();
    // networkListener = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   widget.onNetChange(result);
    // });
  }

  @override
  didUpdateWidget(oldWidget) {
    widget.onBeforeUpdate();
    super.didUpdateWidget(oldWidget);
    widget.onUpdated();
  }

  @override
  didChangeDependencies() {
    enter = !enter;
    enter ? widget.onBeforeMount() : widget.onBeforeDestroy();
    super.didChangeDependencies();
    enter ? widget.onMounted() : widget.onDestroyed();
  }

  @override
  void dispose() {
    super.dispose();
    // networkListener.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: widget.render(context, _state),
    );
  }
}
