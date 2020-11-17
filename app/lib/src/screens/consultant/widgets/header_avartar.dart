import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/dimen.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

class HeaderAvartar extends StatelessWidget {
  final String name;
  final String phone;
  final int customerId;

  const HeaderAvartar(
      {Key key, @required this.size, this.name, this.phone, this.customerId})
      : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        boxShadow: [
          new BoxShadow(
            color: ColorData.colorLightGrey,
            blurRadius: 20.0,
          ),
        ],
      ),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: EdgeInsets.all(Dimen.kDefaultPadding),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: Dimen.sizeComponent + 20,
                    height: Dimen.sizeComponent + 20,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage('assets/images/ic_avatar_consultant.png'),
                    )),
                SizedBox(height: 12),
                Text(
                  name,
                  style: TextStyle(
                      color: ColorData.colorsBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: FontsName.textHelveticaNeueBold),
                ),
                SizedBox(height: 12),
                Text("$phone(ID: $customerId)",
                    style: TextStyle(
                        color: ColorData.colorsBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: FontsName.textHelveticaNeueBold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
