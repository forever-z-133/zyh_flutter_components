import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class TextOverflowWidget extends StatelessWidget {
  final Widget child;
  final int line;

  TextOverflowWidget({
    Key key,
    this.child,
    this.line = 2,
  }) : super(key: key);

  @override
  Widget build(BuildContext build) {
    return TextOverFlow(
      child: child,
      maxHeight: line * 24.0,
    );
  }
}

@immutable
class TextOverFlow extends SingleChildRenderObjectWidget {
  final double maxHeight;

  const TextOverFlow({ Widget child, this.maxHeight }) : super(child: child);

  @override
  TextOverflowState createRenderObject(BuildContext context) => new TextOverflowState(maxHeight);
}
class TextOverflowState extends RenderProxyBox {
  double _maxHeight = 0.0;

  TextOverflowState(this._maxHeight);

  @override
  bool get alwaysNeedsCompositing => child != null;
  
  @override
  void performLayout() {
    if (child != null) {
      child.layout(constraints, parentUsesSize: true);
      if (!isOverflow(child.size)) {
        size = child.size;
      } else {
        size = Size(constraints.maxWidth, _maxHeight + 24);
      }
    } else {
      performResize();
    }
  }
  
  final _clearPaint = Paint();

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final double width = child.size.width;
      final double height = child.size.height;
      print('$width, $height, $_maxHeight');
      context.canvas.saveLayer(offset & child.size, _clearPaint);
      if (!isOverflow(child.size)) {
        context.paintChild(child, offset);
      } else {
        Rect rect = Rect.fromLTWH(offset.dx, offset.dy, width, offset.dy + _maxHeight);
        context.canvas.clipRect(rect);
        context.paintChild(child, offset);
      }
      context.canvas.restore();
    }
  }

  bool isOverflow(Size size) {
    return size.height > _maxHeight;
  }
}
