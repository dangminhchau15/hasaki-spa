import 'dart:async';

import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/receipt_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/commonview/extension_widget.dart';
import 'package:app/src/commonview/loading_progress.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_list_store_event_success.dart';
import 'package:app/src/eventstate/receipt_list_event.dart';
import 'package:app/src/eventstate/receipt_list_event_success.dart';
import 'package:app/src/eventstate/search_user_event.dart';
import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/receipt_list_response.dart';
import 'package:app/src/screens/consultant/widgets/receipt_item.dart';
import 'package:app/src/screens/receipt/widgets/receipt_item.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ReceiptScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Danh sách biên nhận"),
      body: Provider<ReceiptBloc>.value(
        value: ReceiptBloc(
            PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
        child: Consumer<ReceiptBloc>(
          builder: (context, bloc, child) => ReceiptScreenContent(
            bloc: bloc,
          ),
        ),
      ),
    );
  }
}

class ReceiptScreenContent extends StatefulWidget {
  final ReceiptBloc bloc;

  ReceiptScreenContent({this.bloc});

  @override
  _ReceiptScreenContentState createState() => _ReceiptScreenContentState();
}

class _ReceiptScreenContentState extends State<ReceiptScreenContent> {
  ReceiptBloc _bloc;
  StreamSubscription _receiptListSubscription;
  StreamSubscription _loadingStream;
  DateTime _selectStartDate = DateTime.now();
  DateTime _selectEndDate = DateTime.now();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _staffId = 0;
  String _startDate = "";
  String _endDate = "";
  String _phone = "";
  String _code = "";
  String _staffName = "";
  String _itemType = "--chọn loại--";
  String _itemStatus = "--chọn trạng thái--";
  String _itemBalace = "--chọn số dư--";
  final TextEditingController typeAheadController = TextEditingController();
  List<ReceiptList> _receiptList = [];
  List<Store> _stores = [];
  int _limit = 20;
  int _currentPage = 0;
  int _lastDataLength = 0;
  int _offset = 0;
  String _receiptBalance = "10000";
  int _receiptType = 0;
  int _status = 0;
  bool _isLoading = false;
  bool _isItemSelected = false;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
    _bloc.event.add(GetListStoreEvent());
    _startDate = "${_selectEndDate.toLocal()}".split(' ')[0];
    _endDate = "${_selectEndDate.toLocal()}".split(' ')[0];
    _loadingStream = apiSubscription(_bloc.loadingStream, context, null);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    // _loadingStream.cancel();
    _receiptListSubscription.cancel();
    typeAheadController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _receiptListSubscription = _bloc.loadReceiptListStream.listen((onData) {
      if (mounted) {
        if (_currentPage == 0) {
          _refreshController.refreshCompleted();
        }
        setState(() {
          _receiptList.addAll(onData);
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

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<ReceiptBloc>(
        listener: _handleEvent,
        child: Scaffold(
          body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropHeader(
                complete: Text("Tải dữ liệu thành công",
                    style:
                        TextStyle(fontSize: 14, color: ColorData.primaryColor)),
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
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildStartDateField(),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: _buildEndDatePickerField(),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: _buildPhoneField(),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: _buildCodeField(),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: combobox([
                                  "--chọn loại--",
                                  "Loại: Thanh Toán",
                                  "Loại: Dịch Vụ"
                                ], size, 0.3, _itemType, context, (value) {
                                  switch (value) {
                                    case "--chọn loại--":
                                      _receiptType = 0;
                                      break;
                                    case "Loại: Thanh Toán":
                                      _receiptType = 1;
                                      break;
                                    case "Loại: Dịch Vụ":
                                      _receiptType = 2;
                                      break;
                                  }
                                }),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: combobox([
                                  "--chọn trạng thái--",
                                  "Trạng thái: Chờ xử lý",
                                  "Trạng thái: Hoàn tất"
                                ], size, 0.3, _itemStatus, context, (value) {
                                  switch (value) {
                                    case "--chọn trạng thái--":
                                      _status = 0;
                                      break;
                                    case "Trạng thái: Chờ xử lý":
                                      _status = 1;
                                      break;
                                    case "Trạng thái: Hoàn tất":
                                      _status = 2;
                                      break;
                                  }
                                }),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          combobox([
                            "--chọn số dư--",
                            "Balance: >10,000",
                          ], size, 0.3, _itemBalace, context, (value) {
                            if (value == "Balance: >10,000") {
                              _receiptBalance = "10000";
                            }
                          }),
                          SizedBox(height: 10),
                          _buildUserAutoComplete(),
                          SizedBox(height: 10),
                          ButtonColorNormal(
                            content: Text(
                              "Tìm kiếm",
                              style: TextStyle(
                                  fontFamily: FontsName.textHelveticaNeueBold,
                                  color: ColorData.colorsWhite,
                                  fontSize: 14),
                            ),
                            colorData: ColorData.primaryColor,
                            onPressed: () {
                              _receiptList = [];
                              _bloc.getReceiptList(ReceiptListEvent(
                                  dataCustomer: 1,
                                  total: 1,
                                  limit: _limit,
                                  offset: 0,
                                  customerPhone: _phone,
                                  receiptBalance: _receiptBalance,
                                  receiptCode: _code,
                                  receiptType: _receiptType,
                                  status: _status,
                                  userId: _staffId.toString(),
                                  fromDate: _startDate,
                                  toDate: _endDate));
                              setState(() {
                                _isLoading = true;
                              });
                            },
                          ),
                        ],
                      )
                    ]),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return _buildListReceipt(index);
                    },
                        childCount: _receiptList.length != null
                            ? _receiptList.length
                            : 0),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildHeaderRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
          ),
        ),
        Text(
          value,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          softWrap: true,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: ColorData.colorsBlack,
            fontFamily: FontsName.textHelveticaNeueBold,
          ),
        ),
      ],
    );
  }

  Widget _buildListReceipt(int index) {
    final _dateFormat = new DateFormat('yyyy-MM-dd HH:mm');
    var convertTimeStampToCDate = DateTime.fromMillisecondsSinceEpoch(
        _receiptList[index].receiptCdate * 1000);
    var convertTimeStampToUDate = DateTime.fromMillisecondsSinceEpoch(
        _receiptList[index].receiptUdate * 1000);

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
                            "Ngày tạo: ",
                            _dateFormat.format(convertTimeStampToCDate) != null
                                ? _dateFormat.format(convertTimeStampToCDate)
                                : "N/A"),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow(
                            "Ngày cập nhật: ",
                            _dateFormat.format(convertTimeStampToUDate) != null
                                ? _dateFormat.format(convertTimeStampToUDate)
                                : "N/A"),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow(
                            "Mã: ",
                            _receiptList[index].receiptCode.toString() != null
                                ? _receiptList[index].receiptCode.toString()
                                : "N/A"),
                        SizedBox(
                          height: 6,
                        ),
                        _buildReceiptType(
                            _receiptList[index].receiptType != null
                                ? _receiptList[index].receiptType
                                : "N/A"),
                      ],
                    )),
                expanded: ReceiptListItem(
                  data: _receiptList,
                  stores: _stores,
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

  Widget _buildReceiptType(int receiptType) {
    switch (receiptType) {
      case 1:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Type: ",
              style: TextStyle(
                  fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: ColorData.confirmedStatus),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Thanh Toán ",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorData.colorsWhite,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueRegular),
                  ),
                ),
              ),
            )
          ],
        );
        break;
      case 3:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Type: ",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontsName.textHelveticaNeueRegular),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: ColorData.pendingStatus),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: Text(
                    "Dịch Vụ ",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorData.colorsWhite,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueRegular),
                  ),
                ),
              ),
            )
          ],
        );
        break;
      default:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Type: ",
              style: TextStyle(
                  fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
            ),
            Text(
              receiptType.toString() != null ? receiptType.toString() : "N/A",
              style: TextStyle(
                  fontSize: 16,
                  color: ColorData.colorsWhite,
                  fontWeight: FontWeight.bold,
                  fontFamily: FontsName.textHelveticaNeueRegular),
            ),
          ],
        );
    }
  }

  Widget _buildUserAutoComplete() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: ColorData.colorsWhite,
        border: Border.all(
          color: ColorData.colorsBorderOutline,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(Dimen.border),
      ),
      child: Padding(
          padding: EdgeInsets.only(left: 14.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 4,
                child: TypeAheadFormField(
                  loadingBuilder: (context) => LoadingProgress(),
                  noItemsFoundBuilder: (context) => Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                        "Không tìm thấy dữ liệu",
                        style: TextStyle(fontSize: 14),
                      )),
                  textFieldConfiguration: TextFieldConfiguration(
                      autofocus: false,
                      controller: this.typeAheadController,
                      style: new TextStyle(color: Colors.black, fontSize: 14.0),
                      decoration: new InputDecoration(
                        border: InputBorder.none,
                        hintText: "Người dùng",
                        hintStyle: TextStyle(
                          color: ColorData.textGray.withOpacity(0.6),
                          fontSize: FontsSize.normal,
                        ),
                      )),
                  suggestionsCallback: (pattern) async {
                    try {
                      if (pattern.isEmpty) {
                        _isItemSelected = false;
                      }
                      if (_isItemSelected) {
                        return await _bloc.searchUser(SearchUserEvent(
                            sortId: "id",
                            offset: 0,
                            limit: 10,
                            keyword: _staffName));
                      } else {
                        return await _bloc.searchUser(SearchUserEvent(
                            sortId: "id",
                            offset: 0,
                            limit: 10,
                            keyword: pattern));
                      }
                    } catch (_) {}
                    return null;
                  },
                  itemBuilder: (context, suggestion) {
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text("${suggestion.id} - ${suggestion.name}"),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    _staffId = suggestion.id;
                    _staffName = suggestion.name;
                    _isItemSelected = true;
                    setState(() {
                      this.typeAheadController.text =
                          "${suggestion.id} - ${suggestion.name}";
                    });
                  },
                ),
              ),
              this.typeAheadController.text.isNotEmpty
                  ? Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            this.typeAheadController.clear();
                          });
                        },
                        child: Image.asset(
                          "assets/images/ic_circle_close_icon.png",
                          width: 18,
                          height: 18,
                        ),
                      ))
                  : Container()
            ],
          )),
    );
  }

  void _onRefresh() {
    _currentPage = 0;
    _receiptList = [];
    _bloc.getReceiptList(ReceiptListEvent(
        dataCustomer: 1,
        total: 1,
        limit: _limit,
        offset: 0,
        customerPhone: _phone,
        receiptBalance: "10000",
        receiptCode: _code,
        receiptType: _receiptType,
        userId: _staffId?.toString(),
        status: _status,
        fromDate: _startDate,
        toDate: _endDate));
    setState(() {
      _isLoading = true;
    });
  }

  void _onLoadMore() {
    _bloc.getReceiptList(ReceiptListEvent(
        dataCustomer: 1,
        total: 1,
        limit: _limit,
        offset: _offset,
        customerPhone: _phone,
        receiptBalance: "10000",
        receiptCode: _code,
        receiptType: _receiptType,
        userId: _staffId?.toString(),
        status: _status,
        fromDate: _startDate,
        toDate: _endDate));
  }

  _handleEvent(BaseEvent event) {
    if (event is GetListStoreEventSuccess) {
      setState(() {
        _stores = event.response.data.stores;
      });
      _bloc.getReceiptList(ReceiptListEvent(
          dataCustomer: 1,
          total: 1,
          limit: _limit,
          offset: 0,
          customerPhone: "",
          receiptBalance: "",
          receiptCode: "",
          receiptType: 1,
          status: 1,
          userId: "",
          fromDate: _startDate,
          toDate: _endDate));
    }
  }

  Widget _buildPhoneField() {
    return TextFieldOutline(
        hintText: "Số điện thoại khách hàng",
        isPhoneNumber: true,
        isPassword: 0,
        onChanged: (value) {
          _phone = value;
        });
  }

  Widget _buildCodeField() {
    return TextFieldOutline(
        hintText: "Mã",
        isPhoneNumber: false,
        isPassword: 0,
        onChanged: (value) {
          _code = value;
        });
  }

  Widget _buildStartDateField() {
    return InkWell(
      onTap: () {
        showDatePickerDialog(context, true, _selectStartDate, (value) {
          setState(() {
            _selectStartDate = value;
            _startDate = "${_selectStartDate.toLocal()}".split(' ')[0];
          });
        });
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          hintText: "${_selectStartDate.toLocal()}".split(' ')[0],
          stringAssetIconRight: "assets/images/ic_calendar.png",
          onChanged: (value) {
            "${_selectStartDate.toLocal()}".split(' ')[0] = value;
            _startDate = "${_selectStartDate.toLocal()}".split(' ')[0];
          },
        ),
      ),
    );
  }

  Widget _buildEndDatePickerField() {
    return InkWell(
      onTap: () {
        showDatePickerDialog(context, true, _selectEndDate, (value) {
          setState(() {
            _selectEndDate = value;
            _endDate = "${_selectEndDate.toLocal()}".split(' ')[0];
          });
        });
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          hintText: "${_selectEndDate.toLocal()}".split(' ')[0],
          stringAssetIconRight: "assets/images/ic_calendar.png",
          onChanged: (value) {
            "${_selectEndDate.toLocal()}".split(' ')[0] = value;
            _endDate = "${_selectEndDate.toLocal()}".split(' ')[0];
          },
        ),
      ),
    );
  }
}
