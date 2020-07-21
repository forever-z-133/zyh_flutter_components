import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/components/ClipPage.dart';
import 'package:zyh_flutter_components/components/MyToast.dart';
import 'package:zyh_flutter_components/pages/FlashPage.dart';
import 'package:zyh_flutter_components/pages/page1.dart';
import 'package:zyh_flutter_components/pages/page2.dart';
import 'package:zyh_flutter_components/pages/page11.dart';
import 'package:zyh_flutter_components/pages/page22.dart';
import 'package:zyh_flutter_components/pages/waterfall.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: new ThemeData(),
      routes: {
        '/page1': (context) => Page1(),
        '/page2': (context) => Page2(),
        '/page11': (context) => Page11(),
        '/page22': (context) => Page22(),
      },
      home: ClipPage(),
      builder: (BuildContext context, widget) {
        return MyToast(
          child: Scaffold(
            appBar: new PreferredSize(
              preferredSize: Size.zero,
              // child: SizedBox.shrink(),
              child: SafeArea(
                child: SizedBox.shrink()
              ),
              // child: new Container(),
            ),
            body: widget,
          ),
        );
      },
    );
  }
}
