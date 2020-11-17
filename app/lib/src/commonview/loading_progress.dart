import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../utils/color_util.dart';

class LoadingProgress extends StatelessWidget {
  const LoadingProgress({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: SpinKitFadingCircle(color: ColorData.primaryColor)),
    );
  }
}