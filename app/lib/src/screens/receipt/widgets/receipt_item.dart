import 'package:app/src/models/get_iist_store_response.dart';
import 'package:app/src/models/receipt_list_response.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class ReceiptListItem extends StatefulWidget {
  List<ReceiptList> data;
  List<Store> stores;
  int index;

  ReceiptListItem({this.data, this.stores, this.index});

  @override
  _ReceiptItemContent createState() => _ReceiptItemContent();
}

class _ReceiptItemContent extends State<ReceiptListItem> {
  List<ReceiptList> data;
  List<Store> stores;
  int index;

  @override
  void initState() {
    data = widget.data;
    index = widget.index;
    stores = widget.stores;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bankReceiptBankId = data[index].receiptBankaccId;
    var note = data[index].receiptDesc;
    var totalPrice = double.parse(data[index].receiptTotal.toString());
    
    FlutterMoneyFormatter priceQuantityFmF = FlutterMoneyFormatter(amount: totalPrice);
    return Stack(
      children: [
        Column(
          children: [
            _itemRow(
                "ID: ",
                bankReceiptBankId == 0
                    ? bankReceiptBankId?.toString()
                    : "N/A"),
            SizedBox(height: 10),
            _itemRow("Ghi chú: ", note != "" ? note : "N/A"),
            SizedBox(height: 10),
            _itemRow("Cửa hàng: ", "SHOP-555BTH"),
            SizedBox(height: 10),
            _itemRow("Người dùng",
                "${data[index].user.name}\n(ID: ${data[index].user.id})"),
            SizedBox(height: 10),
            _itemRow(
                "Tổng tiền: ",
                priceQuantityFmF?.output?.withoutFractionDigits != "0"
                    ? "${priceQuantityFmF?.output?.withoutFractionDigits}"
                    : "N/A"),
          ],
        )
      ],
    );
  }

  Widget _itemRow(String title, String value) {
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
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            softWrap: true,
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
