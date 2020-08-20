import 'dart:math' as math;
import 'dart:async';
import 'dart:ui';

// 响应式单位
Function flexible(designWidth) {
  double winW = window.physicalSize.width / window.devicePixelRatio;
  double rem = winW / designWidth;
  return (num) => num * rem;
}
// 若设计稿为 750，则 px(750) 代表全屏
dynamic px = flexible(750);

/// 将手机号 13800000000 改为 138****0000
String getSecretPhone(dynamic phone) {
  String phoneStr = (phone == null || phone == 0 || phone == '') ? '' : phone.toString();
  if (phoneStr == '') return '';
  return phoneStr.substring(0, 3) + '****' + phoneStr.substring(7, 11);
}

/// 判断是否为空，包括 Map String List 的空
bool isEmpty(Object object) {
  if (object == null) return true;
  if (object is String && object.isEmpty) {
    return true;
  } else if (object is Iterable && object.isEmpty) {
    return true;
  } else if (object is Map && object.isEmpty) {
    return true;
  }
  return false;
}
bool isNotEmpty(Object object) {
  return !isEmpty(object);
}

/// 仿 js 的 Array.some 方法
bool arraySome(List arr, Function func) {
  for (var item in arr) {
    bool isTrue = func(item);
    if (isTrue) return true;
  }
  return false;
}

/// 仿 js 的 Array.join 方法
String arrayJoin(List arr, [String divide = ',']) {
  if (arr == null || arr.length < 1) return '';
  String result = '';
  for (int i=0; i<arr.length; i++) {
    result = result + divide + arr[i].toString();
  }
  result = result.substring(1);
  return result;
}

/// 用于钱币识别的文字匹配功能
bool contains(item, flag) {
  if (flag is RegExp) {
    return flag.hasMatch(item);
  }
  if (flag is String) {
    item = item.toLowerCase();
    flag = flag.toLowerCase();
    return item.contains(flag);
  }
  //后期加上可容错 1-2 个字符。
  return false;
}

// 睡眠
Future sleep(int delay) async {
  return Future.delayed(Duration(milliseconds: delay));
}

// 仿 js 的 setTimeout
setTimeout(Function callback, int delay) async {
  await sleep(delay);
  callback();
}

/// 处理多个请求同时运行的情况。
/// 优于逐个请求，也避免 for 多个问题，用 Future.any 报错难查，故而使用此方案
void forEachAsync(List data, Function func, { int number, Function finish }) {
  int times = number ?? 5;
  int maxTimes = times.clamp(1, 8); // 最大线程数 8，默认为 5
  int total = data.length - 1;
  List result = new List(data.length);

  int restQueue = maxTimes; // 剩余队列数
  int started = 0; // 已发起
  int loaded = 0; // 已完成

  // 全部运行完成
  void _finish(result) {
    if (finish != null) {
      finish(result);
    }
  }

  // 队列空闲则递归
  dynamic loop(int index) {
    void next(res) {
      restQueue++;
      result.fillRange(index, index + 1, res);
      if (++loaded > total) _finish(result);
      else loop(++started);
    }
    if (index > total) return null;
    dynamic item = data[index];
    Map<String, dynamic> postData = { 'index': index, 'item': item, 'next': next };
    func(postData);
    if (--restQueue > 0) loop(++started);
  }

  loop(0);
}

// 针对 utf-16 写的公共方法
int getStringLength(String str) {
  List<String> strList = str.runes.map((rune) => new String.fromCharCode(rune)).toList();
  return strList.length;
}
String stringSlice(String str, int start, [int end]) {
  List<String> strList = str.runes.map((rune) => new String.fromCharCode(rune)).toList();
  if (end != null && end < 0) end = strList.length + end;
  if (end != null) end = end.clamp(0, strList.length);
  return strList.sublist(start, end).join("");
}

/// 生成随机字符串
String ramdomId([int len = 10]) {
  String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
  String result = '';
  for (var i = 0; i < len; i++) {
    result = result + alphabet[math.Random().nextInt(alphabet.length)];
  }
  return result;
}

/// 仿 js 的 Promise.all，多个异步齐跑，一起处理结果
/// 使用方法 promiseAll([ajax1(), ajax2()]).then((List resArr) {});
Future<List<dynamic>> promiseAll(List<Future> queue, [Function callback]) async {
  int total = queue.length;
  Map<Future, int> indexMap = {};
  List<dynamic> result = new List(total);
  for (int i = 0; i < total; i++) {
    Future promise = queue[i];
    indexMap[promise] = i;
    dynamic value = await promise;
    int index = indexMap[promise];
    result[index] = value;
  }
  if (callback != null) callback(result);
  return result;
}

/// 生成范围内的随机数
double random(num n1, [ num n2 = 0 ]) {
  num min = math.min(n1, n2);
  num max = math.max(n1, n2);
  double _random = math.Random().nextDouble();
  return min + _random * (max - min);
}
int randomInt(num n1, [ num n2 = 0 ]) {
  return random(n1, n2).toInt();
}
