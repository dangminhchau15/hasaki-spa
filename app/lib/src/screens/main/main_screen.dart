import 'dart:async';
import 'dart:io';
import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/main_bloc.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/dataresources/remote/preference_provider.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/eventstate/get_profile_event.dart';
import 'package:app/src/eventstate/get_profile_event_success.dart';
import 'package:app/src/eventstate/get_total_notify_event.dart';
import 'package:app/src/eventstate/get_total_notify_event_success.dart';
import 'package:app/src/eventstate/register_notify_event.dart';
import 'package:app/src/eventstate/register_notify_event_success.dart';
import 'package:app/src/libsresource/fancy_bottom_navigation.dart';
import 'package:app/src/screens/booking/booking_screen.dart';
import 'package:app/src/screens/consultant/consultant_screen.dart';
import 'package:app/src/screens/home/home_screen.dart';
import 'package:app/src/screens/main/main_side_menu.dart';
import 'package:app/src/screens/notification/notification_screen.dart';
import 'package:app/src/screens/profile/profile_screen.dart';
import 'package:app/src/screens/question/question_recepit_screen.dart';
import 'package:app/src/screens/receipt/receipt_screen.dart';
import 'package:app/src/screens/signin/sign_in_screen.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Provider<MainBloc>.value(
        value: MainBloc(
            PreferenceProvider.getString(SharePrefNames.USER_NAME, def: "")),
        child: Consumer<MainBloc>(
          builder: (context, bloc, child) => MainContent(
            bloc: bloc,
          ),
        ),
      ),
    );
  }
}

class MainContent extends StatefulWidget {
  MainBloc bloc;

  MainContent({
    Key key,
    this.bloc,
  }) : super(key: key);

  _MainContentState createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  StreamSubscription loadingStream;
  MainBloc bloc;
  PageController _pageController;
  GlobalKey<InnerDrawerState> _innerDrawerKey;
  GlobalKey _globalKey;
  int count = 0;
  int totalBagde = 0;
  bool isLoadedName = false;
  String name = "";

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
    bloc.event.add(GetProfileEvent(dataStore: "0"));
    loadingStream = apiSubscription(bloc.loadingStream, context, null);
    _pageController = PageController(initialPage: 0);
    _globalKey = GlobalKey(debugLabel: "page");
    _innerDrawerKey = GlobalKey<InnerDrawerState>();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc>(
      listener: handleEvent,
      child: StreamBuilder(
        initialData: false,
        stream: bloc.loadedNameStream,
        builder: (context, snapshot) =>
            snapshot.hasData ? _buildDrawer(name) : _buildDrawer("Tài khoản"),
      ),
    );
  }

  Widget _buildDrawer(String name) {
    return InnerDrawer(
      key: _innerDrawerKey,
      onTapClose: true,
      // default false
      swipe: true,
      // default true
      duration: Duration(seconds: 2),
      //When setting the vertical offset, be sure to use only top or bottom
      offset: IDOffset.horizontal(0.8),

      // DEPRECATED:  use scale
      leftScale: 0.9,
      // Will be removed in 0.6.0 version
      rightScale: 0.9,
      // Will be removed in 0.6.0 version

      scale: IDOffset.horizontal(1),
      // set the offset in both directions

      proportionalChildArea: true,
      // default true
      leftAnimationType: InnerDrawerAnimation.static,
      // default static
      rightAnimationType: InnerDrawerAnimation.quadratic,
      // default  Theme.of(context).backgroundColor

      //when a pointer that is in contact with the screen and moves to the right or left
      onDragUpdate: (double val, InnerDrawerDirection direction) {},
      innerDrawerCallback: (a) => print("MainSideMenu$a"),
      // return  true (open) or false (close)
      leftChild: MainSideMenu(
          name: name,
          onMenuItemTap: (index) async {
            print("MainSideMenu$index");
            switch (index) {
              case 0:
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConsultantScreen()),
                );
                break;
              case 1:
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookingScreen()),
                );
                break;
              case 2:
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReceiptScreen()),
                );
                break;
              case 3:
                await Future.delayed(Duration(milliseconds: 300));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionReceiptScreen()),
                );
                break;
            }
          }),
      // required if rightChild is not set
      //  A Scaffold is generally used but you are free to use other widgets
      // Note: use "automaticallyImplyLeading: false" if you do not personalize "leading" of Bar
      scaffold: _buildMainScreen(_innerDrawerKey, name),
    );
  }

  Widget _buildMainScreen(
      GlobalKey<InnerDrawerState> innerDrawerKey, String name) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: <Widget>[
            isLoadedName
                ? HomeScreen(
                    innerDrawerKey: innerDrawerKey,
                    name: name,
                  )
                : Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lấy thông tin profile thất bại vui lòng đăng nhập lại",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: ColorData.textGray,
                              fontSize: 14,
                              fontFamily: FontsName.textHelveticaNeueBold),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        ButtonColorNormal(
                          onPressed: () async {
                            bloc.logout();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()),
                              (Route<dynamic> route) => false,
                            );
                          },
                          content: Text(
                            "Đăng Xuất",
                            style: TextStyle(color: ColorData.colorsWhite),
                          ),
                          colorData: ColorData.primaryColor,
                        )
                      ],
                    ),
                  ),
            NotificationScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: StreamBuilder(
            initialData: false,
            stream: bloc.loadTotalStream,
            builder: (context, snapshot) => snapshot.hasData
                ? _buildNavigationBottom(totalBagde)
                : _buildNavigationBottom(0)));
  }

  Widget _buildNavigationBottom(int totalBagde) {
    return FancyBottomNavigation(
      totalBagde: totalBagde,
      key: _globalKey,
      tabs: [
        TabData(iconData: Icons.home, title: "Trang Chủ", haveNotify: false),
        TabData(
            iconData: Icons.notifications,
            title: "Thông Báo",
            haveNotify: true),
        TabData(
            iconData: Icons.account_circle,
            title: "Tài Khoản",
            haveNotify: false)
      ],
      pageController: _pageController,
    );
  }

  void handleEvent(BaseEvent event) async{
    if (event is GetProfileEventSuccess) {
      //call api get total notify
      name = event.profileResponse.data.profile.name;
      bloc.event.add(GetTotalNotifyEvent(appId: 8));
      bloc.loadedNameSink.add(true);
      await PreferenceProvider.load();
      PreferenceProvider.setInt(SharePrefNames.STORE_ID, event.profileResponse.data.profile.storeId);
      setState(() {
        isLoadedName = true;
      });
    } else if (event is GetTotalNotifyEventSuccess) {
      totalBagde = event.getTotalNotifyResponse.data.total;
      bloc.loadTotalSink.add(true);
      bloc.event.add(RegisterNotifyEvent(
        appId: 8,
        token: PreferenceProvider.getString(SharePrefNames.FCM_TOKEN, def: ""),
        deviceType: Platform.isIOS ? "1" : "2"
      ));
    } else if(event is RegisterNotifyEventSuccess) {

    }
  }
}
