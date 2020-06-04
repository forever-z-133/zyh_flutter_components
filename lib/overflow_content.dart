import 'package:flutter/material.dart';
import 'package:keep_area/app/utils/index.dart';

/*
 * 文本超出判断容器
 * 由于 isNeedCut 判断不准确而写的备用方案
 * 原理：由 renderChild 接收是否已超出然后更新视图
*/
typedef OverflowContentRenderChild = Widget Function(BuildContext ctx, bool isOverflow);
class OverflowContent extends StatefulWidget{
  final GlobalKey globalKey = GlobalKey();
  /// 文本
  final String text;
  /// 字体大小
  final double fontSize;
  /// 字体行高
  final double lineHeight;
  /// 多少行算超出
  final int maxLines;
  /// 视图渲染函数
  final OverflowContentRenderChild renderChild;

  OverflowContent({
    Key key,
    this.text = '',
    this.fontSize = 30.0,
    this.lineHeight = 1.5,
    this.maxLines = 4,
    this.renderChild,
  }) : super(key: key);

  @override
  _OverflowContentState createState() => _OverflowContentState();
}

class _OverflowContentState extends State<OverflowContent> {
  /// 是否已处理过（每个组件仅处理一次）
  bool inited = false;
  /// 是否超出
  bool isOverflow = false;

  @override
  Widget build(BuildContext context) {
    if (!inited) {
      inited = true;
      setTimeout(() {
        try {
          double reallyHeight = widget.globalKey.currentContext.size.height;
          double originHeight = widget.fontSize * widget.lineHeight * widget.maxLines;
          setState(() {
            isOverflow = reallyHeight > originHeight;
          });
        } catch(err) {}
      }, 200);
    }
    return new Container(
      key: widget.globalKey,
      child: widget.renderChild(context, isOverflow),
    );
  }
}
