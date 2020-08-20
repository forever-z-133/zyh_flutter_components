import 'package:flutter/material.dart';

/*
 * 弹层的主要容器部分
 */
typedef OverlayAnimationBuilder = Widget Function(BuildContext context, Widget child, double progress);
class OverlayContainer extends StatefulWidget {
  final Widget child;
  final OverlayAnimationBuilder animationBuilder;
  final Duration animationDuration;

  OverlayContainer({
    Key key,
    this.child,
    this.animationBuilder,
    this.animationDuration,
  }) : super(key: key);

  @override
  OverlayContainerState createState() => OverlayContainerState();
}
class OverlayContainerState extends State<OverlayContainer> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Duration toastAnimationDuration;

  @override
  void initState() {
    super.initState();

    toastAnimationDuration = widget.animationDuration ?? Duration(milliseconds: 100);

    _animationController = AnimationController(
      vsync: this,
      duration: toastAnimationDuration,
      reverseDuration: toastAnimationDuration,
    );

    Future.delayed(const Duration(milliseconds: 30), () {
      if (!mounted) return;
      _animateTo(1.0);
    });
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _animationController = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: _animationController,
      builder: (BuildContext context, Widget child) {
        double progress = _animationController.value ?? 0;
        if (widget.animationBuilder != null) {
          return widget.animationBuilder(context, child, progress);
        } else {
          return Opacity(child: child, opacity: progress);
        }
      },
    );
  }

  /// 外放出去给关闭时用
  void showDismissAnim([ Function callback ]) {
    _animateTo(0, callback);
  }

  /// 运行动画
  _animateTo(double value, [ Function callback ]) async {
    if (!mounted) return;
    if (value == 0) {
      await _animationController?.animateTo(value);
    } else {
      await _animationController?.animateBack(value);
    }
    if (callback != null) callback();
  }
}
