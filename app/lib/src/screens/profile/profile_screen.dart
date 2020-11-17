import 'dart:async';
import 'package:app/src/blocs/profile_bloc.dart';
import 'package:app/src/dataresources/remote/share_preference_name.dart';
import 'package:app/src/screens/profile/widgets/profile_form.dart';
import 'package:app/src/screens/profile/widgets/profile_header.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/profile_bloc.dart';
import '../../dataresources/remote/preference_provider.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Provider<ProfileBloc>.value(
          value: ProfileBloc(
              PreferenceProvider.getString(SharePrefNames.USER_NAME)),
          child: Consumer<ProfileBloc>(
            builder: (context, bloc, child) => ProfileScreenContent(),
          )),
    );
  }
}

class ProfileScreenContent extends StatefulWidget {
  @override
  _ProfileContentScreenState createState() => _ProfileContentScreenState();
}

class _ProfileContentScreenState extends State<ProfileScreenContent> {
  ProfileBloc bloc;
  StreamSubscription _loadListLocationStream;
  String _oldPass = "";
  String _newPass = "";
  String _confirmPass = "";
  String _username = "Tên Nhân Viên";
  String _locationAddress = "Địa chỉ làm việc";
  int _locationId;
  static const _profileCardHeight = 260.0;

  @override
  void initState() {
    super.initState();
    _username = PreferenceProvider.getString(SharePrefNames.STAFF_NAME, def: "");
    _locationId = PreferenceProvider.getInt(SharePrefNames.LOCATION_ID, def: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (bloc == null) {
      bloc = ProfileBloc(PreferenceProvider.getString(SharePrefNames.USER_NAME));
      bloc.getListLocation();
      _loadListLocationStream = bloc.getListLocationStream.listen((onData) {
        for (var item in onData.data.rows) {
          if (_locationId == item.id) {
            setState(() {
              _locationAddress = item.name;
            });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _loadListLocationStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox.expand(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                vertical: _profileCardHeight + 30, horizontal: 16),
            child: ProfileForm(
              bloc: bloc,
            ),
          ),
          Container(
            height: _profileCardHeight,
            child: ProfileHeader(
              name: _username,
              locationAddress: _locationAddress,
              profileColor: ColorData.colorTwo,
            ),
          )
        ],
      ),
    ));
  }
}
