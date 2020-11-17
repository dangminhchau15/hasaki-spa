import 'package:flutter/material.dart';

class BackgroundColor extends StatelessWidget {
  final Color colorData;
  BackgroundColor({Key key, @required this.colorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorData,
    );
  }
}