import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/utils/index.dart';

/// 常见的 AppBar
Widget getNormalAppBar(String title, { Function onPop }) {
  return new AppBar(
    elevation: 1,
    backgroundColor: Colors.white,
    brightness: Brightness.light,
    leading: new IconButton(
      icon: new Image(
        color: Colors.grey,
        height: 35,
        width: 20,
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
        color: Colors.grey,
        fontSize: 34,
      ),
    ),
    centerTitle: true,
  );
}

/// 每个子元素之间加点间隙
List<Widget> widgetGapRight({ double itemGap, List<Widget> children }) {
  if (children == null || children.length < 1) return [];
  List<Widget> result = [];
  children.forEach((Widget child) {
    result.add(child);
    result.add(SizedBox(width: itemGap));
  });
  result.removeLast();
  return result;
}
List<Widget> widgetGapBottom({ double itemGap, List<Widget> children }) {
  if (children == null || children.length < 1) return [];
  List<Widget> result = [];
  children.forEach((Widget child) {
    result.add(child);
    result.add(SizedBox(height: itemGap));
  });
  result.removeLast();
  return result;
}

/// 每个子元素之间加线条
List<Widget> widgetBorderBottom({ Color color, List<Widget> children }) {
  if (children == null || children.length < 1) return [];
  List<Widget> result = [];
  children.forEach((Widget child) {
    result.add(child);
    result.add(normalLine(color: color));
  });
  result.removeLast();
  return result;
}

/// 常用的线条
Widget normalLine({ Color color = Colors.black, double size, Axis direction = Axis.horizontal }) {
  // 不传 size 时为毛细线，传了才是像素线
  double thickness = size == null ? 0 : size;
  size ??= 1.0;
  if (direction == Axis.horizontal) {
    return Divider(height: size, thickness: thickness, color: color);
  } else {
    return VerticalDivider(width: size, thickness: thickness, color: color);
  }
}

/// 常用的文本（非段落）
Widget normalText(String text, [double size = 30, Color color = Colors.black, double lineHeight = 1.14]) {
  return new Container(
    child: new Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: px(size),
        fontWeight: FontWeight.normal,
        height: lineHeight,
        decoration: TextDecoration.none,
      ),
    )
  );
}
Widget normalBoldText(String text, [double size = 30, Color color = Colors.black]) {
  return new Container(
    child: new Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: px(size),
        fontWeight: FontWeight.w600,
        height: 1.14,
        decoration: TextDecoration.none,
      ),
    )
  );
}
Widget normalOverflowText(String text, [double size = 30, Color color = Colors.black, double lineHeight = 1.14]) {
  return new Container(
    child: new Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: px(size),
        fontWeight: FontWeight.normal,
        height: lineHeight,
        decoration: TextDecoration.none,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    )
  );
}

/// 常用的横排布局
Widget _normalRow({ List<Widget> children, double itemGap }) {
  return new Container(
    child: new Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: widgetGapRight(itemGap: itemGap, children: children),
    ),
  );
}
Widget normalRow({ List<Widget> children, double itemGap, GestureTapCallback onClick }) {
  itemGap = itemGap ?? px(15);
  if (onClick != null) {
    return new GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onClick,
      child: _normalRow(children: children, itemGap: itemGap),
    );
  }
  return _normalRow(children: children, itemGap: itemGap);
}

/// 常用图标
Widget normalIcon(url, [double size = 30.0, Color color]) {
  return new Container(
    child: Image.asset(
      url,
      color: color,
      width: px(size),
      height: px(size),
    ),
  );
}

/// 常用列表行
class DdCellRow extends StatelessWidget {
  final GestureTapCallback onTap;
  final Color backgroundColor;
  final String title;
  final String label;
  final Widget previosWidget;
  final Widget customTitleWidget;
  final Widget customLabelWidget;
  final bool hideArrow;
  final bool centerTitleStyle;
  final bool noPadding;

  DdCellRow({
    Key key,
    this.onTap,
    this.backgroundColor,
    this.title = '',
    this.label = '',
    this.previosWidget,
    this.customTitleWidget,
    this.customLabelWidget,
    this.hideArrow = false,
    this.centerTitleStyle = false,
    this.noPadding = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    if (centerTitleStyle == false) {
      if (previosWidget != null) children.add(previosWidget);
      if (customTitleWidget != null) children.add(customTitleWidget);
      else if (title != null) children.add(_titleWidget(title));
      if (customLabelWidget != null) children.add(_labelWrapWidget(customLabelWidget));
      else if (label != null) children.add(_labelWrapWidget(_labelWidget(label)));
      if (!hideArrow) children.add(_arrowWidget());
      children = widgetGapRight(itemGap: px(20), children: children);
    } else {
      if (customTitleWidget != null) children.add(_centerTitleWrapWidget(customTitleWidget));
      else if (title != null) children.add(_centerTitleWrapWidget(_titleWidget(title)));
    }
    EdgeInsetsGeometry padding = noPadding ? null : EdgeInsets.symmetric(vertical: px(30), horizontal: px(35));
    BoxConstraints constraints = noPadding ? null : BoxConstraints(minHeight: px(100));
    return Material(
      color: backgroundColor ?? Colors.white,
      child: new InkWell(
        onTap: onTap,
        child: new Container(
          constraints: constraints,
          padding: padding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _centerTitleWrapWidget(Widget child) {
    return Expanded(
      flex: 1,
      child: Center(
        child: child,
      ),
    );
  }
  Widget _titleWidget(String text) {
    return normalText(text, 30);
  }

  Widget _labelWrapWidget(Widget child) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[child],
      ),
    );
  }
  Widget _labelWidget(String text) {
    return Expanded(
      flex: 1,
      child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end),
    );
  }
  
  Widget _arrowWidget() {
    return normalIcon('assets/images/editUserInfo/icon_enter.png', 24);
  }
}
