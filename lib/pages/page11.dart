import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/MyToast.dart';
import 'package:zyh_flutter_components/components/RunTimeWidget.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';

class Page11 extends StatefulWidget {
  @override
  _Page11State createState() => new _Page11State();
}
class _Page11State extends State<Page11> {
  String name = '11';

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
