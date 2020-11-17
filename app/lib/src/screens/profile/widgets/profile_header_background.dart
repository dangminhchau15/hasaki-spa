import 'dart:math';

import 'package:app/src/utils/color_util.dart';
import 'package:flutter/material.dart';

class ProfileHeaderBackground extends CustomPainter {
  final Color color;
  final double avatarRadius;

  ProfileHeaderBackground({@required this.color, @required this.avatarRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final shapeBounds = Rect.fromLTRB(0, 0, size.width, size.height - avatarRadius);
    final centerAvatar = Offset(shapeBounds.center.dx, shapeBounds.bottom);
    final avatarBounds = Rect.fromCircle(center: centerAvatar, radius: avatarRadius).inflate(6);
    _drawnBackground(canvas, shapeBounds, avatarBounds);
    _drawCurveShape(canvas, shapeBounds, avatarBounds);
  }

  void _drawnBackground(Canvas canvas, Rect shapeBound, Rect avatarBounds) {
    final Paint paint = Paint()..color = color;
    final Path path = Path()
      ..moveTo(shapeBound.top, shapeBound.left)
      ..lineTo(shapeBound.bottomLeft.dx, shapeBound.bottomLeft.dy)
      ..arcTo(avatarBounds, -pi, pi, false)
      ..lineTo(shapeBound.bottomRight.dx, shapeBound.bottomRight.dy)
      ..lineTo(shapeBound.topRight.dx, shapeBound.topRight.dy)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _drawCurveShape(Canvas canvas, Rect bounds, Rect avatarBounds) {
    final paint = Paint()..color = ColorData.primaryColor;
    final handlePoint = Offset(bounds.left + (bounds.width * 0.15), bounds.top);
    final curvePath = Path()
      ..moveTo(bounds.bottomLeft.dx, bounds.bottomLeft.dy)
      ..arcTo(avatarBounds, -pi, pi, false)
      ..lineTo(bounds.bottomRight.dx, bounds.bottomRight.dy)
      ..lineTo(bounds.topRight.dx, bounds.topRight.dy)
      ..quadraticBezierTo(handlePoint.dx, handlePoint.dy, bounds.bottomLeft.dx,
          bounds.bottomLeft.dy)
      ..close();
    canvas.drawPath(curvePath, paint);
  }

  @override
  bool shouldRepaint(covariant ProfileHeaderBackground oldDelegate) {
    return color != oldDelegate.color;
  }
}
