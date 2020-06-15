import 'dart:convert';
import 'package:flutter/services.dart';

enum ChannelMethods {
  setAppIconNumber,
  addAppIconNumber,
  removeAppIconNumber,
}

class ChannelManager {
  static const MethodChannel _channel = const MethodChannel('zyh.flutter.common');

  /// 发起事件
  static trigger(ChannelMethods method, [params]) async {
    String methodName = method.toString();
    Map args = { "params": "" };
    if (params != null) {
      params = jsonEncode(params);
      args = { "params": params };
    }
    Map result;
    try {
      String res = await _channel.invokeMethod(methodName, args);
      result = jsonDecode(res);
    } catch(err) {}
    return result;
  }
}
