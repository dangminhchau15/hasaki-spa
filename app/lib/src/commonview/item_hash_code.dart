import 'package:app/src/commonview/custom_appbar.dart';
import 'package:app/src/models/item_model.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

class ItemHashCode extends StatefulWidget {
  List<ItemModel> items = List();
  int index;

  ItemHashCode({this.items, this.index});
  @override
  _ItemHashCodeState createState() => _ItemHashCodeState();
}

class _ItemHashCodeState extends State<ItemHashCode> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${widget.items[widget.index].title}", style: TextStyle(color: ColorData.colorsBlack),),
              SizedBox(height: 10,),
              Text("${widget.items[widget.index].address}"),
              SizedBox(height: 10,),
              Text("${widget.items[widget.index].date}"),
            ],
          ),
        ),
      ),
    );
  }
}
