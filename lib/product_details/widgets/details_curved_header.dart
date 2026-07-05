import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/common_widgets/search_bar_widget.dart';
import 'package:grocery_delivery_app/dashboard/widgets/custom_shapes.dart';
import 'package:grocery_delivery_app/main.dart';

/// Fixed (non-collapsing) pinned header for the product details screen.
/// Unlike the dashboard header, the dark shape curves inward — the white
/// sheet below rises as a dome towards the center, with the pull-handle
/// arc resting just under the crest.
class DetailsCurvedHeader extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;

  DetailsCurvedHeader({required this.statusBarHeight});

  static const double _rowHeight = 56.0;
  static const double _curveZone = 54.0;
  static const double _curveDepth = 42.0;

  @override
  double get maxExtent => statusBarHeight + _rowHeight + _curveZone;

  @override
  double get minExtent => maxExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: InwardCurve(depth: _curveDepth),
            child: Container(color: AppColors.primaryDark),
          ),
        ),

        // Pull-handle arc, pinned just below the dome crest.
        Positioned(
          left: 0,
          right: 0,
          bottom: _curveDepth - 24,
          child: Center(
            child: CustomPaint(
              size: const Size(52, 10),
              painter: _DragHandlePainter(),
            ),
          ),
        ),

        Positioned(
          top: statusBarHeight,
          left: 16,
          right: 16,
          height: _rowHeight,
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Text(
                'Product Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryLight,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20,
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms, curve: Curves.easeIn)
                    .scale(duration: 200.ms, curve: Curves.easeIn),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: CartIcon(cartKey: CartIconAnchor.key4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant DetailsCurvedHeader oldDelegate) =>
      statusBarHeight != oldDelegate.statusBarHeight;
}

class _DragHandlePainter extends CustomPainter {
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
  bool shouldRepaint(covariant _DragHandlePainter oldDelegate) => false;
}
