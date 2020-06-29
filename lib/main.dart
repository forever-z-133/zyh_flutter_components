import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/MyToast.dart';
import 'package:zyh_flutter_components/pages/page1.dart';
import 'package:zyh_flutter_components/pages/page2.dart';
import 'package:zyh_flutter_components/pages/page11.dart';
import 'package:zyh_flutter_components/pages/page22.dart';

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
      theme: new ThemeData(),
      routes: {
        '/page1': (context) => Page1(),
        '/page2': (context) => Page2(),
        '/page11': (context) => Page11(),
        '/page22': (context) => Page22(),
      },
      home: Page1(),
      builder: (context, widget) {
        return MyToast(
          child: Scaffold(
            body: widget,
          ),
        );
      },
    );
  }
}
