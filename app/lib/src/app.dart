import 'package:app/src/blocs/check_screen_bloc.dart';
import 'package:app/src/screens/main/main_screen.dart';
import 'package:app/src/screens/signin/sign_in_screen.dart';
import 'package:app/src/screens/splash/splash_screen.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final GlobalKey<NavigatorState> nav = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  CheckScreenBloc _checkScreenBloc;

  @override
  void initState() {
    super.initState();
    _checkScreenBloc = CheckScreenBloc();
    _checkScreenBloc.checkScreen();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            appBarTheme: AppBarTheme(
                iconTheme: IconThemeData(color: ColorData.colorsWhite)),
            cardTheme: CardTheme(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            fontFamily: FontsName.textHelveticaNeueRegular,
            primaryColor: ColorData.primaryColor,
            accentColor: Colors.black.withOpacity(0.4),
            textTheme: TextTheme(
              body1: TextStyle(
                  fontSize: FontsSize.normal,
                  color: ColorData.colorsBlack.withOpacity(0.6)),
            )),
        home: StreamBuilder<StatePage>(
            stream: _checkScreenBloc.inputCodeSubject.stream,
            initialData: StatePage.INIT,
            builder: (context, snapshot) {
              return handlePage(snapshot.data);
            }),
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        });
  }

  handlePage(StatePage data) {
    switch (data) {
      case StatePage.INIT:
        return SplashScreen();
        break;
      case StatePage.SIGIN:
        return SignInScreen();
        break;
      case StatePage.MAIN:
        return MainScreen();
        break;
      default:
        break;
    }
  }
}
