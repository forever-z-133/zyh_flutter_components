import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/AppView.dart';
import 'package:zyh_flutter_components/components/MyToast.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';

class Page11 extends BaseStatefulView {
  @override
  _Page11State onCreateState() => new _Page11State();
}
class _Page11State extends BaseStatefulViewState<Page11> {
  String name = '11';

  @override
  String get currentRouteName => '/111';
  
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          normalText('PAGE11'),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/page22');
            },
            child: normalText('to2'),
          ),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: normalText('back'),
          ),
          new GestureDetector(
            onTap: () {
              showToast('xxx');
            },
            child: normalText('toast'),
          ),
        ],
      ),
    );
  }
}
