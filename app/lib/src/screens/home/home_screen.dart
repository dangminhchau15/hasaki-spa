import 'package:app/src/commonview/curve_painter.dart';
import 'package:app/src/screens/booking/booking_screen.dart';
import 'package:app/src/screens/consultant/consultant_screen.dart';
import 'package:app/src/screens/question/question_recepit_screen.dart';
import 'package:app/src/screens/receipt/receipt_screen.dart';
import 'package:app/src/services/fcm_service.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

import '../../utils/color_util.dart';
import '../../utils/color_util.dart';

class HomeScreen extends StatefulWidget {
  String name;
  GlobalKey<InnerDrawerState> innerDrawerKey;

  HomeScreen({this.name, this.innerDrawerKey});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name;
  GlobalKey<InnerDrawerState> innerDrawerKey;

  @override
  void initState() {
    super.initState();
    name = widget.name;
    innerDrawerKey = widget.innerDrawerKey;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CustomPaint(
            child: Container(
              height: 160.0,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      innerDrawerKey.currentState.toggle();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, bottom: 40),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            border: Border.all(color: ColorData.colorsWhite),
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                            child: Image.asset(
                          "assets/images/ic_person_white.png",
                          width: 30,
                          height: 30,
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 40, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Xin Chào",
                          style: TextStyle(
                              color: ColorData.colorsWhite,
                              fontFamily: FontsName.textHelveticaNeueRegular,
                              fontSize: 14),
                        ),
                        SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                              color: ColorData.colorsWhite,
                              fontWeight: FontWeight.bold,
                              fontFamily: FontsName.textHelveticaNeueRegular,
                              fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            painter: CurvePainter(),
          ),
          Expanded(
            child: Container(
                alignment: Alignment.topLeft,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                child: GridView.count(
                  crossAxisCount: 2,
                  children: [
                    _itemMain(ConsultantScreen(),
                        "assets/images/ic_consultant.png", "Tư Vấn"),
                    _itemMain(BookingScreen(), "assets/images/ic_booking.png",
                        "Đặt Lịch"),
                    _itemMain(ReceiptScreen(), "assets/images/ic_receipt.png",
                        "Hoá Đơn"),
                    _itemMain(QuestionReceiptScreen(),
                        "assets/images/ic_feedback.png", "Phản Hồi")
                  ],
                )),
          ),
          FirebaseMessage()
        ],
      ),
    );
  }

  Widget _itemMain(Widget navigatorScreen, String imageUrl, String title) {
    return GestureDetector(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => navigatorScreen),
            ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: ColorData.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  imageUrl,
                  width: MediaQuery.of(context).size.width / 12,
                  height: MediaQuery.of(context).size.height / 12,
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                      color: ColorData.colorsWhite,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ));
  }
}
