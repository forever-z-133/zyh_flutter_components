import 'package:flutter/material.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';

class WaterFall extends StatefulWidget {
  @override
  _WaterFallState createState() => new _WaterFallState();
}
class _WaterFallState extends State<WaterFall> {
  List<Widget> list = [];

  @override
  void initState() {
    super.initState();
    int i = 0;
    new List(50).forEach((e) => list.add(_item(++i)));
  }
  
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          normalText('top'),
          new Expanded(
            child: RefreshIndicator(
              onRefresh: () async {},
              child: _list(),
            ),
          ),
          normalText('bottom'),
        ],
      ),
    );
  }

  Widget _list() {
    // return new ListView.separated(
    //   itemCount: list.length,
    //   itemBuilder: (ctx, index) => list[index],
    //   separatorBuilder: (ctx, index) => Divider(color: Colors.red),
    // );
    // return CustomScrollView(
    //   slivers: <Widget>[
    //     SliverAppBar(
    //       pinned: true,
    //       floating: true,
    //       expandedHeight: 200.0,
    //       // stretchTriggerOffset: 1,
    //       flexibleSpace: FlexibleSpaceBar(
    //         title: Text('复仇者联盟'),
    //         // titlePadding: EdgeInsets.all(0),
    //         background: Image.network(
    //           'http://img.haote.com/upload/20180918/2018091815372344164.jpg',
    //           fit: BoxFit.cover,
    //         ),
    //       ),
    //     ),
    //     SliverFixedExtentList(
    //       itemExtent: 80.0,
    //       delegate: SliverChildBuilderDelegate(
    //         (BuildContext context, int index) {
    //           return list[index];
    //         },
    //       ),
    //     ),
    //   ],
    // );
    return GridView.count(
      crossAxisCount: 3,
      childAspectRatio: 2,
      children: List.generate(500, (i) => new Text('$i')),
    );
  }

  Widget _item(int i) {
    return new Container(
      padding: EdgeInsets.all(5),
      child: normalText('文本 $i'),
    );
  }
}
