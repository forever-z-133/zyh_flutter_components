import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:zyh_flutter_components/components/photo/photo.dart';
import 'package:zyh_flutter_components/test/small_common_ui.dart';
import './compress_image.dart';

///拍照
Future<File> takePhoto({bool clip = true, String clipRatio = 'NONE'}) async {
  ImagePicker imagePicker = new ImagePicker();
  var image = await imagePicker.getImage(
    source: ImageSource.camera,
    imageQuality: 30,
  );
  File result = new File(image.path);
  result = await CompressImage.image(result, 70);

  if (image != null && image.path != null) {
    if (clip) {
      File newFile = await clipPhoto(image.path, clipRatio: clipRatio);
      if (newFile == null) return null;
      result = newFile;
    }
    return result;
  } else {
    return null;
  }
}

///相册
Future<File> openGallery(content, {bool clip = true, String clipRatio = 'NONE'}) async {
  List<File> files = await openGalleryMult(
    content,
    clip: clip,
    clipRatio: clipRatio,
    maxSelected: 1,
  );
  if (files == null || files.length < 1) return null;
  return files[0];
}

///相册（多选）
Future<List<File>> openGalleryMult(
  BuildContext context, {
  /// 可拍照
  bool withCamera = true,
  /// 是否裁剪
  bool clip = true,
  /// 可选最大数
  int maxSelected = 100,
  /// 裁剪比例
  String clipRatio = 'NONE',
}) async {
  // 选择图片且可拍照
  bool needTakePhoto = false;
  PhotoPreviousBuilder previousBuilder;
  if (withCamera) {
    previousBuilder = (BuildContext context) {
      return new GestureDetector(
        onTap: () {
          needTakePhoto = true;
          Navigator.of(context).pop();
        },
        child: new Container(
          width: 64,
          height: 64,
          color: Colors.white,
          child: new Center(
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                normalIcon('assets/images/message/icon_shoot.png', 50),
                normalText('拍照', 30),
              ],
            ),
          ),
        ),
      );
    };
  }

  // 开启图片选择
  List<AssetEntity> assetList = await PhotoPicker.pickAsset(
    context: context,
    maxSelected: maxSelected,
    padding: 0.5,
    itemRadio: 1,
    rowCount: 4,
    thumbSize: 150,
    provider: I18nProvider.chinese,
    sortDelegate: SortDelegate.common,
    themeColor: Colors.black,
    dividerColor: Colors.grey,
    disableColor: Colors.white,
    textColor: Colors.white,
    checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
      activeColor: Colors.white,
      unselectedColor: Colors.white,
      checkColor: Colors.black,
    ),
    badgeDelegate: const DefaultBadgeDelegate(),
    pickType: PickType.onlyImage,
    previousBuilder: previousBuilder,
  );

  List<File> result = <File>[];

  // 开启拍照，直接返回
  if (needTakePhoto) {
    File image = await takePhoto(clip: clip, clipRatio: clipRatio);
    if (image == null) return null;
    image = await CompressImage.image(image, 70);
    result.add(image);
    return result;
  }

  // 拿到图片选择的数据，处理后返回
  if (assetList == null || assetList.length < 1) return null;
  for (var i = 0; i < assetList.length; i++) {
    File file = await assetList[i].file;
    file = await CompressImage.image(file, 70);
    result.add(file);
  }
  if (clip && result.length == 1) {
    File file = result[0];
    File newFile = await clipPhoto(file.path, clipRatio: clipRatio);
    if (newFile == null) return null;
    result[0] = newFile;
  }
  return result;
}

Map<String, CropAspectRatioPreset> clipRatioConfig = {
  "1:1": CropAspectRatioPreset.square,
  "3:2": CropAspectRatioPreset.ratio3x2,
  "5:3": CropAspectRatioPreset.ratio5x3,
  "4:3": CropAspectRatioPreset.ratio4x3,
  "5:4": CropAspectRatioPreset.ratio5x4,
  "7:5": CropAspectRatioPreset.ratio7x5,
  "16:9": CropAspectRatioPreset.ratio16x9,
  "NONE": CropAspectRatioPreset.original,
};

///剪裁
Future<File> clipPhoto(
  String path, {
  String type = 'rect',
  String clipRatio = 'NONE',
}) async {
  try {
    var cropImage = await ImageCropper.cropImage(
      sourcePath: path,
      cropStyle: type == 'rect' ? CropStyle.rectangle : CropStyle.circle,
      compressQuality: 100,
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: '图片裁剪',
        // activeControlsWidgetColor: AppColor.colorB,
        /// 当裁切圆形图像时不显示九宫格
        showCropGrid: type == 'rect',
        /// 初始裁切块的尺寸比
        initAspectRatio: clipRatioConfig[clipRatio],
        /// 隐藏底部栏,与旋转交互相斥
        // hideBottomControls: true,
        /// 是否可拉伸尺寸比,与缩放交互相斥
        // lockAspectRatio: false,
      ),
    );
    if (cropImage != null && cropImage.path != null) {
      return cropImage;
    } else {
      return null;
    }
  } catch (err) {
    print('裁剪图片挂掉了 $err');
    return new File(path);
  }
}
