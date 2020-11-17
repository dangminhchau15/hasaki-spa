import 'dart:async';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/booking_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/commonview/extension_widget.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_list_store_event_success.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_service_group_event_success.dart';
import 'package:app/src/models/booking_result.dart';
import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/get_list_booking_response.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/screens/booking/create_booking_screen.dart';
import 'package:app/src/screens/booking/widgets/booking_item.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BookingScreen extends StatelessWidget {
  BookingScreen();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Đặt lịch",
        isHaveBackButton: true,
      ),
      body: Provider<BookingBloc>.value(
        value: BookingBloc(
            PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
        child: Consumer<BookingBloc>(
            builder: (context, bloc, child) => BookingScreenContent(
                  bloc: bloc,
                )),
      ),
    );
  }
}

class BookingScreenContent extends StatefulWidget {
  BookingBloc bloc;

  BookingScreenContent({this.bloc});

  @override
  _BookingScreenContentState createState() => _BookingScreenContentState();
}

class _BookingScreenContentState extends State<BookingScreenContent> {
  BookingBloc bloc;
  StreamSubscription _loadingStream;
  StreamSubscription bookingSubscription;
  bool isLoading = false;
  String storeDropdownValue;
  String staffDropdownValue;
  String statusDropdownValue;
  String typeDropdownValue;
  String typeBookingDropdownValue;
  String typeModeDropdownValue;
  String typeBooking;
  int storeId = 0;
  String status = "";
  String type = "";
  int bookingMode = 0;
  int bookingOption = 0;
  int bookingStatus = 0;
  String serviceGroupName = "";
  String phone = "";
  List<BookingResult> bookingResults = [];
  List<Service> servicesGroup = [];
  List<Store> stores = [];
  Map<String, Service> serviceGroups = Map();
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startDate = "${DateTime.now().toLocal()}".split(' ')[0];
  String endDate = "${DateTime.now().toLocal()}".split(' ')[0];
  int hour = 0;
  int serviceGroupSku = 0;
  int limit = 20;
  int currentPage = 0;
  int lastDataLength = 0;
  int bookingId = 0;
  List<Booking> bookings = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  GetListBookingResponse getListBookingResponse;
  int _offset = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    bookingSubscription = bloc.getListBookingStream.listen((onData) {
      getListBookingResponse = onData;
      if (mounted) {
        if (currentPage == 0) {
          _refreshController.refreshCompleted();
        }
        setState(() {
          bookings.addAll(onData?.data?.bookings);
        });
        lastDataLength = onData.data.bookings.length;
        if (lastDataLength > 0) {
          print("page:  $currentPage");
          currentPage++;
          _offset = currentPage * limit;
          _refreshController.loadComplete();
        } else {
          _refreshController.loadNoData();
        }
      }
    });
  }

  @override
  void initState() {
    storeDropdownValue = "Chọn cửa hàng";
    staffDropdownValue = "Select Staff";
    statusDropdownValue = "All Status";
    typeDropdownValue = "All Type";
    typeBookingDropdownValue = "Booking Date";
    typeModeDropdownValue = "Online";
    storeId = PreferenceProvider.getInt(SharePrefNames.STORE_ID);
    bloc = widget.bloc;
    _loadingStream = apiSubscription(bloc.loadingStream, context, null);
    bloc.event.add(GetServiceGroupEvent());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    bookingSubscription.cancel();
  }

  Widget _buildDropDown(
      List<String> firstValues,
      Size size,
      String firstValue,
      BuildContext context,
      ChangeValue firstCallback,
      List<String> secondValues,
      String secondValue,
      ChangeValue secondCallback) {
    return Row(
      children: [
        Expanded(
            child: combobox<String>(
                firstValues, size, 0.3, firstValue, context, firstCallback)),
        SizedBox(
          width: 10,
        ),
        Expanded(
            child: combobox<String>(
                secondValues, size, 0.3, secondValue, context, secondCallback))
      ],
    );
  }

  Widget _buidDateRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStartDatePickerField(),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: _buildEndDatePickerField(),
        )
      ],
    );
  }

  Widget _buildStatus(String status) {
    switch (status) {
      case "1":
        return _buidStatusRow("Active", ColorData.pendingStatus);
        break;
      case "2":
        return _buidStatusRow("Confirmed", ColorData.confirmedStatus);
        break;
      case "3":
        return _buidStatusRow("No Show", ColorData.noShowStatus);
        break;
      case "4":
        return _buidStatusRow("Cancel", ColorData.cancelStatus);
        break;
    }
    return Container();
  }

  Widget _buidStatusRow(String text, Color color) {
    return Container(
      width: 80,
      height: 30,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0), color: color),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontFamily: FontsName.textHelveticaNeueRegular,
              fontSize: FontsSize.normal,
              color: ColorData.colorsWhite),
        ),
      ),
    );
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

  Widget _buildEndDatePickerField() {
    return InkWell(
      onTap: () {
        showDatePickerDialog(context, true, selectedEndDate, (value) {
          setState(() {
            selectedEndDate = value;
            endDate = "${selectedEndDate.toLocal()}".split(' ')[0];
          });
        });
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          hintText: "${selectedEndDate.toLocal()}".split(' ')[0],
          stringAssetIconRight: "assets/images/ic_calendar.png",
          onChanged: (value) {
            "${selectedEndDate.toLocal()}".split(' ')[0] = value;
            endDate = "${selectedEndDate.toLocal()}".split(' ')[0];
          },
        ),
      ),
    );
  }

  Widget _buildStartDatePickerField() {
    return InkWell(
      onTap: () {
        showDatePickerDialog(context, true, selectedStartDate, (value) {
          setState(() {
            selectedStartDate = value;
            startDate = "${selectedStartDate.toLocal()}".split(' ')[0];
          });
        });
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          hintText: "${selectedStartDate.toLocal()}".split(' ')[0],
          stringAssetIconRight: "assets/images/ic_calendar.png",
          onChanged: (value) {
            "${selectedStartDate.toLocal()}".split(' ')[0] = value;
            startDate = "${selectedStartDate.toLocal()}".split(' ')[0];
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<BookingBloc>(
      listener: handleEvent,
      child: Scaffold(
        body: Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: StreamBuilder(
                stream: bloc.loadedListStream,
                initialData: false,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(
                        complete: Text("Tải dữ liệu thành công",
                            style: TextStyle(
                                fontSize: 14, color: ColorData.primaryColor)),
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
                            body =
                                Text("Tải dữ liệu thất bại vui lòng thử lại");
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  //booking date mode
                                  _buildDropDown(
                                      ["Booking Date", "Date Created"],
                                      size,
                                      "Booking Date",
                                      context,
                                      (itemValue) {
                                        switch (itemValue) {
                                          case "Booking Date":
                                            bookingOption = 1;
                                            break;
                                          case "Date Created":
                                            bookingOption = 2;
                                            break;
                                        }
                                      },
                                      ["-Chọn loại-", "Online", "Offline"],
                                      "-Chọn loại-",
                                      (itemValue) {
                                        switch (itemValue) {
                                          case "Online":
                                            bookingMode = 1;
                                            break;
                                          case "Offline":
                                            bookingMode = -1;
                                            break;
                                        }
                                      }),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //start date, end date
                                  _buidDateRow(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  //status, servicegroup
                                  StreamProvider.value(
                                    initialData: [
                                      Service(
                                          serviceGroupName: "Chọn nhóm dịch vụ")
                                    ],
                                    value: bloc.getListNameServiceGroupStream,
                                    child: Consumer<List<Service>>(
                                        builder: (context, list, child) {
                                      List<String> servicesGroupNames = [];
                                      list.forEach((element) {
                                        servicesGroupNames
                                            .add(element.serviceGroupName);
                                      });
                                      return _buildDropDown(
                                          [
                                            "Chọn trạng thái",
                                            "Chờ xử lý",
                                            "Đã xác nhận",
                                            "No Show",
                                            "Huỷ"
                                          ],
                                          size,
                                          "Chọn trạng thái",
                                          context,
                                          (itemValue) {
                                            switch (itemValue) {
                                              case "Chọn trạng thái":
                                                bookingStatus = 0;
                                                break;
                                              case "Chờ xử lý":
                                                bookingStatus = 1;
                                                break;
                                              case "Đã xác nhận":
                                                bookingStatus = 2;
                                                break;
                                              case "No Show":
                                                bookingStatus = 3;
                                                break;
                                              case "Huỷ":
                                                bookingStatus = 4;
                                                break;
                                            }
                                          },
                                          servicesGroupNames,
                                          servicesGroupNames[0],
                                          (itemValue) {
                                            list.forEach((element) {
                                              if (element.serviceGroupName ==
                                                  itemValue) {
                                                serviceGroupSku =
                                                    element.serviceGroupId;
                                              }
                                            });
                                          });
                                    }),
                                  ),
                                  SizedBox(height: 10),
                                  //hour, store
                                  StreamProvider.value(
                                    initialData: [Store(storeName: "")],
                                    value: bloc.getListNameStoreStream,
                                    child: Consumer<List<Store>>(
                                        builder: (context, list, child) {
                                      List<String> storeNames = [];
                                      String storeNameDefault;
                                      list.forEach((element) {
                                        storeNames.add(element.storeName);
                                        if (element.storeId == storeId) {
                                          storeNameDefault = element.storeName;
                                        }
                                      });
                                      return _buildDropDown(
                                          [
                                            "--choose overdue--",
                                            ">1 Hour",
                                            ">2 Hours",
                                            ">12 Hours",
                                          ],
                                          size,
                                          ">1 Hour",
                                          context,
                                          (itemValue) {
                                            switch (itemValue) {
                                              case ">1 Hour":
                                                hour = 1;
                                                break;
                                              case ">2 Hours":
                                                hour = 2;
                                                break;
                                              case ">12 Hours":
                                                hour = 12;
                                                break;
                                            }
                                          },
                                          storeNames,
                                          storeNameDefault,
                                          (itemValue) {
                                            list.forEach((element) {
                                              if (element.storeName ==
                                                  itemValue) {
                                                storeId = element.storeId;
                                              }
                                            });
                                          });
                                    }),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  _buildPhoneField(),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  ButtonColorNormal(
                                    height: 50,
                                    content: Text(
                                      "Tìm kiếm",
                                      style: TextStyle(
                                          color: ColorData.colorsWhite,
                                          fontFamily:
                                              FontsName.textRobotoMedium,
                                          fontSize: FontsSize.normal),
                                    ),
                                    colorData: ColorData.primaryColor,
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                        bookings = [];
                                        bloc.getBookings(
                                            "1",
                                            20,
                                            0,
                                            storeId,
                                            bookingOption,
                                            bookingMode,
                                            bookingStatus,
                                            phone,
                                            serviceGroupSku,
                                            hour,
                                            startDate,
                                            endDate,
                                            startDate,
                                            endDate);
                                      });
                                    },
                                  )
                                ],
                              ),
                            )
                          ])),
                          SliverList(
                            delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
                              return _buildListBookings(index);
                            },childCount: bookings?.length != null
                                    ? bookings?.length
                                    : 0),
                          )
                        ],
                      ),
                    );
                  }
                  return Container();
                })),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorData.primaryColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateBookingScreen()));
          },
          child: Icon(
            Icons.arrow_right_alt,
            color: ColorData.colorsWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFieldOutline(
        hintText: "Số điện thoại khách hàng",
        isPhoneNumber: true,
        isPassword: 0,
        onChanged: (value) {
          phone = value;
        });
  }

  Widget _buildListBookings(int index) {
    List<String> date = bookings[index].createdAt.split(" ");
    var dateBooking = date[0];
    var time = date[1];
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
                            "Mã: ",
                            bookings[index].bookingCode != 0
                                ? bookings[index].bookingCode.toString()
                                : "N/A"),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow("Ngày tháng: ", dateBooking),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow("Giờ ", time),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow(
                            "Họ tên: ", bookings[index].bookingName),
                        SizedBox(
                          height: 6,
                        ),
                        _buildHeaderRow(
                            "Số điện thoại: ", bookings[index].bookingPhone),
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
                            _buildStatus(
                                bookings[index].bookingStatus.toString())
                          ],
                        )
                      ],
                    )),
                expanded: BookingItem(
                  bookings: bookings,
                  bookingResponse: getListBookingResponse,
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

  handleEvent(BaseEvent event) {
    if (event is GetServiceGroupEventSuccess) {
      serviceGroups = event.response.data.services;
      serviceGroups.forEach((key, value) {
        servicesGroup.add(value);
      });
      //add list service group name
      bloc.getListNameServiceGroupSink.add(servicesGroup);
      //get list store
      bloc.event.add(GetListStoreEvent());
    } else if (event is GetListStoreEventSuccess) {
      event.response.data.stores.forEach((element) {
        stores.add(element);
        print("stores: ${element.storeId}");
      });
      //add list store name
      bloc.getListNameStoreSink.add(stores);
      bloc.getBookings(
          "1", limit, currentPage, 6, 1, 0, 0, "", 90001, 0, "", "", "", "");
    }
  }

  void _onLoadMore() async {
    bloc.getBookings(
        "1",
        limit,
        _offset,
        storeId,
        bookingOption,
        bookingMode,
        bookingStatus,
        phone,
        serviceGroupSku,
        hour,
        startDate,
        endDate,
        startDate,
        endDate);
  }

  void _onRefresh() async {
    currentPage = 0;
    bookings = [];
    bloc.getBookings(
        "1",
        limit,
        0,
        storeId,
        bookingOption,
        bookingMode,
        bookingStatus,
        phone,
        serviceGroupSku,
        hour,
        startDate,
        endDate,
        startDate,
        endDate);
    setState(() {
      isLoading = true;
    });
  }
}
