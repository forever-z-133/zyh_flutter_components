
import 'dart:io';
import 'package:flutter_native_image/flutter_native_image.dart';

/*
 * 图片压缩
 * CompressImage.image(file);
 * CompressImage.images(files);
 */
class CompressImage {
  /// 起始压缩大小
  static int minSize = 3 * 1024 * 1024;
  /// 最大压缩大小
  static int maxSize = 10 * 1024 * 1024;
  /// 最大压缩品质（比如压缩到30%）
  static int minQuality = 30;
  /// 起始压缩品质
  static int maxQuality = 100;
  
  /// 压缩单张图片
  static Future<File> image(File img, [int customQuality]) async {
    int quality = 0;
    int fileSize = img.statSync().size;
    if (customQuality == null) {
      // 不固定压缩品质的话，按特殊计算求压缩品质
      // 大于起始压缩大小才开始压缩，尺寸越大越压缩，超过约定最大尺寸则保持最大压缩品质
      if (fileSize < minSize) return img;
      fileSize = fileSize.clamp(minSize, maxSize);
      quality = maxQuality - (fileSize ~/ (1024 * 1024) * 10) + minQuality;
    } else {
      // 固定压缩品质，本插件效果较好，推荐 90
      quality = customQuality;
    }
    quality = quality.clamp(0, 100);
    File compressImage;
    try {
      compressImage = await FlutterNativeImage.compressImage(img.path, quality: quality);
      int newFileSize = compressImage.statSync().size;
      print('压缩图片： ${img.path} 保持质量： $quality 尺寸： $fileSize 新尺寸： $newFileSize');
    } catch(err) {
      compressImage = img;
      print('压缩图片： ${img.path} 压缩失败');
    }
    return compressImage;
  }
  /// 压缩多张图片
  static Future<List<File>> images(List<File> imgList, [int customQuality]) async {
    List<File> result = new List();
    for (File img in imgList) {
      File compressImage = await image(img, customQuality);
      result.add(compressImage);
    }
    return result;
  }
}
