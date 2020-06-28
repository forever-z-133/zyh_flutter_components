import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/RunTimeWidget.dart';

class Page22 extends StatefulWidget {
  @override
  _Page22State createState() => new _Page22State();
}
class _Page22State extends State<Page22> {
  String name = '22';

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
          new Text('PAGE22'),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/page11');
            },
            child: new Text('to1'),
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
