import 'dart:async';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/consultant_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/add_item_event.dart';
import 'package:app/src/eventstate/add_item_event_success.dart';
import 'package:app/src/eventstate/get_service_group_event.dart';
import 'package:app/src/eventstate/get_service_group_event_success.dart';
import 'package:app/src/models/add_item_receipt_response.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/models/service_response.dart';
import 'package:app/src/screens/consultant/widgets/header_avartar.dart';
import 'package:app/src/screens/consultant/widgets/receipt_item.dart';
import 'package:app/src/screens/main/main_screen.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';
import 'widgets/receipt_dialog.dart';

class AddReceiptScreen extends StatelessWidget {
  String name;
  String phone;
  int customerId;
  int consultantId;

  AddReceiptScreen({this.customerId, this.name, this.phone, this.consultantId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: "Tư vấn",
        ),
        body: Provider<ConsultantBloc>.value(
          value: ConsultantBloc(
              PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
          child: Consumer<ConsultantBloc>(
            builder: (context, bloc, child) => AddReceiptContentScreen(
              bloc: bloc,
              name: name,
              phone: phone,
              customerId: customerId,
              consultantId: consultantId,
            ),
          ),
        ));
  }
}

class AddReceiptContentScreen extends StatefulWidget {
  ConsultantBloc bloc;
  String name;
  String phone;
  int customerId;
  int consultantId;

  AddReceiptContentScreen(
      {this.bloc, this.name, this.phone, this.customerId, this.consultantId});

  @override
  _AddReceiptContentScreenState createState() =>  _AddReceiptContentScreenState();
}

class _AddReceiptContentScreenState extends State<AddReceiptContentScreen> {
  String _sku = "";
  String _qty = "";
  String _note = "";
  String name;
  String phone;
  int customerId;
  int price = 0;
  int consultantId;
  String serviceName = "";
  int skuCode = 0;
  String dropdownValue = 'No Bookings';
  List<ServiceItem> data;
  List<UnicornButton> _floatButtons;
  StreamSubscription _loadingStream;
  ConsultantBloc bloc;
  bool isLoaded = false;
  GlobalKey<AutoCompleteTextFieldState<ServiceSearch>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;
  TextEditingController controller = TextEditingController();
  Map<String, Service> serviceGroups;
  _AddReceiptContentScreenState();

  @override
  void initState() {
    super.initState();
    name = widget?.name;
    phone = widget?.phone;
    customerId = widget?.customerId;
    consultantId = widget?.consultantId;
    data = [];
    bloc = widget.bloc;
    _loadingStream = apiSubscription(bloc.loadingStream, context, null);
    bloc.event.add(GetServiceGroupEvent(
        sort: "service_group_ctime",
        serviceGroupParent: 0,
        serviceGroupStatus: 1));
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _initFloatButtons();
    return BlocListener<ConsultantBloc>(
      listener: handleEvent,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    HeaderAvartar(
                        size: size,
                        phone: phone,
                        name: name,
                        customerId: customerId),
                    Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ListView.builder(
                              itemCount: data.length != 0 ? data.length : 0,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) => ReceiptItem(
                                    index: index,
                                    data: data,
                                    itemClick: (index) {
                                      setState(() {
                                        data?.removeAt(index);
                                      });
                                    },
                                  ))),
                    )
                  ],
                ))
          ],
        ),
        floatingActionButton: UnicornDialer(
            parentButtonBackground: ColorData.primaryColor,
            orientation: UnicornOrientation.VERTICAL,
            parentButton: Icon(Icons.add),
            childButtons: _floatButtons),
      ),
    );
  }

  void _initFloatButtons() {
    _floatButtons = List<UnicornButton>();
    _floatButtons.add(UnicornButton(
      hasLabel: true,
      labelText: "Về màn hình chính",
      labelHasShadow: false,
      currentButton: FloatingActionButton(
        heroTag: "Tag1",
        mini: true,
        backgroundColor: ColorData.primaryColor,
        child: Icon(Icons.home),
        onPressed: () {
          showYesNoDialog(context, "Bạn có muốn quay về màn hình chính?", () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreen()));
          }, () {});
        },
      ),
    ));
    _floatButtons.add(UnicornButton(
      hasLabel: true,
      labelHasShadow: false,
      labelText: "Thêm dịch vụ",
      currentButton: FloatingActionButton(
        heroTag: "Tag2",
        mini: true,
        backgroundColor: ColorData.primaryColor,
        child: Icon(Icons.receipt),
        onPressed: () {
          _showContentDialog();
        },
      ),
    ));
  }

  void handleEvent(BaseEvent event) {
    if (event is GetServiceGroupEventSuccess) {
      serviceGroups = event.response.data.services;
    } else if (event is AddItemEventSuccess) {
      setState(() {
        data = event.response.data.consultant.items;
      });
      Navigator.pop(context);
    }
  }

  void _showContentDialog() {
    showDialog(
        context: context,
        builder: (_) => ReceiptDialog(
              isLoaded: isLoaded,
              bloc: bloc,
              servicesGroup: serviceGroups,
              addReceipt: (serviceCode, serviceName, quantity, price, note) =>
                  _addReceipt(serviceCode, quantity, price, note),
            ));
  }

  void _addReceipt(int serviceCode, int quantity, String price, String note) {
    bloc.event.add(AddItemEvent(
        sku: serviceCode.toString(),
        consultantId: consultantId,
        quantity: quantity,
        note: note));
  }
}
