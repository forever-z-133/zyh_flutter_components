import 'package:flutter/material.dart';

Widget widgetDialogBottomButtonItem(BuildContext context, String text, {
  dynamic color,
  Function onPressed,
}) {
  return new GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: (){
      if (onPressed != null) onPressed();
    },
    child: new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Text(
            text,
            style: new TextStyle(
              fontSize: 30,
              color: color,
            ),
          ),
        ],
      ),
    ),
  );
}

/// 弹窗底部的按钮
Widget widgetDialogBottomButtons(BuildContext context, {
  bool showCancel = true,
  bool showConfirm = true,
  String cancelText = '取消',
  String confirmText = '确定',
  dynamic cancelColor,
  dynamic confirmColor,
  Function onConfirm,
  Function onCancel,
}) {
  cancelColor = cancelColor ?? Colors.grey;
  confirmColor = confirmColor ?? Colors.blue;
  Widget cancelButton = new Expanded(
    child: widgetDialogBottomButtonItem(context, cancelText,
      color: cancelColor,
      onPressed: () {
        Navigator.of(context).pop();
        if (onCancel != null) onCancel();
      }
    )
  );
  Widget confirmButton = new Expanded(
    child: widgetDialogBottomButtonItem(context, confirmText,
      color: confirmColor,
      onPressed: () {
        if (onConfirm != null) onConfirm();
      }
    )
  );
  Widget middleLine = new VerticalDivider(color: Colors.grey, width: 1);
  List<Widget> buttons;
  if (showCancel && showConfirm) buttons = <Widget>[cancelButton, middleLine, confirmButton];
  else if (showConfirm) buttons = <Widget>[confirmButton];
  else return new Container();
  return new Container(
    height: 86,
    decoration: BoxDecoration(
      border: Border(
        top: BorderSide(width: 1, color: Colors.grey),
      ),
    ),
    child: new Row(
      children: buttons
    ),
  );
}
