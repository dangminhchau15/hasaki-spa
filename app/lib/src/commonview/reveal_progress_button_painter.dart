import 'dart:math';

import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

class RevealProgressButtonPainter extends CustomPainter {
  double _fraction = 0.0;
  Size _screenSize;

  RevealProgressButtonPainter(this._fraction, this._screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = ColorData.primaryColor
      ..style = PaintingStyle.fill;

    // todo Fix this
    // This solution is hardcoded,
    // because I know the exact widget position
    var finalRadius = sqrt(pow(_screenSize.width / 2, 2) +
        pow(_screenSize.height - 32.0 - 48.0, 2));
    var radius = 24.0 + finalRadius * _fraction;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), radius, paint);
  }

  @override
  bool shouldRepaint(RevealProgressButtonPainter oldDelegate) {
    return oldDelegate._fraction != _fraction;
  }
}