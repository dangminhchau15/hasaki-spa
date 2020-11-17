import 'package:app/src/models/consultant_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

class ConsultantRow extends StatefulWidget {
  List<Consultant> consultants;
  int index;

  ConsultantRow({this.consultants, this.index});

  @override
  _ConsultantRowState createState() => _ConsultantRowState();
}

class _ConsultantRowState extends State<ConsultantRow> {
  List<Consultant> _consultants;
  int _index;

  @override
  void initState() {
    super.initState();
    _consultants = widget.consultants;
    _index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    var customerId = _consultants[_index].customer.customerId;
    var updatedBy = _consultants[_index].editingby.name;
    var createdBy = _consultants[_index].user.name;
    var updatedDate = _consultants[_index].updatedAt;
    var receiptCode = _consultants[_index].receiptCode;

    return Column(
      children: [
        _buildItemRow("Mã khách hàng: ", customerId.toString()),
        SizedBox(height: 10),
        _buildItemRow("Tạo bởi: ", createdBy),
        SizedBox(height: 10),
        _buildItemRow("Cập nhật ngày: ", updatedDate),
        SizedBox(height: 10),
        _buildItemRow("Cập nhật bởi: ", updatedBy),
        SizedBox(height: 10),
        _buildItemRow("Mã hóa đơn: ", receiptCode != null ? receiptCode.toString() : "N/A"),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildItemRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
        ),
        Padding(
          padding: EdgeInsets.only(right: 40),
          child: Text(
            value,
            style: TextStyle(
                fontSize: 16,
                color: ColorData.colorsBlack,
                fontWeight: FontWeight.bold,
                fontFamily: FontsName.textHelveticaNeueBold),
          ),
        ),
      ],
    );
  }
}
