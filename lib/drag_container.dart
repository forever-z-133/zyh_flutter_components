import 'package:flutter/material.dart';
import 'package:keep_area/main.dart';

enum DragDirection {
  vertical,
  horizontal,
  both
}

/*
 * 可拖拽的组件
 */
class DragContainer extends StatefulWidget {
  final GlobalKey globalKey = GlobalKey();
  final Widget child;
  final double deviation; // 允许偏移量
  final double width; // 外壳范围
  final double height; // 外壳范围
  final GestureTapCallback onTap;
  final GestureDragStartCallback onDragStart;
  final GestureDragUpdateCallback onDragMove;
  final GestureDragEndCallback onDragEnd;
  final DragDirection direction;
  DragContainer({
    Key key,
    this.child,
    this.deviation = 0.0,
    this.width,
    this.height,
    this.onTap,
    this.onDragStart,
    this.onDragMove,
    this.onDragEnd,
    this.direction = DragDirection.horizontal,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => new DragContainerState();
}

class DragContainerState extends State<DragContainer> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;
  Size wrapSize = Size.zero;
  Offset _offset = Offset.zero;
  Offset _prevOffset;
  double _kMinFlingVelocity = 600.0;

  @override
  void initState() {
    super.initState();
    wrapSize = Size(widget.width ?? mediaWidth, widget.height ?? mediaHeight);
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _offset = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // 移动范围限制
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    Offset deviation = Offset(widget.deviation, widget.deviation);
    Offset minOffset = Offset(size.width - wrapSize.width, size.height - wrapSize.height) - deviation;
    Offset maxOffset = Offset(0.0, 0.0) + deviation;
    if (widget.direction == DragDirection.horizontal) {
      
    }
    return Offset(
      offset.dx.clamp(minOffset.dx, maxOffset.dx),
      offset.dy.clamp(minOffset.dy, maxOffset.dy),
    );
  }

  void _handleOnPanStart(DragStartDetails details) {
    setState(() {
      _prevOffset = details.globalPosition - _offset;
      _controller.stop();
    });
    if (widget.onDragStart != null) widget.onDragStart(details);
  }

  void _handleOnPanUpdate(DragUpdateDetails details) {
    setState(() {
      _offset = _clampOffset(details.globalPosition - _prevOffset);
    });
    if (widget.onDragMove != null) widget.onDragMove(details);
  }

  void _handleOnPanEnd(DragEndDetails details) {
    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity) return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    // 计算当前的方向
    final double distance = (Offset.zero & context.size).shortestSide;
    // 计算放大倍速，并相应的放大宽和高，比如原来是600*480的图片，放大后倍数为1.25倍时，宽和高是同时变化的
    _animation = _controller.drive(
      Tween<Offset>(
        begin: _offset,
        end: _clampOffset(_offset + direction * distance)
      )
    );
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
    if (widget.onDragEnd != null) widget.onDragEnd(details);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onPanStart: _handleOnPanStart,
      onPanUpdate: _handleOnPanUpdate,
      onPanEnd: _handleOnPanEnd,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()..translate(_offset.dx, _offset.dy),
          child: widget.child,
        ),
      ),
    );
  }
}
