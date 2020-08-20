import 'dart:collection';

/// 主题观察者对象（回调函数） 定义了一个动态可选参数
typedef ObserverCallback = void Function([ dynamic param ]);

///一个主题的通知列表,主要是为了确保每个不同的通知可以互相独立出来，根据isNotice属性
class NoticeList<T> {
  ///通知主题
  T notice;

  /// 存放监听函数的集合
  List<NoticeData> listeners;
  List<NoticeData> onceList;

  /// 是否正在发送通知
  bool isNoticing;

  /// 当前主题是否需要复制观察者列表
  bool isConcat;

  NoticeList() {
    this.listeners = [];
    this.isNoticing = false;
    this.isConcat = false;
    this.onceList = null;
  }
}

/// 通知的数据结构对象
class NoticeData<T> {
  /// 通知主题
  T notice;

  /// 监听函数
  Function listener;

  /// 是否只执行一次就删除,默认false
  bool isOnce = false;

  NoticeData(this.listener, this.isOnce);
}

/// 观察者主题，这里是集中多种主题
class Subjects<T> {
  /// 存放监听函数的集合
  HashMap<T, NoticeList> _listenerMap;

  Subjects() {
    this._listenerMap = new HashMap<T, NoticeList>();
  }

  /// 添加一个
  NoticeData _addNoticeData(T notice, Function listener, bool isOnce) {
    NoticeList<T> noticeList = this._listenerMap[notice];
    if (noticeList == null) {
      //可以考虑采用对象池技术
      noticeList = new NoticeList();
      this._listenerMap[notice] = noticeList;
    }
    List<NoticeData> listeners = noticeList.listeners;
    var len = listeners.length;
    //去掉已经注册过的函数
    for (var i = 0; i < len; i++) {
      //必须监听方法和this相等才能决定是同一个监听
      if (listeners[i].listener == listener) return null;
    }
    //是否正在遍历中，如果正在遍历的是这个事件，则进行列表复制
    if (noticeList.isNoticing) {
      //重新赋值
      noticeList.listeners = listeners = listeners.cast();
      noticeList.isNoticing = false;
    }
    //添加新的
    // let noticeData:NoticeData = new NoticeData(listener, thisObj, isOnce);
    NoticeData noticeData = new NoticeData(listener, isOnce);
    listeners.add(noticeData);

    //判断是否一次的，只跑一次的预先添加到一次列表中
    if (isOnce) {
      if (noticeList.onceList == null) {
        noticeList.onceList = [];
        noticeList.onceList.add(noticeData);
      }
    }
    return noticeData;
  }

  /// 删除一个观察者通知
  /// @param notice 通知名称
  /// @param listener 删除指定监听函数，为空则表示删除这个通知下的所有监听函数
  NoticeData off(T notice, Function listener) {
    NoticeList noticeList = this._listenerMap[notice];
    if (noticeList == null) return null;
    List<NoticeData> listeners = noticeList.listeners;
    //是否正在遍历中，如果正在遍历的是这个事件，则进行列表复制，这里可以再进行改成，这样的话，其实只需要复制一次数组就行了
    //增加一个是否需要isConcat的参数
    if (noticeList.isNoticing) {
      //重新赋值
      noticeList.listeners = listeners = listeners.cast();
      //这个标记可以改掉了，因为遍历那边已经不影响listeners了，可以任意的删除和添加啦
      noticeList.isNoticing = false;
    }
    var len = listeners.length;
    NoticeData data;
    for (var i = 0; i < len; i++) {
      data = listeners[i];
      if (data.listener == listener) {
        listeners.removeAt(i);
        //因为添加的时候保证不重复了，所以找到删除之后就立马退出
        return data;
      }
    }
    return null;
  }

  /// 发送主题通知
  void notice(T notice, [dynamic params]) {
    NoticeList noticeList = this._listenerMap[notice];
    if (noticeList == null) return;

    List<NoticeData> listeners = noticeList.listeners;
    //函数注册的调用
    var length = listeners.length;
    //做个标记，防止外部修改原始数组导致遍历错误。这里不直接调用list.concat()因为dispatch()方法调用通常比on()等方法频繁。
    noticeList.isNoticing = true;
    NoticeData data;
    for (var i = 0; i < length; i++) {
      data = listeners[i];
      //这里如果data.listener.apply有操作这个主题，则有可能会出现data不存在的情况
      try {
        if (params != null) data.listener(params);
        else data.listener();
      } catch (e) {
        print(e);
      }
    }
    noticeList.isNoticing = false;
    if (noticeList.onceList != null) {
      List<NoticeData> onceList = noticeList.onceList;
      while (onceList.length != 0) {
        data = onceList.removeAt(0);
        this.off(notice, data.listener);
      }
      noticeList.onceList = null;
    }
    //没有监听者，则进行删除
    if (listeners.length == 0) this._listenerMap.remove(notice);
  }

  /// 添加一个观察者通知
  /// @param notice 通知名称
  /// @param listener 通知监听函数
  NoticeData on(T notice, Function listener) {
    return this._addNoticeData(notice, listener, false);
  }

  /// 监听主题，只监听一次后就会自动删除
  /// @param notice 通知
  /// @param listener 监听函数
  /// @param thisObj listener的类对象
  NoticeData once(T notice, Function listener) {
    return this._addNoticeData(notice, listener, true);
  }
}
