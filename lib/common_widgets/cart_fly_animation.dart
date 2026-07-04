// cart_fly_animation.dart
import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';

class CartFlyAnimation {
  /// Call this from the button's own context (e.g. inside onTap).
  static void fly({
    required BuildContext buttonContext,
    required GlobalKey cartIconKey,
    Widget icon = const Icon(Icons.shopping_bag, color: Colors.white, size: 16),
    VoidCallback? onComplete,
  }) {
    final overlayState = Overlay.of(buttonContext);

    final RenderBox buttonBox = buttonContext.findRenderObject() as RenderBox;
    final startOffset = buttonBox.localToGlobal(buttonBox.size.center(Offset(0, -90))); // -90 as the image is above the + icon

    final RenderBox? cartBox =
        cartIconKey.currentContext?.findRenderObject() as RenderBox?;
    if (cartBox == null) return; // cart icon not mounted yet — bail safely

    final endOffset = cartBox.localToGlobal(cartBox.size.center(Offset.zero));

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _FlyingIcon(
        start: startOffset,
        end: endOffset,
        icon: icon,
        onComplete: () {
          entry.remove();
          onComplete?.call();
        },
      ),
    );

    overlayState.insert(entry);
  }
}

class _FlyingIcon extends StatefulWidget {
  final Offset start;
  final Offset end;
  final Widget icon;
  final VoidCallback onComplete;

  const _FlyingIcon({
    required this.start,
    required this.end,
    required this.icon,
    required this.onComplete,
  });

  @override
  State<_FlyingIcon> createState() => _FlyingIconState();
}

class _FlyingIconState extends State<_FlyingIcon> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _progress = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward().whenComplete(widget.onComplete);
    _scale = Tween<double>(begin: 1.0, end: 0.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut.flipped),// fast - slow -fast
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // // Quadratic Bezier — control point lifted above the midpoint for a natural arc
  // Offset _arcPosition(double t) {
    
  //   final mid = Offset.lerp(widget.start, widget.end, 0.5)!;
  //   final control = Offset(mid.dx, mid.dy - 120);
  //   final oneMinusT = 1 - t;
  //   return Offset(
  //     oneMinusT * oneMinusT * widget.start.dx + 2 * oneMinusT * t * control.dx + t * t * widget.end.dx,
  //     oneMinusT * oneMinusT * widget.start.dy + 2 * oneMinusT * t * control.dy + t * t * widget.end.dy,
  //   );
  // }
    Offset _hookPosition(double t) {
    final control = Offset(
      widget.start.dx + (widget.end.dx - widget.start.dx) * 0.15,
      widget.end.dy,
    );
    final oneMinusT = 1 - t;
    return Offset(
      oneMinusT * oneMinusT * widget.start.dx +
          2 * oneMinusT * t * control.dx +
          t * t * widget.end.dx,
      oneMinusT * oneMinusT * widget.start.dy +
          2 * oneMinusT * t * control.dy +
          t * t * widget.end.dy,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        final t = _progress.value;
        final pos = _hookPosition(_progress.value);
        // final pos = _arcPosition(t);
        // final scale = 1.0 - (t * 0.5); // shrinks as it nears the cart

        return Positioned(
          
          left: pos.dx - 40,
          top: pos.dy - 40,
          child: Transform.scale(
            scale: _scale.value,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.cardBackground, shape: BoxShape.circle),
                child: widget.icon,
              ),
            ),
          ),
        );
      },
    );
  }
}