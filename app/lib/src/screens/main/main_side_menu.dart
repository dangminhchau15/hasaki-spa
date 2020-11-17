import 'dart:async';

import 'package:app/src/blocs/main_bloc.dart';
import 'package:app/src/commonview/common_dialogs.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/screens/signin/sign_in_screen.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class MainSideMenu extends StatefulWidget {
  Function(int index) onMenuItemTap;

  String name;

  MainSideMenu({Key key, this.onMenuItemTap, this.name}) : super(key: key);

  @override
  _MainSideMenuState createState() => _MainSideMenuState();
}

class _MainSideMenuState extends State<MainSideMenu> {
  StreamSubscription logOutStream;
  MainBloc _mainBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_mainBloc == null) {
      _mainBloc = Provider.of<MainBloc>(context);
      logOutStream = _mainBloc.logOutStream.listen((onData) async {
        if (onData != null) {
          Fluttertoast.showToast(
              msg: "$onData",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1);
          await Future.delayed(Duration(milliseconds: 500));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SignInScreen()),
            (Route<dynamic> route) => false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.colorLightGrey,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(height: 140, child: _buildHeaderMenu()),
            Expanded(child: _buildMainMenu()),
            Container(height: 60, child: _buildLogoutButton(context))
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderMenu() {
    return Container(
        color: ColorData.primaryColor,
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 4, left: 10),
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
            Padding(
              padding: EdgeInsets.only(top: 50, left: 14),
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
                    widget.name,
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
        ));
  }

  Widget _buildMainMenu() {
    return ListView.separated(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      itemCount: 6,
      itemBuilder: (BuildContext context, int index) {
        switch (index) {
          case 0:
            return _menuItem(
                "Tư vấn",
                () => {
                      Navigator.pop(context),
                      widget.onMenuItemTap != null
                          ? widget.onMenuItemTap(index)
                          : null
                    },
                false);
            break;
          case 1:
            return _menuItem(
                "Đặt Lịch",
                () => {
                      Navigator.pop(context),
                      widget.onMenuItemTap != null
                          ? widget.onMenuItemTap(index)
                          : null
                    },
                false);
            break;
          case 2:
            return _menuItem(
                "Hóa Đơn",
                () => {
                      Navigator.pop(context),
                      widget.onMenuItemTap != null
                          ? widget.onMenuItemTap(index)
                          : null
                    },
                false);
            break;
          case 3:
            return _menuItem(
                "Phản Hồi",
                () => {
                      Navigator.pop(context),
                      widget.onMenuItemTap != null
                          ? widget.onMenuItemTap(index)
                          : null
                    },
                false);
            break;
        }
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }

  Widget _menuItem(String title, Function onPressed, bool isHaveBadge) {
    return GestureDetector(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        color: ColorData.colorsTransparent,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title,
                style: TextStyle(
                  color: ColorData.textGray,
                  fontFamily: FontsName.textHelveticaNeueMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return RaisedButton(
      splashColor: Colors.transparent,
      elevation: 0,
      color: Color(0xffEAEAEA),
      highlightElevation: 0,
      onPressed: () => _showDialogLogout(context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Đăng xuất", style: TextStyle(color: ColorData.textGray)),
            Container(
                height: 18,
                width: 18,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/ic_logout.png"),
                  fit: BoxFit.fill,
                )))
          ],
        ),
      ),
    );
  }

  _showDialogLogout(BuildContext context) async {
    showYesNoDialog(
        context, "Bạn thực sự muốn đăng xuất?", () => _mainBloc.logout(), null);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
