import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/BaseWidget.dart';
import 'package:zyh_flutter_components/pages/page1.dart';
import 'package:zyh_flutter_components/pages/page2.dart';
import 'package:zyh_flutter_components/utils/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List<Widget> listData = [];
    // int index = 0;
    // new List(30).forEach((element) {
    //   listData.add(new ZyhComp(start: index++));
    // });
    return MaterialApp(
      routes: {
        '/page1': (context) => Page1(),
        '/page2': (context) => Page2(),
      },
      home: new Container(
        child: SingleChildScrollView(
          child: new Container(
            width: px(750),
            child: new Column(
              children: <Widget>[
                // ...listData,
                StateLess(
                  title: 'less',
                  child: new Container(),
                ),
                StateFul(
                  title: 'ful',
                  child: new Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StateLess extends StatelessWidget {
  final String title;
  final Widget child;
  StateLess({ Key key, this.title, this.child }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pushNamed('/page1');
      },
      child: new Row(
        children: <Widget>[
          new Text(this.title),
          this.child,
        ],
      ),
    );
  }
}
class StateFul extends StatefulWidget {
  final String title;
  final Widget child;
  StateFul({ Key key, this.title, this.child }) : super(key: key);

  @override
  _StateFulState createState() => new _StateFulState();
}
class _StateFulState extends State<StateFul> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: new Row(
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              setState(() {
                count++;
              });
            },
            child: new Text('${widget.title} $count'),
          ),
          new GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pushNamed('/page2');
            },
            child: StateLess(
              title: 'xxx',
              child: new Container(),
            ),
          ),
          widget.child,
        ],
      ),
    );
  }
}

// class ZyhComp extends BaseWidget {
//   final int start;
//   ZyhComp({ Key key, this.start }) : super(key: key);

//   onCreated(state) {
//     state['title'] = '点我 ${this.start}';
//     state['count'] = 0;
//   }

//   Widget render(BuildContext context, Map state) {
//     return new GestureDetector(
//       onTap: () {
//         state['count'] = state['count'] + 1;
//         state['title'] = '${this.start} '.padLeft(state['count'], 'x');
//         print(this);
//         // this.controller.setState(() { });
//       },
//       child: new Text(state['title']),
//     );
//   }
// }
