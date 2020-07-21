import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class FlashWrap extends StatefulWidget {
  final Widget child;

  FlashWrap({ Key key, this.child }) : super(key: key);

  @override
  _FlashWrapState createState() => _FlashWrapState();
}
class _FlashWrapState extends State<FlashWrap> with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..addStatusListener((AnimationStatus status) {
        if (status != AnimationStatus.completed) return;
        _controller.forward(from: 0.0);
      });
    _controller..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      child: widget.child,
      builder: (BuildContext context, Widget child) => Flash(
        child: child,
        value: _controller.value,
      ),
    );
  }
}

@immutable
class Flash extends SingleChildRenderObjectWidget {
  final double value;

  const Flash({
    Widget child,
    this.value
  }) : super(child: child);

  @override
  FlashState createRenderObject(BuildContext context) {
    return FlashState(value);
  }

  @override
  void updateRenderObject(BuildContext context, FlashState state) {
    state.value = value;
  }
}

class FlashState extends RenderProxyBox {
  double _value = 100;

  Gradient _gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.centerRight,
      colors: <Color>[
        Colors.grey[700],
        Colors.grey[700],
        Colors.grey[400],
        Colors.grey[700],
        Colors.grey[700]
      ],
      stops: const <double>[
        0.0,
        0.35,
        0.5,
        0.65,
        1.0
      ]);

  FlashState(this._value);

  @override
  bool get alwaysNeedsCompositing => child != null;

  set value(double newValue) {
    if (newValue == _value) return;
    _value = newValue;
    markNeedsPaint();
  }

  final _clearPaint = Paint();
  final Paint _gradientPaint = Paint()..blendMode = BlendMode.srcIn;

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null) {
      final double width = child.size.width;
      final double height = child.size.height;
      double dx = _offset(-width, width, _value);
      double dy = 0.0;
      Rect rect = Rect.fromLTWH(offset.dx - width, offset.dy, 3 * width, height);

      _gradientPaint.shader = _gradient.createShader(rect);

      context.canvas.saveLayer(offset & child.size, _clearPaint);
      context.paintChild(child, offset);
      context.canvas.translate(dx, dy);
      context.canvas.drawRect(rect, _gradientPaint);
      context.canvas.restore();
    }
  }

  double _offset(double start, double end, double percent) {
    return start + (end - start) * percent;
  }
}
