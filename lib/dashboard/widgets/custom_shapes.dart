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

/// The inverse of [OutwardCurve]: the bottom edge stays low at the corners
/// and rises as a dome towards the center, so the sheet below shows through
/// as an upward arc. Used by the product details header.
class InwardCurve extends CustomClipper<Path> {
  /// How far the dome crest rises above the bottom corners.
  final double depth;

  InwardCurve({required this.depth});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    // Control point sits 2*depth above the corners, putting the curve's
    // midpoint exactly `depth` above them.
    path.quadraticBezierTo(
      size.width / 2,
      size.height - 2 * depth,
      size.width,
      size.height,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant InwardCurve oldClipper) => depth != oldClipper.depth;
}
