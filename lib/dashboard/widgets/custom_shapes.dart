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

/// Domes the TOP edge of a sheet upward at the center — the standalone
/// counterpart of [InwardCurve], used by bottom sheets so their top edge
/// matches the header dome.
class TopDomeCurve extends CustomClipper<Path> {
  /// How far the corners sit below the dome crest.
  final double drop;

  TopDomeCurve({required this.drop});

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, drop);

    // Control point mirrored above the corners puts the crest at y = 0.
    path.quadraticBezierTo(size.width / 2, -drop, size.width, drop);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TopDomeCurve oldClipper) => drop != oldClipper.drop;
}

/// The small grey arc that reads as a sheet pull-handle, bowing gently
/// downwards like the dome edge it sits under.
class DragHandleArc extends StatelessWidget {
  const DragHandleArc({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(52, 10),
      painter: _DragHandleArcPainter(),
    );
  }
}

class _DragHandleArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(0, 2)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, 2);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DragHandleArcPainter oldDelegate) => false;
}
