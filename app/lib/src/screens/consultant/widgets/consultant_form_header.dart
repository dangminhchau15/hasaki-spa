import 'package:app/src/blocs/consultant_bloc.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/commonview/extension_widget.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

typedef OnSearchConsultant(String date, String phone, int status);

class ConsultanFormHeader extends StatefulWidget {
  OnSearchConsultant onSearchConsultant;

  ConsultanFormHeader({this.onSearchConsultant});

  @override
  _ConsultanFormHeaderState createState() => _ConsultanFormHeaderState();
}

class _ConsultanFormHeaderState extends State<ConsultanFormHeader> {
  ConsultantBloc _bloc;
  String _statusDropdownValue;
  OnSearchConsultant _onSearchConsultant;
  DateTime _selectedDate = DateTime.now();
  String _date = "";
  String _phone = "";
  int _status = 0;
  bool _isHasPhone = false;

  @override
  void initState() {
    super.initState();
    _date = "${_selectedDate.toLocal()}".split(' ')[0];
    _onSearchConsultant = widget.onSearchConsultant;
    _statusDropdownValue = "-Chọn trạng thái-";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDatePickerField(),
          SizedBox(height: 6),
          _buildPhoneField(),
          SizedBox(height: 6),
          _buildStatusCombobox(size),
          SizedBox(height: 20),
          _buildButtonSubmit()
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return TextFieldOutline(
        hintText: "Số điện thoại khách hàng",
        isPhoneNumber: true,
        isPassword: 0,
        stringAssetIconRight: _phone.isNotEmpty ? "assets/images/ic_circle_close_icon.png" : null,
        onIconClickListener: (controller) {
          if (_phone.isNotEmpty) {
            setState(() {
              _phone = "";
            });
            controller.clear();
          }
        },
        onChanged: (value) {
          setState(() {
            _phone = value;
          });
        });
  }

  Widget _buildButtonSubmit() {
    return ButtonColorNormal(
      content: Text("Tìm kiếm",
          style: TextStyle(
              color: ColorData.colorsWhite, fontWeight: FontWeight.bold)),
      colorData: ColorData.primaryColor,
      onPressed: () {
        _onSearchConsultant(_date, _phone, _status);
      },
    );
  }

  Widget _buildStatusCombobox(Size size) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: combobox(<String>[
        "-Chọn trạng thái-",
        "Tất cả trạng thái",
        "Chờ xử lý",
        "Hoàn tất"
      ], size, 0, _statusDropdownValue, context, (value) {
        switch (value) {
          case "Tất cả trạng thái":
            _status = 0;
            break;
          case "Chờ xử lý":
            _status = 1;
            break;
          case "Hoàn tất":
            _status = 2;
            break;
        }
      }),
    );
  }

  Widget _buildDatePickerField() {
    return InkWell(
      onTap: () {
        showDatePickerDialog(context, true, _selectedDate, (value) {
          setState(() {
            _selectedDate = value;
            _date = "${_selectedDate.toLocal()}".split(' ')[0];
          });
        });
      },
      child: IgnorePointer(
        child: TextFieldOutline(
          hintText: "${_selectedDate.toLocal()}".split(' ')[0],
          isPassword: 0,
          onIconClickListener: (controller) {},
          stringAssetIconRight: "assets/images/ic_calendar.png",
          onChanged: (value) {
            "${_selectedDate.toLocal()}".split(' ')[0] = value;
            _date = "${_selectedDate.toLocal()}".split(' ')[0];
          },
        ),
      ),
    );
  }
}
