import 'package:flutter/material.dart';

abstract class BaseStatefulView extends StatefulWidget {
  BaseStatefulView({Key key}) : super(key: key);

  @override
  BaseStatefulViewState createState() {
    var baseStatefulViewState = this.onCreateState();
    return baseStatefulViewState;
  }

  ///子类重写的创建方法，不需要重写createState方法
  BaseStatefulViewState onCreateState();
}

abstract class BaseStatefulViewState<T extends BaseStatefulView> extends State<T> {
  String currentRouteName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(context) {
    return new Container();
  }
}
