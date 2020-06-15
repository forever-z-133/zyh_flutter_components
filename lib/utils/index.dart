import 'dart:ui';

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

// 响应式单位
Function flexible(designWidth) {
  double winW = window.physicalSize.width / window.devicePixelRatio;
  double rem = winW / designWidth;
  return (num) => num * rem;
}
// 若设计稿为 750，则 px(750) 代表全屏
dynamic px = flexible(750);

// 睡眠
Future sleep(int delay) async {
  return Future.delayed(Duration(milliseconds: delay));
}

// 仿 js 的 setTimeout
void setTimeout(Function callback, int delay) async {
  await sleep(delay);
  callback();
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
