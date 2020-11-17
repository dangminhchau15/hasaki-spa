import 'package:app/src/models/add_item_receipt_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

typedef OnItemClick(int index);

class ReceiptItem extends StatefulWidget {
  List<ServiceItem> data;
  int index;
  OnItemClick itemClick;

  ReceiptItem({this.data, this.index, this.itemClick});

  @override
  _ReceiptItemState createState() => _ReceiptItemState();
}

class _ReceiptItemState extends State<ReceiptItem> {
  @override
  Widget build(BuildContext context) {
    var totalPrice = double.parse(
            widget.data[widget.index].service.servicePrice.toString()) *
        widget.data[widget.index].qty;
    FlutterMoneyFormatter priceQuantityFmF =
        FlutterMoneyFormatter(amount: totalPrice);
    var priceFmf =
        double.parse(widget.data[widget.index].service.servicePrice.toString());
    FlutterMoneyFormatter priceFmF = FlutterMoneyFormatter(amount: priceFmf);

    var sku = "${widget?.data[widget?.index]?.sku}";
    var note = "${widget?.data[widget?.index]?.note}";
    var quantity = "${widget?.data[widget?.index]?.qty}";
    var serviceName = "${widget?.data[widget?.index]?.service?.serviceName}";
    var price = "${priceQuantityFmF?.output?.withoutFractionDigits}";
    var servicePrice = "${priceFmF?.output?.withoutFractionDigits}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 40, bottom: 20),
            child: Column(
              children: <Widget>[
                _itemConsultant("SKU: ", sku != null ? sku : 0),
                SizedBox(height: 10),
                _itemConsultant("Tên dịch vụ: ", serviceName != null ? serviceName : "N/A"),
                SizedBox(height: 10),
                _itemConsultant( "Giá bán: ", servicePrice != null ? servicePrice : 0),
                SizedBox(height: 10),
                _itemConsultant("Ghi chú: ", note != "null" ? note : "N/A"),
                SizedBox(height: 10),
                _itemConsultant("Số lượng: ", quantity != null ? quantity : 0),
                SizedBox(height: 10),
                _itemConsultant("Số tiền: ", price != null ? price : 0),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
                width: 36,
                height: 36,
                color: ColorData.colorsRed,
                child: InkWell(
                  onTap: () {
                    widget.itemClick(widget.index);
                  },
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget _itemConsultant(String title, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16, fontFamily: FontsName.textHelveticaNeueRegular),
          ),
        ),
        Expanded(
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
