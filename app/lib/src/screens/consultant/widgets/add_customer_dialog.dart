import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

typedef OnAddCustomer(String phone, String name);

class AddCustomerDialog extends StatefulWidget {
  String phone;
  OnAddCustomer onAddCustomer;

  AddCustomerDialog({this.phone, this.onAddCustomer});

  @override
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
  String _phone;
  String _name;
  OnAddCustomer _onAddCustomer;

  @override
  void initState() {
    _phone = widget.phone;
    _onAddCustomer = widget.onAddCustomer;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Padding(
              padding: EdgeInsets.all(Dimen.kDefaultPadding - 10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Tạo mới khách hàng",
                        style: TextStyle(
                            color: ColorData.colorsBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: FontsName.textHelveticaNeueBold)),
                    SizedBox(height: 14),
                    _buildPhoneField(),
                    SizedBox(height: 14),
                    _buildNameField(),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: ButtonColorNormal(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              content: Text("Huỷ",
                                  style: TextStyle(
                                      color: ColorData.colorsWhite,
                                      fontFamily:
                                          FontsName.textHelveticaNeueRegular,
                                      fontSize: 14)),
                              colorData: ColorData.colorsBlack),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ButtonColorNormal(
                              onPressed: () {
                                _onAddCustomer(_phone, _name);
                              },
                              content: Text("Thêm",
                                  style: TextStyle(
                                      color: ColorData.colorsWhite,
                                      fontFamily:
                                          FontsName.textHelveticaNeueRegular,
                                      fontSize: 14)),
                              colorData: ColorData.primaryColor),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ))
      ],
    );
  }

  Widget _buildPhoneField() {
    return IgnorePointer(
      child: TextFieldOutline(
        isPassword: 0,
        height: 50,
        hintText: _phone,
        isCenter: false,
        isPhoneNumber: false,
        onChanged: (value) {
          _phone = value;
        },
      ),
    );
  }

  Widget _buildNameField() {
    return TextFieldOutline(
      isPassword: 0,
      height: 50,
      hintText: "Tên khách hàng",
      isCenter: false,
      isPhoneNumber: false,
      onChanged: (value) {
        _name = value;
      },
    );
  }
}
