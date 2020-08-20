//图片查看器
import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/utils/cache_image.dart';
import 'package:zyh_flutter_components/test/scale_container.dart';
import 'package:zyh_flutter_components/utils/index.dart';

/*
 * imgs url数组
 * img 当前点击进入的图片
 */
typedef PictureViewRenderChild = Widget Function(BuildContext ctx, dynamic item, int index);
typedef PictureViewOnTap = void Function();
typedef PictureViewOnChange = void Function(int current, int total);

class PictureView extends StatefulWidget {

  final String currentImg;
  final List<String> imgs;
  final PictureViewRenderChild renderChild;
  final PictureViewOnTap onTap;
  final PictureViewOnChange onChange;
  final int currentIndex;
  final bool hidePagenation;
  PictureView({
    Key key,
    this.currentImg,
    this.imgs,
    this.renderChild,
    this.onTap,
    this.onChange,
    this.currentIndex = 0,
    this.hidePagenation = false,
  }) : super(key: key);

  @override
  _PictureViewState createState() => _PictureViewState();
}

class _PictureViewState extends State<PictureView> {
  ///图片url集合
  List<String> urlList = [];

  ///当前查看的图片url
  String currentUrl = '';

  ///滚动控制器
  ScrollController _scrollController;

  ///当前图片下标
  int index = 1;
  int length = 1;

  ///触开始的时候的left
  double down = 0.0; 

  ///左右滑动距离是否超过一半
  bool isHalf = false;

  // 初始化
  bool inited = false;

  double mediaWidth = 750;

  @override
  void initState() {
    //页面初始化
    super.initState();
    this.urlList  = new List<String>();
    this.urlList = [];

    this.currentUrl = widget.currentImg;
    this.urlList = widget.imgs;
    length = this.urlList.length;
    index = 0;
    _scrollController = ScrollController(
      initialScrollOffset: 0,
    );
  }

  //下一张
  nextPage(double width) {
    slideTo(index + 1, width);
  }

  //上一张
  lastPage(double width) {
    slideTo(index - 1, width);
  }

  slideTo(int newIndex, [double width, int duration = 200]) {
    if(!mounted) return;
    width = width ?? mediaWidth;
    setState(() {
      index = newIndex;
      if (widget.onChange != null) widget.onChange(index, length);
      animTo(index, width, duration);
    });
  }

  animTo(index, [double width, int duration = 200]) {
    _scrollController.animateTo(
      (index - 1) * width,
      duration: Duration(milliseconds: duration),
      curve: Curves.easeIn,
    );
  }

  //滑动到上一张或下一张
  moveEnd(DragEndDetails event,double width,int length){
    double end = event.primaryVelocity;
    if(end > 10 && index > 1) {
      lastPage(width);
    }else if(end < -10 && index < length){
      nextPage(width);
    }else if(isHalf == true){
      if(this.down > width/2 && index < length) {
        //右边开始滑动超过一半,则下一张
        nextPage(width);
      }else if(this.down < width/2 && index > 1){
        lastPage(width);
      }else {
        animTo(index, width);
      }
    }else {
      animTo(index, width);
    }
  }

  //图片移动
  imgMove(double left,double width,int length) {
    if (!isGoodDragEvent(left)) return;
    //down 为起点
    double now = (this.index -1 ) * width;
    //移动距离
    double move = left - this.down;
    if(left - this.down > width/2 || this.down - left > width/2) {
      this.isHalf = true;
    }else {
      this.isHalf = false;
    }
    _scrollController.jumpTo(now - move);
  }

  /// 双指滑动时会左右横跳,因此把突然较大的偏移量排除掉
  double lastLeft;
  bool isGoodDragEvent(double left) {
    if (lastLeft == null) lastLeft = left;
    double offset = (left - lastLeft).abs();
    lastLeft = left;
    if (offset > 5.0) return false;
    return true;
  }

  Widget list(double width,int length) {
    List<Widget> picList = [];
    for(int i=0 ; i< length;i++){
      Widget item = getOnePicture(width,length,i);
      if (widget.renderChild != null) {
        dynamic img = this.urlList[i];
        item = widget.renderChild(context, img, i);
      }
      item = dragContainer(item);
      picList.add(item);
    }

    return ListView(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      children: picList,
    );
  }

  Widget dragContainer(Widget child) {
    return new GestureDetector(
      onTap: () {
        if (widget.onTap != null) {
          return widget.onTap();
        }
        Navigator.of(context).pop();
      },
      onHorizontalDragDown: (event) {
        this.down = event.globalPosition.dx;
      },
      onHorizontalDragUpdate: (event) {
        double left = event.globalPosition.dx;
        imgMove(left, mediaWidth, this.urlList.length);
      },
      onHorizontalDragEnd: (event) {
        moveEnd(event, mediaWidth, this.urlList.length);
      },
      child: child,
    );
  }

  //一个图片组件
  Widget getOnePicture(double width,int length,int index){
    return new Container(
      width: width,
      child: new ScaleContainer(
        child: makeNetworkImage(
          this.urlList[index],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 无法立即 setState 故而延时一下
    if (!inited) {
      inited = true;
      setTimeout(() {
        if (widget.onChange != null && inited) widget.onChange(index, length);
      }, 200);
    }

    //图片数组长度
    int imgsLength = this.urlList.length;

    Widget pagenation = Positioned(
      top: 30,
      child: Container(
        alignment: Alignment.center,
        width: mediaWidth,
        child: Text(
          '$index/$imgsLength',
          style: TextStyle(
            decoration: TextDecoration.none,
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w400,
            shadows: [
              Shadow(color: Colors.black, offset: Offset(1, 1)),
            ],
          ),
        ),
      ),
    );
    if (widget.hidePagenation) {
      pagenation = new Container();
    }

    return Container(
      color: Colors.black,
      child: Stack(
        children: <Widget>[
          //当前图片
          list(mediaWidth, imgsLength),
          //数字提示
          pagenation,
        ],
      ),
    );
  }
}
