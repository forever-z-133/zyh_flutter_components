import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';
import 'package:zyh_flutter_components/utils/index.dart';

typedef RadioButtonItemBuilder = Widget Function(BuildContext context, int index, String tab, bool isActive);
typedef RadioButtonsOnChangeCallback = bool Function(int newIndex);
typedef RadioButtonsOnChange = bool Function(BuildContext context, int activeIndex, RadioButtonsOnChangeCallback next);

/*
 * 切换状态的组件，比如 tabs 或 radio 等情况可用
 */
class RadioButtons extends StatefulWidget {
  final List<String> list;
  /// MediaQuery 获取总是屏宽有问题，先自己传参好了
  final double width;
  /// 初始选中的索引
  final int defaultIndex;
  /// 子级之间的空隙
  final double itemGap;
  /// 自定义的子组件渲染
  final RadioButtonItemBuilder itemBuilder;
  /// 是否可左右滑动
  final bool canScroll;
  /// 点击单项时的回调
  final RadioButtonsOnChange onChange;

  RadioButtons({
    Key key,
    @required this.list,
    this.width,
    this.defaultIndex = 0,
    this.itemGap = 0.0,
    this.itemBuilder,
    this.canScroll = false,
    this.onChange,
  }) : super(key: key);

  @override
  _RadioButtonsState createState() => new _RadioButtonsState();
}
class _RadioButtonsState extends State<RadioButtons> {
  /// 列表
  List<String> tabs = [];
  /// 当前索引
  int activeIndex = 0;
  /// 本组件宽度
  double wrapWidth = 0;

  @override
  initState() {
    super.initState();
    tabs = widget.list ?? [];
    activeIndex = widget.defaultIndex ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    wrapWidth = widget.width ?? MediaQuery.of(context).size.width ?? 0;
    // 拼凑列表项
    int index = 0;
    List<Widget> children = [];
    tabs.forEach((String tab) {
      Widget child;
      if (widget.itemBuilder != null) {
        child = widget.itemBuilder(context, index, tab, activeIndex == index);
      } else {
        child = _defaultItemWidget(index, tab, activeIndex == index);
      }
      children.add(_itemWrapWidget(child, index));
      index++;
    });
    // 正式渲染
    Widget _tabListWidget = Wrap(
      spacing: widget.itemGap,
      runSpacing: widget.itemGap,
      children: children,
    );
    if (widget.canScroll == true) {
      _tabListWidget = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: _tabListWidget,
      );
    }
    return _tabListWidget;
  }

  // 组件 - 单个元素的壳
  Widget _itemWrapWidget(Widget child, int index) {
    double itemWidth = (wrapWidth - (widget.itemGap * (tabs.length - 1))) / tabs.length;
    // double maxWidth = double.infinity;
    double maxWidth = widget.canScroll ? double.infinity : itemWidth;
    return Container(
      constraints: BoxConstraints(minWidth: itemWidth, maxWidth: maxWidth),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleClickItem(index),
        child: child,
      ),
    );
  }

  /// 组件 - 默认的单个元素
  Widget _defaultItemWidget(int index, String tab, bool isActive) {
    return Container(
      constraints: BoxConstraints(minHeight: px(100)),
      padding: EdgeInsets.all(px(10)),
      child: Center(
        child: normalOverflowText(tab, 30, isActive ? Colors.red : Colors.black),
      ),
    );
  }

  /// 事件 - 点击某一项
  void _handleClickItem(int index) {
    if (widget.onChange != null) {
      bool isCustomCallback = widget.onChange(context, index, onChangeCallback);
      // 若自定义点击事件，可返回 true 并使用 next 来异步更新
      if (isCustomCallback == true) return;
      // 若没有返回 true 则认为没有调用 next，故而自动更新
      onChangeCallback(index);
    } else {
      // 没有自定义点击事件，自动更新
      onChangeCallback(index);
    }
  }

  /// 其他 - 状态切换（可异步切换）
  bool onChangeCallback(int newIndex) {
    activeIndex = newIndex;
    setState(() { });
    return true;
  }
}
