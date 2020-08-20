import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

///本地持久化键值存储
class SaveDataUtil {
  ///存储Bool
  saveBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  ///存储Int
  saveInteger(String key, int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  ///存储Double
  saveDouble(String key, double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  ///存储String
  saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  ///存储StringList
  saveStringList(String key, List<String> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  ///取出bool
  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key);
    return value;
  }

  ///取出Int
  Future<int> getInteger(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(key);
    return value;
  }

  ///取出double
  Future<double> getDouble(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double value = prefs.getDouble(key);
    return value;
  }

  ///取出String
  Future<String> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  ///取出StringList
  Future<List<String>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> value = prefs.getStringList(key);
    return value;
  }

  ///移除数据
  removeLocalData(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}

//文件相关操作
class SaveFileDateUtil {
  ///获取本地文件路径(文档目录)
  Future<String> getLocalPath() async {
    String path = (await getApplicationDocumentsDirectory()).path;
    return path;
  }

  ///获取本地文件路径(临时目录,常用)
  Future<String> getLocalTemporaryPath() async {
    String path = (await getTemporaryDirectory()).path;
    return path;
  }

  ///获取本地文件路径(外部目录，仅限安卓端)
  Future<String> getLocalExternalPath() async {
    String path = (await getExternalStorageDirectory()).path;
    return path;
  }

  ///创建文件位置引用
  createLocalFile(String path, String fileName) async {
    print('createLocalFile: $path/$fileName');
    return new File('$path/$fileName');
  }

  ///读取json文件(文档目录),文件名xx.json
  Future<Map<String, Object>> readJsonContent(String fileName) async {
    try {
      final File file =
          await createLocalFile(await getLocalTemporaryPath(), fileName);
      var isExist = await file.exists();
      if (!isExist) {
        return null;
      } else {
        String str = await file.readAsString();
        Map<String, Object> obj = json.decode(str);
        print('readJsonContent: $file');
        print('readJsonContent: $obj');
        return obj;
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  ///写入json文件(文档目录)
  writeJsonContent(Object obj, String fileName) async {
    try {
      final File file =
          await createLocalFile(await getLocalTemporaryPath(), fileName);
      String str = json.encode(obj);
      file.writeAsString(str);
      print('writeJsonContent: $file');
      print('writeJsonContent: $str');
    } catch (err) {
      print(err);
    }
  }

  ///读取文本文件
  Future readContent(String fileName) async {
    try {
      final File file =
          await createLocalFile(await getLocalTemporaryPath(), fileName);
      String str = await file.readAsString();
      print('readContent: $file');
      print('readContent: $str');
      return str;
    } catch (err) {
      print(err);
    }
  }

  ///写入文本文件
  writeContent(String str, String fileName) async {
    try {
      final File file =
          await createLocalFile(await getLocalTemporaryPath(), fileName);
      file.writeAsString(str);
      print('writeContent: $file');
    } catch (err) {
      print(err);
    }
  }

  ///写入文本文件（会生成实体文件）
  writeContentLocal(String str, String fileName) async {
    try {
      Directory appDocDir = await getExternalStorageDirectory();
      final File file = await createLocalFile(appDocDir.path, fileName);
      file.writeAsString(str);
      print('writeContent: $file');
    } catch (err) {
      print(err);
    }
  }
}
