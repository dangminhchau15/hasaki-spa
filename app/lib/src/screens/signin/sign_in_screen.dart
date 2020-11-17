import 'dart:async';

import 'package:app/src/base/base_event.dart';
import 'package:app/src/blocs/sign_in_bloc.dart';
import 'package:app/src/commonview/background_color.dart';
import 'package:app/src/commonview/bloc_listener.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/dataresources/data_repository.dart';
import 'package:app/src/eventstate/sign_in_event.dart';
import 'package:app/src/eventstate/sign_in_event_success.dart';
import 'package:app/src/screens/main/main_screen.dart';
import 'package:app/src/utils/api_subscription.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/font_size.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Provider<SignInBloc>.value(
          value: SignInBloc(),
          child: Consumer<SignInBloc>(
              builder: (context, bloc, child) => SignInForm(
                    bloc: bloc,
                  )),
        ));
  }
}

class SignInForm extends StatefulWidget {
  SignInBloc bloc;

  SignInForm({Key key, this.bloc}) : super(key: key);

  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  SignInBloc bloc;
  String _email = "";
  String _password = "";
  StreamSubscription streamLoading;
  bool _emptyString = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = widget.bloc;
    streamLoading = apiSubscription(bloc.loadingStream, context, null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        BackgroundColor(
          colorData: ColorData.primaryColor,
        ),
        BlocListener<SignInBloc>(
          listener: handleEvent,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
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
                  SizedBox(
                    height: 30,
                  ),
                  Text("Hasaki Spa",
                      style: TextStyle(
                          color: ColorData.colorsWhite,
                          fontSize: FontsSize.xxlarge,
                          fontFamily: FontsName.textHelveticaNeueBold,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                  ),
                  _buildEmailField(),
                  SizedBox(height: 20),
                  _buildPassField(),
                  SizedBox(height: 40),
                  _buildSubmitButton()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return StreamProvider<bool>.value(
        initialData: false,
        value: bloc.btnStream,
        child: Consumer<bool>(builder: (context, enable, _) {
          return ButtonColorNormal(
            onPressed: () {
              _handlePressButton(enable);
            },
            colorData: ColorData.colorsWhite,
            content: Text(
              "Đăng Nhập",
              style: TextStyle(
                  color: ColorData.primaryColor,
                  fontFamily: FontsName.textRobotoMedium,
                  fontSize: FontsSize.large),
            ),
            border: 30,
          );
        }));
  }

  _handlePressButton(bool enable) {
    bloc.emailSink.add(_email);
    bloc.passSink.add(_password);
    if (enable) {
      bloc.event.add(SignInEvent(email: _email, password: _password));
    }
  }

  Widget _buildEmailField() {
    return StreamProvider.value(
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextFieldOutline(
          stringAssetIconRight: _email.isNotEmpty
              ? "assets/images/ic_circle_close_icon.png"
              : "assets/images/ic_email.png",
          errorText: msg,
          isPassword: 0,
          hintText: "Email",
          onIconClickListener: (controller) {
            if (_email.isNotEmpty) {
              setState(() {
                _email = "";
              });
              controller.clear();
            }
            return bloc.emailSink.add("");
          },
          isPhoneNumber: false,
          onChanged: (value) {
            setState(() {
              _email = value;
            });
            return bloc.emailSink.add(value);
          },
        ),
      ),
    );
  }

  Widget _buildPassField() {
    return StreamProvider.value(
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextFieldOutline(
          stringAssetIconRight: _password.isNotEmpty
              ? "assets/images/ic_circle_close_icon.png"
              : "assets/images/ic_password.png",
          errorText: msg,
          isPassword: 1,
          onIconClickListener: (controller) {
            if (_password.isNotEmpty) {
              setState(() {
                _password = "";
              });
              controller.clear();
            }
            return bloc.passSink.add("");
          },
          hintText: "Mật khẩu",
          isPhoneNumber: false,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
            return bloc.passSink.add(value);
          },
        ),
      ),
    );
  }

  void handleEvent(BaseEvent event) {
    if (event is SignInEventSucess) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    }
  }
}
