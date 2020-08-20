import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 资源管理，app中获取各种资源都是从这里进行获取
/// 服务器返回的所有结果都是有和服务器约定好的结果和参数内容
class ResManager {
  static ResManager _instance;

  /// 缓存管理插件
  DefaultCacheManager cacheManager = new DefaultCacheManager();

  static ResManager getInstance() {
    if (_instance == null) {
      _instance = new ResManager();
    }
    return _instance;
  }

  /*
   * 创建一个远程图片。每次都是返回一个新的图片对象
   */
  Widget makeNetworkImage(
    String imageUrl, {
    BoxFit fit,
    double width,
    double height,
  }) {
    CachedNetworkImage img = CachedNetworkImage(
      cacheManager: cacheManager,
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      /// 转圈式加载中
      placeholder: (context, url) {
        return new Container(
          width: 40,
          height: 40,
          child: new Center(
            child: CircularProgressIndicator(strokeWidth: 2.0),
          ),
        );
      },
      /// 加载失败
      errorWidget: (context, url, error) {
        cacheManager.removeFile(imageUrl); // 请求失败清掉错误缓存
        return new Container(
          width: 40,
          height: 40,
          child: new Center(
            child: new Icon(Icons.error),
          ),
        );
      },
    );
    return img;
  }
}

Widget makeNetworkImage(
  String imageUrl, {
  BoxFit fit,
  double width,
  double height,
}) {
  return ResManager.getInstance().makeNetworkImage(imageUrl, fit: fit, width: width, height: height);
  // return Image.network(imageUrl, fit: fit, width: width, height: height);
}
