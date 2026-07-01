import 'package:flutter/material.dart';

class OutwardCurve extends CustomClipper<Path> {
  final double x0, y0, x1, y1, x2, y2;
  OutwardCurve({
    required this.x0,
    required this.y0,
    required this.x1,
    required this.y1,
    required this.x2,
    required this.y2,
  });

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(x0, y0);

    path.quadraticBezierTo(x1, y1, x2, y2);

    path.lineTo(x2, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant OutwardCurve oldClipper) => false;
}
