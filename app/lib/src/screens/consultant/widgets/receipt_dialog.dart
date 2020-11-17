import 'package:app/src/blocs/consultant_bloc.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/loading_progress.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/models/get_service_group_response.dart';
import 'package:app/src/models/service_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/debouncer.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';

typedef AddReceipt(int serviceCode, String serviceName, int quantity,
    String price, String note);

class ReceiptDialog extends StatefulWidget {
  bool isLoaded;
  ConsultantBloc bloc;
  AddReceipt addReceipt;
  Map<String, Service> servicesGroup;
  ReceiptDialog(
      {this.servicesGroup, this.isLoaded, this.addReceipt, this.bloc});

  @override
  _ReceiptDialogContentState createState() => _ReceiptDialogContentState();
}

class _ReceiptDialogContentState extends State<ReceiptDialog> {
  final TextEditingController typeAheadController = TextEditingController();
  final Debouncer onSearchDebouncer =
      Debouncer(delay: Duration(milliseconds: 500));
  String title;
  Map<String, Service> serviceGroups;
  List<Service> services = [];
  String _qty = "";
  String _note = "";
  String name;
  String phone;
  int price = 0;
  String serviceName = "";
  int skuCode = 0;
  ConsultantBloc bloc;
  AddReceipt addReceipt;
  String dropdownValue = 'No Bookings';
  FlutterMoneyFormatter priceFmF;
  GlobalKey<AutoCompleteTextFieldState<ServiceSearch>> key = new GlobalKey();
  AutoCompleteTextField searchTextField;
  TextEditingController controller = TextEditingController();
  Service selectedService;
  bool isItemSelected = false;

  @override
  void initState() {
    super.initState();
    addReceipt = widget?.addReceipt;
    bloc = widget?.bloc;
    serviceGroups = widget?.servicesGroup;
    serviceGroups.forEach((key, value) {
      services.add(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      children: <Widget>[
        Container(
          child: Padding(
            padding: EdgeInsets.all(Dimen.kDefaultPadding - 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 20),
                  _buildSkuAutoComplete(),
                  SizedBox(height: 10),
                  _buildQuantityField(),
                  SizedBox(height: 10),
                  _buildCombobox(size),
                  SizedBox(height: 10),
                  _buildNoteField(),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    child: CustomScrollView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 220.0,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 20.0,
                            childAspectRatio: 1.5,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return RadioListTile<Service>(
                                value: services[index],
                                groupValue: selectedService,
                                activeColor: ColorData.primaryColor,
                                title: Text(
                                  services[index].serviceGroupName,
                                  softWrap: true,
                                ),
                                onChanged: (currentService) {
                                  setState(() {
                                    setSelectedService(currentService);
                                  });
                                },
                                selected: selectedService == services[index],
                              );
                            },
                            childCount:
                                services.length > 0 ? services.length : 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14),
                  _buildButtonSubmit(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  setSelectedService(Service service) {
    setState(() {
      selectedService = service;
    });
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
                        hintText: "SKU,Name",
                        hintStyle: TextStyle(
                          color: ColorData.textGray.withOpacity(0.6),
                          fontSize: FontsSize.normal,
                        ),
                      )),
                  suggestionsCallback: (pattern) async {
                    try {
                      if (pattern.isEmpty) {
                        isItemSelected = false;
                      }
                      if (isItemSelected) {
                        return await bloc.searchSKU(
                            "service_id", 1, 1, 0, 15, 1, serviceName);
                      } else {
                        return await bloc.searchSKU(
                            "service_id", 1, 1, 0, 15, 1, pattern);
                      }
                    } catch (_) {
                      print(_);
                    }
                    return null;
                  },
                  itemBuilder: (context, suggestion) {
                    priceFmF = FlutterMoneyFormatter(
                        amount: double.parse("${suggestion.servicePrice}"));
                    return Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text(
                          "${suggestion.serviceName} ${priceFmF.output.withoutFractionDigits}"),
                    );
                  },
                  onSuggestionSelected: (suggestion) async {
                    isItemSelected = true;
                    priceFmF = FlutterMoneyFormatter(
                        amount: double.parse("${suggestion.servicePrice}"));
                    serviceName = "${suggestion.serviceName}";
                    price = int.parse("${suggestion.servicePrice}");
                    skuCode = suggestion.serviceSku;
                    setState(() {
                      this.typeAheadController.text =
                          "${suggestion.serviceName} ${priceFmF.output.withoutFractionDigits}";
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

  Widget _buildQuantityField() {
    return StreamProvider.value(
      value: bloc.quantityStream,
      child: Consumer<String>(
          builder: (context, msg, child) => TextFieldOutline(
                errorText: msg,
                isPassword: 0,
                height: 50,
                hintText: "Số lượng",
                isCenter: false,
                isPhoneNumber: true,
                onChanged: (value) {
                  _qty = value;
                  onSearchDebouncer.debounce(() {
                    if (_qty == "0") {
                      bloc.quantitySink.add("Vui lòng nhập số lớn hơn không");
                    } else {
                      bloc.quantitySink.add(null);
                    }
                  });
                },
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

  Widget _buildCombobox(Size size) {
    return Container(
        width: size.width * 3,
        decoration: BoxDecoration(
          color: ColorData.colorsWhite,
          border: Border.all(
            color: ColorData.colorsBorderOutline,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(Dimen.border),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 0.0),
        child: DropdownButtonHideUnderline(
          child: ButtonTheme(
            alignedDropdown: true,
            child: DropdownButton(
              value: dropdownValue,
              items: <String>['No Bookings']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropdownValue = value;
                });
              },
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ));
  }

  Widget _buildButtonSubmit() {
    return ButtonColorNormal(
      height: 50,
      content: Text(
        "Thêm",
        style: TextStyle(
            color: ColorData.colorsWhite,
            fontFamily: FontsName.textRobotoMedium,
            fontSize: FontsSize.normal),
      ),
      colorData: ColorData.primaryColor,
      onPressed: () {
        if (_qty != "0" && _qty != "") {
          setState(() {
            addReceipt(
                skuCode, serviceName, int.parse(_qty), price.toString(), _note);
          });
          bloc.quantitySink.add(null);
        } else {
          bloc.quantitySink.add("Vui lòng nhập số lớn hơn không");
        }
      },
    );
  }
}
