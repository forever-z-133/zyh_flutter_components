import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/RunTimeWidget.dart';

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
          new Text('PAGE11'),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/page22');
            },
            child: new Text('to2'),
          ),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: new Text('back'),
          ),
        ],
      ),
    );
  }
}
