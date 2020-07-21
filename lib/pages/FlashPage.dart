import 'package:flutter/cupertino.dart';
import 'package:zyh_flutter_components/components/Flash.dart';
import 'package:zyh_flutter_components/components/SkeletonItem.dart';

class FlashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FlashWrap(
      child: Column(
          children: List.generate(
        5,
        (index) => ArticleSkeletonItem(index: index),
      )),
    ));
  }
}
