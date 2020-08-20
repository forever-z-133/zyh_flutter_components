import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';
import 'package:zyh_flutter_components/utils/index.dart';
import './src/controller.dart';
export './src/controller.dart' show hideOverlay;
export './src/OverlayWrapper.dart' show OverlayWrapper;

/// 显示强制登出弹窗
void showForcedLoginOutModal({
  BuildContext context,
  VoidCallback onCancel,
  VoidCallback onSuccess,
}) {
  double containerWidth = px(500);
  showOverlay(builder: (BuildContext ctx) {
    return new Align(
      alignment: Alignment.center,
      child: new Container(
        width: containerWidth,
        height: px(34) * 6 + 1 + px(30) * 3,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.all(Radius.circular(10)),
        ),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(px(34)),
              height: px(34) * 6,
              alignment: Alignment.center,
              child: normalText('您的手机号已在其他设备登录', 34),
            ),
            //分割线
            normalLine(),
            //取消、重新登录按钮
            new Container(
              width: containerWidth,
              height: px(30) * 3,
              child: new Row(
                children: <Widget>[
                  new GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (onCancel != null) onCancel();
                      else hideOverlay();
                    },
                    child: new Container(
                      width: (containerWidth - 1) / 2,
                      height: px(30) * 3,
                      alignment: Alignment.center,
                      child: normalText('关闭', 30),
                    ),
                  ),
                  normalLine(direction: Axis.vertical),
                  new GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (onSuccess != null) onSuccess();
                      else hideOverlay();
                    },
                    child: new Container(
                      width: (containerWidth - 1) / 2,
                      height: px(30) * 3,
                      alignment: Alignment.center,
                      child: normalText('重新登录', 30),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}
