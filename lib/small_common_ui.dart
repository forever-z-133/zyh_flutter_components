import 'package:flutter/material.dart';
import 'package:keep_area/app/utils/AppThemeColor.dart';
import 'package:keep_area/main.dart';

/// 每个子元素之间加点间隙
List<Widget> widgetGapRight(double gap, { List<Widget> children }) {
  List<Widget> result = [];
  children.forEach((Widget child) {
    result.add(child);
    result.add(new Padding(padding: EdgeInsets.only(left: gap)));
  });
  result.removeLast();
  return result;
}
List<Widget> widgetGapBottom(double gap, { List<Widget> children }) {
  List<Widget> result = [];
  children.forEach((Widget child) {
    result.add(child);
    result.add(new Padding(padding: EdgeInsets.only(bottom: gap)));
  });
  result.removeLast();
  return result;
}

/// 常见的 AppBar
Widget getNormalAppBar(String title, { Function onPop }){
  return new AppBar(
    elevation: 1,
    backgroundColor: AppColor.colorW,
    brightness: Brightness.light,
    leading: new IconButton(
      icon: new Image(
        color: AppColor.colorD,
        height: adaptH(35),
        width: adaptW(20),
        image: new AssetImage(
          'assets/images/Global/icon_return.png',
        ),
      ),
      onPressed: (){
        if (onPop != null) onPop();
      },
    ),
    title: new Text(
      title,
      style: new TextStyle(
        color: AppColor.colorD,
        fontSize: adaptFont(34),
      ),
    ),
    centerTitle: true,
  );
}

/// 常用的文本（非段落）
Widget normalText(String text, [double size = 26, Color color]) {
  color = color ?? AppColor.colorB;
  return new Container(
    child: new Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: adaptFont(size),
        height: 1.14,
      ),
    )
  );
}

/// 常用的横排布局
Widget _normalRow({ List<Widget> children, double gap }) {
  return new Container(
    child: new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgetGapRight(gap, children: children),
    ),
  );
}
Widget normalRow({ List<Widget> children, double itemGap, GestureTapCallback onClick }) {
  itemGap = itemGap ?? adaptW(15);
  if (onClick != null) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: _normalRow(children: children, gap: itemGap),
    );
  }
  return _normalRow(children: children, gap: itemGap);
}

/// 常用图标
Widget normalIcon(url, [double size]) {
  return new Container(
    child: Image.asset(
      url,
      width: adaptW(size),
      height: adaptW(size),
    ),
  );
}