import 'package:app/src/blocs/profile_bloc.dart';
import 'package:app/src/commonview/button_color_normal.dart';
import 'package:app/src/commonview/textfield_outline.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileForm extends StatefulWidget {
  ProfileBloc bloc;

  ProfileForm({this.bloc});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  ProfileBloc _bloc;
  String _oldPass = "";
  String _newPass = "";
  String _confirmPass = "";

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOldPass(),
        SizedBox(height: 10),
        _buildNewPass(),
        SizedBox(height: 10),
        _buildConfirmPass(),
        SizedBox(height: 20),
        _buildConfirmButton()
      ],
    );
  }

  Widget _buildConfirmButton() {
    return ButtonColorNormal(
      content: Text("Xác Nhận",
          style: TextStyle(
              color: ColorData.colorsWhite,
              fontSize: 16,
              fontFamily: FontsName.textHelveticaNeueRegular)),
      colorData: ColorData.primaryColor,
      onPressed: () {},
    );
  }

  Widget _buildOldPass() {
    return StreamProvider.value(
      value: _bloc.oldPassStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextFieldOutline(
          errorText: msg,
          isPassword: 0,
          hintText: "Mật khẩu cũ",
          isPhoneNumber: false,
          onChanged: (value) {
            _oldPass = value;
            return _bloc.oldPassSink.add(value);
          },
        ),
      ),
    );
  }

  Widget _buildNewPass() {
    return StreamProvider.value(
      value: _bloc.newPassStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextFieldOutline(
          errorText: msg,
          isPassword: 0,
          hintText: "Mật khẩu mới",
          isPhoneNumber: false,
          onChanged: (value) {
            _newPass = value;
            return _bloc.newPassSink.add(value);
          },
        ),
      ),
    );
  }

  Widget _buildConfirmPass() {
    return StreamProvider.value(
      value: _bloc.confirmPassStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextFieldOutline(
          errorText: msg,
          isPassword: 0,
          hintText: "Xác nhận mật khẩu",
          isPhoneNumber: false,
          onChanged: (value) {
            _confirmPass = value;
            return _bloc.confirmPassSink.add(value);
          },
        ),
      ),
    );
  }
}
