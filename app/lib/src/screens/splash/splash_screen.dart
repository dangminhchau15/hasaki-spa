import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            color: ColorData.primaryColor,
            child: Padding(
              padding: EdgeInsets.only(top: 120),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: ColorData.colorsWhite),
                        child: Center(
                          child: Image.asset(
                            "assets/images/hasaki_logo.png",
                            width: 50,
                            height: 50,
                          ),
                        )),
                    SizedBox(height: 14),
                    Text("Hasaki Spa",
                        style: TextStyle(
                            color: ColorData.colorsWhite,
                            fontSize: FontsSize.xxlarge,
                            fontFamily: FontsName.textHelveticaNeueBold,
                            fontWeight: FontWeight.bold))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
