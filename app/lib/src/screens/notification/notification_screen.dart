import 'dart:async';
import 'package:app/src/blocs/notification_bloc.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/models/get_list_notify_response.dart';
import 'package:app/src/screens/notification/notify_dialog.dart';
import 'package:app/src/screens/notification/notify_item.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_segmented_control/material_segmented_control.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../blocs/notification_bloc.dart';
import '../../commonview/loading_progress.dart';
import '../../dataresources/remote/preference_provider.dart';
import '../../dataresources/remote/share_preference_name.dart';
import '../../utils/font_size.dart';
import '../../utils/fonts_name.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Provider<NotificationBloc>.value(
      value: NotificationBloc(
          PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
      child: Consumer<NotificationBloc>(
          builder: (context, bloc, child) => NotificationContent()),
    ));
  }
}

class NotificationContent extends StatefulWidget {
  @override
  _NotificationContentState createState() => _NotificationContentState();
}

class _NotificationContentState extends State<NotificationContent> {
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  NotificationBloc _bloc;
  StreamSubscription _notifySubscription;
  StreamSubscription _notifyDetailSubscription;
  int _type = 0;
  bool _isLoading = false;
  List<Notify> _notifies = [];
  int _lastDataLength = 0;
  int _currentPage = 0;
  int _currentSelection = 0;
  int _limit = 20;
  String _errorString;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _notifyDetailSubscription.cancel();
    _notifySubscription.cancel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = NotificationBloc(PreferenceProvider.getString(SharePrefNames.USER_NAME));
      _isLoading = true;
      _bloc.getListNotify(8, _limit, 1, _type);
      _notifySubscription = _bloc.loadListNotifyStream.listen((onData) {
        _isLoading = false;
        if (mounted) {
          if (_currentPage == 0) {
            _refreshController.refreshCompleted();
          }
          setState(() {
            _notifies.addAll(onData);
          });
          _lastDataLength = onData.length;
          if (_lastDataLength > 0) {
            print("page:  $_currentPage");
            _currentPage++;
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        }
      });
      _notifySubscription.onError((handleError) {
        _isLoading = false;
        _errorString = handleError.toString();
        _refreshController.refreshCompleted();
      });
      //notify detail response data
      _notifyDetailSubscription = _bloc.loadNotifyDetailStream.listen((onData) {
        if (onData != null) {
          showDialog(
              context: context,
              builder: (_) => NotifyDialog(
                    id: onData.sId,
                    context: context,
                    bloc: _bloc,
                    detail: onData,
                  ));
        }
      });
      _notifyDetailSubscription.onError((handleError) {
        _isLoading = false;
        _errorString = handleError.toString();
        _refreshController.refreshCompleted();
      });
    }
  }

  final Map<int, Widget> _segmentTitleUnselected = const <int, Widget>{
    0: Text(
      "Tất cả",
      style: TextStyle(
        fontFamily: FontsName.textHelveticaNeueBold,
        fontSize: FontsSize.large,
      ),
    ),
    1: Text("Quan trọng",
        style: TextStyle(
          fontFamily: FontsName.textHelveticaNeueBold,
          fontSize: FontsSize.large,
        )),
  };

  @override
  Widget build(BuildContext context) {
    print(_notifies.length);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: MaterialSegmentedControl(
                  children: _segmentTitleUnselected,
                  selectionIndex: _currentSelection,
                  borderColor: ColorData.colorTwo,
                  selectedColor: ColorData.primaryColor,
                  unselectedColor: Colors.white,
                  borderRadius: 32.0,
                  disabledChildren: [
                    3,
                  ],
                  onSegmentChosen: (index) {
                    setState(() {
                      _currentSelection = index;
                      _currentPage = 0;
                      _notifies = [];
                      _isLoading = true;
                      if (_currentSelection == 0) {
                        _type = 0;
                        _bloc.getListNotify(8, _limit, 1, _type);
                      } else {
                        _type = 1;
                        _bloc.getListNotify(8, _limit, 1, _type);
                      }
                    });
                  },
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(
                      complete: Text("Tải dữ liệu thành công",
                          style: TextStyle(
                              fontSize: 14, color: ColorData.primaryColor)),
                      failed: Text(
                        "Tải dữ liệu thất bại vui lòng thử lại",
                        style:
                            TextStyle(color: ColorData.colorsRed, fontSize: 14),
                      ),
                    ),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                          body = Text("Đang tải");
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                          body = Text("Tải dữ liệu thất bại vui lòng thử lại");
                        } else if (mode == LoadStatus.canLoading) {
                          body = Text("Thả để tải dữ liệu");
                        } else {
                          body = Text("Hết dữ liệu");
                        }
                        return Container(
                          height: 55.0,
                          child: Center(child: body),
                        );
                      },
                    ),
                    controller: _refreshController,
                    onRefresh: _onRefresh,
                    onLoading: _onLoadMore,
                    child: _buildListNotify()),
              ),
            ),
          ],
        ));
  }

  Widget _buildListNotify() {
    if (_isLoading) {
      return LoadingProgress();
    } else {
      return _notifies.length != 0
          ? ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: _notifies.length != 0 ? _notifies.length : 0,
              itemBuilder: (context, index) => NotifyItem(
                    notifies: _notifies,
                    onNotifyClick: (id) => _bloc.getDetailNotify(id),
                    index: index,
                  ))
          : Container(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "$_errorString",
                textAlign: TextAlign.center,
              ),
            );
    }
  }

  void _onLoadMore() async {
    _bloc.getListNotify(8, _limit, _currentPage, _type);
  }

  void _onRefresh() async {
    _currentPage = 0;
    _notifies = [];
    _bloc.getListNotify(8, _limit, 1, _type);
    setState(() {
      _isLoading = true;
    });
  }
}
