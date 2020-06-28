import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  Widget build(BuildContext context) {
    return new Center(
      child: new GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/page11');
        },
        child: new Text('home'),
      ),
    );
  }
}
