import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/MyToast.dart';
import 'package:zyh_flutter_components/components/RunTimeWidget.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';

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
          normalText('PAGE22'),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed('/page11');
            },
            child: normalText('to1'),
          ),
          new GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: normalText('back'),
          ),
          new GestureDetector(
            onTap: () {
              showToast(
                '',
                builder: (context) {
                  return new GestureDetector(
                    onTap: () {
                      showToast('xxxx');
                    },
                    child: normalText('再开一个弹窗'),
                  );
                }
              );
            },
            child: normalText('toast'),
          ),
        ],
      ),
    );
  }
}
