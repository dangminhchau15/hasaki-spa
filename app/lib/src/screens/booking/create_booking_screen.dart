import 'dart:async';

import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/create_booking_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/commonview/extension_widget.dart';
import 'package:app/src/commonview/loading_progress.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/booking_event.dart';
import 'package:app/src/eventstate/booking_event_success.dart';
import 'package:app/src/eventstate/check_customer_phone_success.dart';
import 'package:app/src/eventstate/get_list_store_event.dart';
import 'package:app/src/eventstate/get_list_store_event_success.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_service_group_event_success.dart';
import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/models/get_staff_list_response.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/debouncer.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateBookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Đặt lịch"),
      body: Provider<CreateBookingBloc>.value(
          value: CreateBookingBloc(
              PreferenceProvider.getString(SharePrefNames.USER_NAME)),
          child: Consumer<CreateBookingBloc>(
            builder: (context, bloc, child) => CreateBookingScreenContent(
              bloc: bloc,
            ),
          )),
    );
  }
}

class CreateBookingScreenContent extends StatefulWidget {
  CreateBookingBloc bloc;

  CreateBookingScreenContent({this.bloc});

  @override
  _CreateBookingScreenState createState() => _CreateBookingScreenState();
}

class _CreateBookingScreenState extends State<CreateBookingScreenContent> {
  DateTime _currentTime = DateTime.now();
  List<Store> _stores = [];
  List<Staff> _staffs = [];
  List<Service> _services = [];
  Service selectedService;
  CreateBookingBloc _bloc;
  int _storeId = 0;
  StreamSubscription _loadingStream;
  String _phone = "";
  String _name = "";
  String _note = "";
  String _filter = "";
  bool _isLoaded = true;
  int _serviceGroupSku = 0;
  int _staffId = 0;
  int _limit = 10;
  String _staffName = "";
  bool _isItemSelected = false;
  GlobalKey<AutoCompleteTextFieldState<Staff>> key = new GlobalKey();
  final TextEditingController typeAheadController = TextEditingController();
  final Debouncer _onSearchDebouncer =
      Debouncer(delay: Duration(milliseconds: 500));
  final _dateFormat = new DateFormat('yyyy-MM-dd HH:mm');

  @override
  void initState() {
    _bloc = widget.bloc;
    _loadingStream = apiSubscription(_bloc.loadingStream, context, null);
    _storeId = PreferenceProvider.getInt(SharePrefNames.STORE_ID);
    _bloc.event.add(GetListStoreEvent());
    super.initState();
  }

  setSelectedService(Service service) {
    setState(() {
      selectedService = service;
      _serviceGroupSku = selectedService.serviceGroupSku;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BlocListener<CreateBookingBloc>(
      listener: handleEvent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Time booking",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorData.colorsBlack,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueBold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  _buildDateTimePicker()
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cửa hàng",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorData.colorsBlack,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueBold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  StreamProvider.value(
                    initialData: [Store(storeName: "")],
                    value: _bloc.getListStoreStream,
                    child:
                        Consumer<List<Store>>(builder: (context, list, child) {
                      List<String> storeNames = [];
                      String storeNameDefault;
                      list.forEach((element) {
                        storeNames.add(element.storeName);
                        if (element.storeId == _storeId) {
                          storeNameDefault = element.storeName;
                        }
                      });
                      return combobox(
                          storeNames, size, 0.3, storeNameDefault, context,
                          (itemValue) {
                        list.forEach((element) {
                          if (element.storeName == itemValue) {
                            _storeId = element.storeId;
                          }
                        });
                      });
                    }),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Số điện thoại",
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorData.colorsBlack,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsName.textHelveticaNeueBold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        _buildPhoneField()
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tên",
                          style: TextStyle(
                              fontSize: 14,
                              color: ColorData.colorsBlack,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsName.textHelveticaNeueBold),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        _buildNameField()
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Staff",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorData.colorsBlack,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueBold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  _buildSkuAutoComplete()
                ],
              ),
              SizedBox(height: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ghi chú",
                    style: TextStyle(
                        fontSize: 14,
                        color: ColorData.colorsBlack,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueBold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  _buildNoteField(),
                  SizedBox(
                    height: 2,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: StreamBuilder(
                        initialData: false,
                        stream: _bloc.getListServiceStream,
                        builder: (context, snapshot) => snapshot.data
                            ? CustomScrollView(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                slivers: [
                                  SliverGrid(
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 200.0,
                                      mainAxisSpacing: 10.0,
                                      crossAxisSpacing: 10.0,
                                      childAspectRatio: 4.0,
                                    ),
                                    delegate: SliverChildBuilderDelegate(
                                      (BuildContext context, int index) {
                                        return RadioListTile<Service>(
                                          value: _services[index],
                                          groupValue: selectedService,
                                          activeColor: ColorData.primaryColor,
                                          title: Text(_services[index]
                                              .serviceGroupName),
                                          onChanged: (currentService) {
                                            setState(() {
                                              setSelectedService(
                                                  currentService);
                                            });
                                          },
                                          selected: selectedService ==
                                              _services[index],
                                        );
                                      },
                                      childCount: _services.length > 0
                                          ? _services.length
                                          : 0,
                                    ),
                                  ),
                                ],
                              )
                            : Container()),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 14,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: ButtonColorNormal(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              content: Text("Huỷ",
                                  style:
                                      TextStyle(color: ColorData.colorsWhite)),
                              colorData: ColorData.textGray),
                        ),
                        SizedBox(width: 10),
                        Expanded(flex: 4, child: _buildButtonSubmit())
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  handleEvent(BaseEvent event) {
    if (event is GetListStoreEventSuccess) {
      _stores = event.response.data.stores
          .where((element) =>
              element.storeServiceId == 1 && element.storeStatus == 1)
          .toList();
      _bloc.getListStoreSink.add(_stores);
      _bloc.event.add(GetServiceGroupEvent());
    } else if (event is GetServiceGroupEventSuccess) {
      event.response.data.services.forEach((key, value) {
        _services.add(value);
      });
      _bloc.getListServiceSink.add(true);
    } else if (event is CheckCustomerPhoneEventSuccess) {
      if (event.response.data.customer == null) {
        _bloc.phoneSink.add("Số điện thoại chưa tồn tại");
      } else {
        _bloc.phoneSink.add(null);
        setState(() {
          _name = event.response.data.customer.customerName;
        });
      }
    } else if (event is BookingEventSuccess) {
      Navigator.pop(context);
    }
  }

  Widget _buildButtonSubmit() {
    return ButtonColorNormal(
        onPressed: () {
          _bloc.event.add(BookingEvent(
              bookingDate: _dateFormat.format(_currentTime),
              decs: _note,
              name: _name == null ? "" : _name,
              phone: _phone,
              status: 1,
              serviceGroupSku: _serviceGroupSku.toString(),
              staffId: _staffId.toString(),
              storeId: _storeId));
        },
        content: Text("Tạo", style: TextStyle(color: ColorData.colorsWhite)),
        colorData: ColorData.primaryColor);
  }

  Widget _buildSkuAutoComplete() {
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
                        hintText: "--search staff--",
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
                        return await _bloc.searchStaff(
                            "staff_id", 10, _staffName);
                      } else {
                        return await _bloc.searchStaff("staff_id", 10, pattern);
                      }
                    } catch (_) {}
                    return null;
                  },
                  itemBuilder: (context, suggestion) {
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                          "${suggestion.staffId} - ${suggestion.staffName} #${suggestion.code == null ? "" : suggestion.code}"),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    _staffId = suggestion.staffId;
                    _staffName = suggestion.staffName;
                    _isItemSelected = true;
                    setState(() {
                      this.typeAheadController.text =
                          "${suggestion.staffId} - ${suggestion.staffName} #${suggestion.code == null ? "" : suggestion.code}";
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

  Widget _buildNoteField() {
    return TextFieldOutline(
      errorText: "",
      isPassword: 0,
      height: 100,
      hintText: "Note",
      isCenter: false,
      isPhoneNumber: false,
      onChanged: (value) {
        _note = value;
      },
    );
  }

  Widget _buildPhoneField() {
    return StreamProvider.value(
        value: _bloc.phoneStream,
        child: Consumer<String>(
          builder: (context, msg, child) => TextFieldOutline(
              hintText: "Số điện thoại khách hàng",
              errorText: msg,
              isPhoneNumber: true,
              isPassword: 0,
              onChanged: (value) {
                _phone = value;
                _onSearchDebouncer.debounce(() {
                  _bloc.phoneSink.add(_phone);
                });
              }),
        ));
  }

  Widget _buildNameField() {
    return StreamProvider.value(
        value: _bloc.nameStream,
        child: Consumer<String>(builder: (context, msg, child) {
          if (msg != null) {
            _name = msg;
          }
          return TextFieldOutline(
              hintText: _name == null ? "Họ tên khách hàng" : _name,
              isPhoneNumber: false,
              isPassword: 0,
              onChanged: (value) {
                _name = value;
              });
        }));
  }

  Widget _buildDateTimePicker() {
    return InkWell(
      onTap: () {
        showDateTimePickerDialog(context, (value) {
          setState(() {
            _currentTime = value;
          });
        });
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          hintText: _dateFormat.format(_currentTime),
          stringAssetIconRight: "assets/images/ic_calendar.png",
          onChanged: (value) {},
        ),
      ),
    );
  }
}
