import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

typedef AddBooking(String date, String hour, String minute, String store,
    String sku, String customerName, String phone, String note);

class BookingDialog extends StatefulWidget {
  AddBooking addBooking;

  BookingDialog({this.addBooking});

  @override
  _BookingDialogState createState() => _BookingDialogState();
}

class _BookingDialogState extends State<BookingDialog> {
  DateTime _selectedDate = DateTime.now();
  String storeDropdownValue;
  String minuteDropdownValue;
  AddBooking _addBooking;
  String hourDropdownvalue;
  String phoneNumber = "";
  String customerName = "";
  String skuCode = "";
  String note = "";
  String storeId = "";
  SingleValue skuValue = SingleValue.valueOne;

  @override
  void initState() {
    super.initState();
    _addBooking = widget?.addBooking;
    storeDropdownValue = "Chọn cửa hàng";
    hourDropdownvalue = "08";
    minuteDropdownValue = "00";
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      children: [
        Container(
          padding: EdgeInsets.all(Dimen.kDefaultPadding - 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTitle("Ngày"),
                SizedBox(height: 6),
                _buildDatePickerField(),
                _buildTitle("Giờ"),
                SizedBox(height: 6),
                _buildHourCombobox(size),
                SizedBox(height: 6),
                _buildTitle("Phút"),
                SizedBox(height: 6),
                _buildMinuteCombobox(size),
                SizedBox(height: 8),
                _buildTitle("Cửa hàng"),
                SizedBox(height: 6),
                _buildStoreCombobox(size),
                SizedBox(height: 8),
                _buildTitle("Số điện thoại"),
                SizedBox(height: 6),
                _buildPhoneField(),
                SizedBox(height: 4),
                _buildTitle("Tên khách hàng"),
                SizedBox(height: 6),
                _buildNameField(),
                SizedBox(height: 2),
                _buildTitle("Ghi chú"),
                SizedBox(height: 6),
                _buildNoteField(),
                Container(
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: _buildRadioButton(
                              SingleValue.valueOne, "Giảm béo nhật bản")),
                      Expanded(
                          child: _buildRadioButton(
                              SingleValue.valueTwo, "Nối mi")),
                    ],
                  ),
                ),
                Container(
                  height: 80,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: _buildRadioButton(
                              SingleValue.valueThree, "Giảm béo RF")),
                      Expanded(
                          child: _buildRadioButton(
                              SingleValue.valueFourth, "spa test"))
                    ],
                  ),
                ),
                _buildButtonSubmit()
              ],
            ),
          ),
        )
      ],
    );
  }

  Future<void> _showDateTimeDialog(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: ColorData.primaryColor,
            accentColor: ColorData.primaryColor,
            colorScheme: ColorScheme.light(primary: ColorData.primaryColor),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != _selectedDate) 
    setState(() {
      _selectedDate = picked;
    });
  }

  Widget _buildHourCombobox(Size size) {
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
              value: hourDropdownvalue,
              items: [
                "08",
                "09",
                "10",
                "11",
                "12",
                "13",
                "14",
                "15",
                "16",
                "17",
                "18",
                "19",
                "20"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  hourDropdownvalue = value;
                });
              },
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ));
  }

  Widget _buildMinuteCombobox(Size size) {
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
              value: minuteDropdownValue,
              items: ["00", "15", "30", "45"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  minuteDropdownValue = value;
                });
              },
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ));
  }

  Widget _buildStoreCombobox(Size size) {
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
              value: storeDropdownValue,
              items: <String>[
                "Chọn cửa hàng",
                "Facebook",
                "SPA-71 HHT",
                "SPA-555",
                "SHOP-176 PDL",
                "SHOP-94 LVV",
                "SPA-657 QUANG TRUNG"
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  storeDropdownValue = value;
                  switch (storeDropdownValue) {
                    case "Facebook":
                      storeId = "1";
                      break;
                    case "SPA-71 HHT":
                      storeId = "3";
                      break;
                    case "SPA-555":
                      storeId = "5";
                      break;
                    case "SHOP-176 PDL":
                      storeId = "8";
                      break;
                    case "SHOP-94 LVV":
                      storeId = "10";
                      break;
                    case "SPA-657 QUANG TRUNG":
                      storeId = "17";
                      break;
                    default:
                  }
                });
              },
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ));
  }

  Widget _buildTitle(String title) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(color: ColorData.colorsBlack, fontSize: 14),
        ),
        Text(
          "(*)",
          style: TextStyle(color: ColorData.colorsBlack, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildRadioButton(SingleValue value, String title) {
    return Container(
      child: RadioListTile<SingleValue>(
        title: Text(
          title,
          style: TextStyle(fontSize: FontsSize.small),
        ),
        value: value,
        activeColor: ColorData.primaryColor,
        groupValue: skuValue,
        onChanged: (SingleValue value) {
          setState(() {
            skuValue = value;
            switch (skuValue) {
              case SingleValue.valueOne:
                skuCode = "90001";
                break;
              case SingleValue.valueTwo:
                skuCode = "90019";
                break;
              case SingleValue.valueThree:
                skuCode = "90021";
                break;
              case SingleValue.valueFourth:
                skuCode = "90024";
                break;
              default:
            }
          });
        },
      ),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () {
        _showDateTimeDialog(context);
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          errorText: "",
          isPassword: 0,
          hintText: "${_selectedDate.toLocal()}".split(' ')[0],
          isCenter: false,
          isPhoneNumber: false,
          onChanged: (value) {
            "${_selectedDate.toLocal()}".split(' ')[0] = value;
          },
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFieldOutline(
      errorText: "",
      isPassword: 0,
      hintText: "Số điện thoại",
      isCenter: false,
      isPhoneNumber: true,
      onChanged: (value) {
        phoneNumber = value;
      },
    );
  }

  Widget _buildNameField() {
    return TextFieldOutline(
      errorText: "",
      isPassword: 0,
      hintText: "Tên khách hàng",
      isCenter: false,
      isPhoneNumber: false,
      onChanged: (value) {
        customerName = value;
      },
    );
  }

  Widget _buildNoteField() {
    return TextFieldOutline(
      errorText: "",
      isPassword: 0,
      height: 100,
      hintText: "Ghi chú",
      isCenter: false,
      isPhoneNumber: false,
      onChanged: (value) {
        customerName = value;
      },
    );
  }

  Widget _buildButtonSubmit() {
    return ButtonColorNormal(
      height: 50,
      content: Text(
        "Xác Nhận",
        style: TextStyle(
            color: ColorData.colorsWhite,
            fontFamily: FontsName.textRobotoMedium,
            fontSize: FontsSize.normal),
      ),
      colorData: ColorData.primaryColor,
      onPressed: () {
        _addBooking(
            "${_selectedDate.toLocal()}".split(' ')[0],
            hourDropdownvalue,
            minuteDropdownValue,
            storeId,
            skuCode,
            customerName,
            phoneNumber,
            note);
      },
    );
  }
}

enum SingleValue { valueOne, valueTwo, valueThree, valueFourth }
