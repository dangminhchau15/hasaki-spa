import 'dart:async';
import 'package:app/src/blocs/consultant_bloc.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/models/consultant_response.dart';
import 'package:app/src/screens/consultant/create_consultant_screen.dart';
import 'package:app/src/screens/consultant/widgets/consultant_form_header.dart';
import 'package:app/src/screens/consultant/widgets/consultant_row.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/debouncer.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ConsultantScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: CustomAppBar(title: "Tư vấn"),
        body: Provider<ConsultantBloc>.value(
          value: ConsultantBloc(
              PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
          child: Consumer<ConsultantBloc>(
              builder: (context, bloc, child) => ConsultantScreenContent()),
        ));
  }
}

class ConsultantScreenContent extends StatefulWidget {
  @override
  _ConsultantScreenContentState createState() =>
      _ConsultantScreenContentState();
}

class _ConsultantScreenContentState extends State<ConsultantScreenContent> {
  final _controller = TextEditingController();
  ConsultantBloc _bloc;
  bool _isLoading = false;
  String _errorString = "";
  StreamSubscription _consultantSubscription;
  StreamSubscription _loadingStream;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Consultant> _consultants = [];
  DateTime _selectedDate = DateTime.now();
  int _lastDataLength = 0;
  int _currentPage = 0;
  int _offset = 0;
  int _limit = 20;
  String _fromDate = "";
  String _customerPhone = "";
  int _status = 0;

  @override
  void initState() {
    _fromDate = "${_selectedDate.toLocal()}".split(' ')[0];
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ConsultantScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      print(_fromDate);
      _bloc = ConsultantBloc(PreferenceProvider.getString(SharePrefNames.USER_NAME));
      _loadingStream = apiSubscription(_bloc.loadingStream, context, null);
      _bloc.getConsultants(_customerPhone, _fromDate, _limit, _offset, _status);
      _consultantSubscription = _bloc.loadListConsultantStream.listen((onData) {
        if (mounted) {
          if (_currentPage == 0) {
            _refreshController.refreshCompleted();
          }
          setState(() {
            _consultants.addAll(onData);
          });
          _lastDataLength = onData.length;
          if (_lastDataLength > 0) {
            print("page:  $_currentPage");
            _currentPage++;
            _offset = _currentPage * _limit;
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _refreshController.dispose();
    _consultantSubscription.cancel();
    super.dispose();
  }

  void _onLoadMore() async {
    print(_currentPage);
    _bloc.getConsultants(_customerPhone, _fromDate, _limit, _offset, _status);
  }

  void _onRefresh() async {
    _currentPage = 0;
    _consultants = [];
    _bloc.getConsultants(_customerPhone, _fromDate, _limit, 0, _status);
    setState(() {
      _isLoading = true;
    });
  }

  Widget _buildListConsultants(int index) {
    return ExpandableNotifier(
        child: Padding(
      padding: const EdgeInsets.all(10),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: <Widget>[
            ScrollOnExpand(
              scrollOnExpand: true,
              scrollOnCollapse: false,
              child: ExpandablePanel(
                theme: const ExpandableThemeData(
                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                  tapBodyToCollapse: true,
                ),
                header: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        _buildHeaderRow(
                            "Mã: ", _consultants[index].code.toString()),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow(
                            "Ngày tháng: ", _consultants[index].createdAt),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow("Họ tên: ",
                            _consultants[index].customer.customerName),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow("Số điện thoại: ",
                            _consultants[index].customer.customerPhone),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Trạng thái: ",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily:
                                      FontsName.textHelveticaNeueRegular),
                            ),
                            _buildStatus(_consultants[index].status.toString())
                          ],
                        )
                      ],
                    )),
                expanded: ConsultantRow(
                  consultants: _consultants,
                  index: index,
                ),
                builder: (_, collapsed, expanded) {
                  return Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Expandable(
                      collapsed: collapsed,
                      expanded: expanded,
                      theme: const ExpandableThemeData(crossFadePoint: 0),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildStatus(String status) {
    switch (status) {
      case "1":
        return Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0), color: Colors.orange),
          child: Center(
            child: Text(
              "Pending",
              style: TextStyle(
                  fontFamily: FontsName.textHelveticaNeueRegular,
                  fontSize: FontsSize.normal,
                  color: ColorData.colorsWhite),
            ),
          ),
        );
        break;
      case "2":
        return Container(
          width: 80,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: ColorData.primaryColor),
          child: Center(
            child: Text(
              "Completed",
              style: TextStyle(
                  fontFamily: FontsName.textHelveticaNeueRegular,
                  fontSize: FontsSize.normal,
                  color: ColorData.colorsWhite),
            ),
          ),
        );
        break;
    }
    return Container();
  }

  Widget _buildHeaderRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
        ),
        Text(
          value,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorData.colorsBlack,
              fontFamily: FontsName.textHelveticaNeueBold),
        ),
      ],
    );
  }

  void _navigateToNexScreen() async {
    var result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CreateConsultantScreen(),
    ));
    if (result != null) {
      _onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return true;
            },
            child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: true,
                header: WaterDropHeader(
                  complete: Text("Tải dữ liệu thành công",
                      style: TextStyle(
                          fontSize: 14, color: ColorData.primaryColor)),
                  failed: Text(
                    "Tải dữ liệu thất bại vui lòng thử lại",
                    style: TextStyle(color: ColorData.colorsRed, fontSize: 14),
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
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        ConsultanFormHeader(
                            onSearchConsultant: (date, phone, status) {
                          setState(() {
                            _isLoading = true;
                            _consultants = [];
                            _fromDate = date != "Time booking" ? date : "";
                            _status = status;
                            _bloc.getConsultants(
                              phone,
                              _fromDate,
                              _limit,
                              0,
                              status,
                            );
                          });
                        }),
                      ]),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: _buildListConsultants(index),
                        );
                      },
                          childCount: _consultants.length > 0
                              ? _consultants.length
                              : 0),
                    )
                  ],
                )),
          )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorData.primaryColor,
        child: Icon(
          Icons.arrow_right_alt,
          color: ColorData.colorsWhite,
        ),
        onPressed: () {
          _navigateToNexScreen();
        },
      ),
    );
  }
}
