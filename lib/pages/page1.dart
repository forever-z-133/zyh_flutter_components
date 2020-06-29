import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/MyToast.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';

class Page1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/page11');
            },
            child: normalText('home'),
          ),
          new GestureDetector(
            onTap: () {
              showToast('我是首页的弹窗');
            },
            child: normalText('click'),
          ),
        ],
      ),
    );
  }
}
