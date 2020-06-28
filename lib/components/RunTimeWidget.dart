import 'package:flutter/material.dart';

abstract class RunTimeWidget extends StatefulWidget {
  @override
  RunTimeState createState() {
    var baseStatefulViewState = this.onCreateState();
    return baseStatefulViewState;
  }
  RunTimeState onCreateState();
}
abstract class RunTimeState<T extends RunTimeWidget> extends State<T> {
  bool mounted = false;
  String name = 'page ID';

  void onShow() {}
  void onHide() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // this.mounted = !this.mounted;
    print('${this.name} ${this.mounted}');
    // if (mounted) onShow();
    // else onHide();
  }

  @override
  void deactivate() {
    super.deactivate();
    print('${this.name} ${this.mounted}');
  }

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
