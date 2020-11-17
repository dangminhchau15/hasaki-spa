import 'package:app/src/screens/profile/widgets/profile_header_background.dart';
import 'package:app/src/utils/color_util.dart';
import 'package:app/src/utils/fonts_name.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final Color profileColor;
  static const double avatarRadius = 48;
  static const double titleBottomMargin = (avatarRadius * 2) + 40;
  final String name;
  final String locationAddress;

  ProfileHeader({this.profileColor, this.name, this.locationAddress});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          size: Size.infinite,
          painter: ProfileHeaderBackground(
              color: profileColor, avatarRadius: avatarRadius),
        ),
        Positioned(
          right: 0,
          left: 0,
          bottom: titleBottomMargin,
          child: Column(
            children: [
              Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorData.colorsWhite,
                    fontFamily: FontsName.textHelveticaNeueBold,
                    fontSize: 16),
              ),
              SizedBox(height: 4,),
              Text(
                locationAddress,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: ColorData.colorsWhite,
                    fontFamily: FontsName.textHelveticaNeueBold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CircleAvatar(
            radius: avatarRadius,
            backgroundColor: ColorData.colorsWhite,
            backgroundImage: AssetImage('assets/images/hasaki_logo.png'),
          ),
        )
      ],
    );
  }
}
