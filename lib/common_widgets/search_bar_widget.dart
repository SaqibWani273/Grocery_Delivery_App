

import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/products/products_provider.dart';
import 'package:provider/provider.dart';

class SearchBarWidget extends StatelessWidget {
  final double? height;
  const SearchBarWidget({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search_bar',
     
      child:  Material(
        type: MaterialType.transparency,
        child : Container(
         height: height ?? 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Icon(Icons.search, color: Colors.grey),
              ),
              Text(
                'Search for "Grocery"',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      )
    );
  }
}

class CartIcon extends StatelessWidget {
  final GlobalKey cartKey;
  // Disable when another CartIcon on the same route already owns the
  // 'cart_icon' hero tag (duplicate tags break route transitions).
  final bool enableHero;
  const CartIcon({super.key, required this.cartKey, this.enableHero = true});

  @override
  Widget build(BuildContext context) {
    int cartCount = context.watch<ProductsProvider>().cartItemsCountNotifier.value;
    final icon = Material(
       type: MaterialType.transparency,
      child: Stack(
        key:cartKey,
        // alignment: Alignment.topRight,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.primaryDark,
            ),
          ),
          if( cartCount>0 )
          Positioned(
            right: 4,
            top: 4,
            child: CartBadge(
              count: cartCount,
            ),
          ),
        ],
      ),
    );

    if (!enableHero) return icon;
    return Hero(
      tag: 'cart_icon',
      child: icon,
    );
  }
}

class CartBadge extends StatefulWidget {
  final int count;
  const CartBadge({super.key, required this.count});

  @override
  State<CartBadge> createState() => _CartBadgeState();
}

class _CartBadgeState extends State<CartBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _bounce =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 250));

  @override
  void didUpdateWidget(covariant CartBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.count != oldWidget.count) {
      _bounce.forward(from: 0).then((_) => _bounce.reverse());
    }
  }

  @override
  void dispose() {
    _bounce.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.35).animate(CurvedAnimation(parent: _bounce, curve: Curves.easeOut)),
      child:
       CircleAvatar(
        radius: 8,
        backgroundColor: Colors.red,
        child: Text('${widget.count}', style: const TextStyle(fontSize: 11, color: Colors.white)),
      ),
    );
  }
}