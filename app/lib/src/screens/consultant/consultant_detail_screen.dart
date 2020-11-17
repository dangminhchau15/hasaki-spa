import 'dart:async';
import 'package:app/src/blocs/consultant_bloc.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/models/consultant_response.dart';
import 'package:app/src/models/create_consultant_response.dart';
import 'package:app/src/screens/consultant/add_receipt_screen.dart';
import 'package:app/src/screens/consultant/widgets/consultant_row.dart';
import 'package:app/src/screens/consultant/widgets/header_avartar.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ConsultantDetailScreen extends StatelessWidget {
  String name;
  String phone;
  int customerId;

  ConsultantDetailScreen({this.name, this.phone, this.customerId});

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
              builder: (context, bloc, child) => ConsultantDetailContentScreen(
                    name: name,
                    phone: phone,
                    customerId: customerId,
                  )),
        ));
  }
}

class ConsultantDetailContentScreen extends StatefulWidget {
  String name;
  String phone;
  int customerId;
  int consultantId;

  ConsultantDetailContentScreen(
      {this.name, this.phone, this.customerId, this.consultantId});

  @override
  _ConsultantDetailContentScreenState createState() =>
      _ConsultantDetailContentScreenState();
}

class _ConsultantDetailContentScreenState
    extends State<ConsultantDetailContentScreen> {
  String _name;
  String _phone;
  int _customerId;
  List<Consultant> _consultants = [];
  StreamSubscription _consultantSubscription;
  StreamSubscription _createConsultantSubscription;
  StreamSubscription _loadingStream;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  DateTime _selectedDate = DateTime.now();
  int _lastDataLength = 0;
  int _currentPage = 0;
  int _limit = 5;
  ConsultantBloc _bloc;
  bool _isLoading = false;
  String _errorString = "";
  String _date = "";

  @override
  void initState() {
    super.initState();
    _date = "${_selectedDate.toLocal()}".split(' ')[0];
    _name = widget?.name;
    _phone = widget?.phone;
    _customerId = widget?.customerId;
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _consultantSubscription.cancel();
  }

  void _moveToNextScreen(CreateConsultantResponse onData) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AddReceiptScreen(
              name: _name,
              phone: _phone,
              customerId: _customerId,
              consultantId: onData.data.consultant.id,
            )));
    if (result != null) {
      _bloc.getConsultants(_phone, _date, _limit, 0, 0);
      setState(() {
        _consultants = [];
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bloc == null) {
      _bloc = ConsultantBloc(PreferenceProvider.getString(SharePrefNames.USER_NAME));
      _loadingStream = apiSubscription(_bloc.loadingStream, context, null);
      _bloc.getConsultants(_phone, _date, _limit, 0, 0);
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
            _refreshController.loadComplete();
          } else {
            _refreshController.loadNoData();
          }
        }
      });
      _consultantSubscription.onError((handleError) {
        _errorString = handleError.toString();
        _refreshController.refreshCompleted();
      });
      //create consultant api
      _createConsultantSubscription =
          _bloc.createConsultantStream.listen((onData) {
        _moveToNextScreen(onData);
      });
      _createConsultantSubscription.onError((handleError) {
        _errorString = handleError.toString();
        _refreshController.refreshCompleted();
      });
    }
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  HeaderAvartar(
                    size: size,
                    phone: _phone,
                    name: _name,
                    customerId: _customerId,
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SmartRefresher(
                          enablePullDown: true,
                          enablePullUp: true,
                          header: WaterDropHeader(
                            complete: Text("Tải dữ liệu thành công",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: ColorData.primaryColor)),
                            failed: Text(
                              "Tải dữ liệu thất bại vui lòng thử lại",
                              style: TextStyle(
                                  color: ColorData.colorsRed, fontSize: 14),
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
                                body = Text(
                                    "Tải dữ liệu thất bại vui lòng thử lại");
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
                          onLoading: () {
                            _refreshController.loadNoData();
                          },
                          child: ListView.builder(
                              itemCount: _consultants.length > 0
                                  ? _consultants.length
                                  : 0,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) =>
                                  _buildListConsultants(index))),
                    ),
                  )
                ],
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bloc.createConsultant(_customerId);
        },
        backgroundColor: ColorData.primaryColor,
        child: Icon(
          Icons.arrow_right_alt,
          color: ColorData.colorsWhite,
        ),
      ),
    );
  }

  void _onRefresh() async {
    _currentPage = 0;
    _consultants = [];
    _bloc.getConsultants(_phone, _date, _limit, 0, 0);
    setState(() {
      _isLoading = true;
    });
  }
}
