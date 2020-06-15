import 'package:connectivity/connectivity.dart';

class Network {
  /// 获取网络类型
  static getNetType() async {
    ConnectivityResult netType = await (Connectivity().checkConnectivity());
    return netType;
  }
}
