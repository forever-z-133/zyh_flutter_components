typedef GetListDataCallback = void Function(List data, [ int total ]);
typedef GetListDataFunction = void Function(Map<String, dynamic> params, GetListDataCallback next);

enum ListStatus {
  LOADING, /// 加载中
  NODATA, /// 无数据
  EMPTY, /// 数据已全部获取
  WAIT, /// 等待中
}

class ListManager {
  /// 当前的页码
  int currentPage;
  /// 当前的总数
  int currentTotal;
  /// 当前的数据数组
  List data = [];
  /// 当前状态
  ListStatus status = ListStatus.WAIT;
  /// 请求列表的方法
  final GetListDataFunction ajax;
  /// 初始化的页码
  final int page;
  /// 初始化的数量
  final int size;
  /// 需要触发视图变化时
  final Function dataChange;
  /// 在 refresh 或 update 临时增加的回调
  Function tempCallBack;

  ListManager(this.ajax, {
    this.page = 1,
    this.size = 10,
    this.dataChange,
  }) {
    currentPage = page;
  }

  /// 重新刷新
  void refresh([ Function cb, Map<String, dynamic> moreParams ]) {
    currentPage = page;
    data.clear();
    status = ListStatus.WAIT;
    update(cb, moreParams);
  }

  /// 更新下一页
  void update([ Function cb, Map<String, dynamic> moreParams ]) {
    if (status != ListStatus.WAIT) return;
    status = ListStatus.LOADING;
    _whenDataChange();

    Map<String, dynamic> params = {};
    params['page'] = currentPage;
    params['size'] = size;
    params.addAll(moreParams ?? {});
    params = beforeAjax(params);

    tempCallBack = cb;
    ajax(params, ajaxFinish);
  }

  /// 请求前，可修改 params 入参里的值
  Map<String, dynamic> beforeAjax(Map<String, dynamic> params) {
    return params;
  }

  /// 请求结束，获取到数据
  void ajaxFinish(List newData, [ int total ]) {
    data.addAll(newData);
    if (newData.length < 1 && currentPage <= page) {
      // 无数据
      status = ListStatus.NODATA;
    } else if (total != null && total < data.length) {
      // 已加载数据超出总数，则为全部已加载
      status = ListStatus.EMPTY;
      data = data.sublist(0, total);
    } else if (newData.length < size) {
      // 刚加载数据不足一页，也为全部已加载
      status = ListStatus.EMPTY;
    } else {
      // 等待继续加载下一页
      status = ListStatus.WAIT;
      currentPage += 1;
    }
    _whenDataChange(true);
  }

  void _whenDataChange([ bool isAjaxFinish = false ]) {
    if (isAjaxFinish && tempCallBack != null) tempCallBack();
    dataChange();
  }
}
