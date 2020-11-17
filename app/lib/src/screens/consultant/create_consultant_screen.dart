import 'dart:async';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/consultant_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/add_new_customer_event.dart';
import 'package:app/src/eventstate/add_new_customer_success.dart';
import 'package:app/src/eventstate/check_customer_phone_event.dart';
import 'package:app/src/eventstate/check_customer_phone_success.dart';
import 'package:app/src/screens/consultant/consultant_detail_screen.dart';
import 'package:app/src/screens/consultant/widgets/add_customer_dialog.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateConsultantScreen extends StatelessWidget {
  String name;
  String phone;

  CreateConsultantScreen({this.name, this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Thêm tư vấn"),
      body: Provider<ConsultantBloc>.value(
        value: ConsultantBloc(
            PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
        child: Consumer<ConsultantBloc>(
          builder: (context, bloc, child) => CreateConsultantScreenContent(
            bloc: bloc,
          ),
        ),
      ),
    );
  }
}

class CreateConsultantScreenContent extends StatefulWidget {
  ConsultantBloc bloc;

  CreateConsultantScreenContent({this.bloc});

  @override
  _CreateConsultantScreenContentState createState() =>
      _CreateConsultantScreenContentState();
}

class _CreateConsultantScreenContentState
    extends State<CreateConsultantScreenContent> {
  ConsultantBloc _bloc;
  TextEditingController _controller = TextEditingController();
  StreamSubscription _loadingStream;
  bool _isCheckCustomer;

  @override
  void initState() {
    print("chau: $_bloc");
    _bloc = widget.bloc;
    _loadingStream = apiSubscription(_bloc.loadingStream, context, null);
    _isCheckCustomer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: BlocListener<ConsultantBloc>(
            listener: handleEvent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            flex: 5,
                            child: Container(
                              color: ColorData.colorLightGrey,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 4.0, bottom: 4.0, left: 8.0),
                                child: TextField(
                                  cursorColor: ColorData.primaryColor,
                                  controller: _controller,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 16),
                                      border: InputBorder.none,
                                      hintText: 'Số điện thoại'),
                                ),
                              ),
                            )),
                        SizedBox(height: 10),
                        Flexible(
                            child: InkWell(
                          onTap: () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _bloc.event.add(CheckCustomerPhoneEvent(
                                phone: _controller.text));
                          },
                          child: Container(
                            height: 54,
                            width: MediaQuery.of(context).size.width,
                            color: ColorData.primaryColor,
                            child: Icon(
                              Icons.search,
                              color: ColorData.colorsWhite,
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(height: 10),
                    _isCheckCustomer
                        ? Container(
                            color: ColorData.primaryColor,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Số điện thoại: ${_controller.text}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorData.colorsWhite,
                                          fontFamily: FontsName
                                              .textHelveticaNeueRegular,
                                          fontSize: 16)),
                                  SizedBox(height: 10),
                                  Text(
                                      "Số điện thoại không tồn tại. Vui lòng thử lại trước khi tạo khách hàng mới",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorData.colorsWhite,
                                          fontFamily: FontsName
                                              .textHelveticaNeueRegular,
                                          fontSize: 16)),
                                  SizedBox(height: 10),
                                  ButtonColorNormal(
                                      width: 180,
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (_) => AddCustomerDialog(
                                                phone: _controller.text,
                                                onAddCustomer: (phone, name) {
                                                  Navigator.pop(context);
                                                  _bloc.event.add(
                                                      AddNewCustomerEvent(
                                                          phone: phone,
                                                          name: name));
                                                }));
                                      },
                                      content: Text(
                                        "Tạo mới khách hàng",
                                        style: TextStyle(
                                            color: ColorData.colorsWhite,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      colorData: ColorData.colorThree)
                                ],
                              ),
                            ),
                          )
                        : Container()
                  ]),
            )),
      ),
    );
  }

  void _flowCheckCustomer(CheckCustomerPhoneEventSuccess event) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConsultantDetailScreen(
          name: event.response.data.customer.customerName,
          customerId: event.response.data.customer.customerId,
          phone: event.response.data.customer.customerPhone),
    ));
    if (result != null) {
      setState(() {
        _isCheckCustomer = false;
      });
    }
  }

  void _flowAddCustomer(AddNewCustomerSuccess event) async {
    var result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => ConsultantDetailScreen(
          name: event.response.data.customer.customerName,
          customerId: event.response.data.customer.customerId,
          phone: event.response.data.customer.customerPhone),
    ));
    if (result != null) {
      setState(() {
        _isCheckCustomer = false;
      });
    }
  }

  void handleEvent(BaseEvent event) {
    if (event is CheckCustomerPhoneEventSuccess) {
      if (event.response.data.customer == null) {
        setState(() {
          _isCheckCustomer = true;
        });
      } else {
        _flowCheckCustomer(event);
      }
    } else if (event is AddNewCustomerSuccess) {
      _flowAddCustomer(event);
    }
  }
}
