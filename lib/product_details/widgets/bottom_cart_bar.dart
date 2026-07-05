import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/common_widgets/cart_fly_animation.dart';
import 'package:grocery_delivery_app/main.dart';
import 'package:grocery_delivery_app/models/product_model.dart';
import 'package:grocery_delivery_app/product_details/product_details_provider.dart';
import 'package:grocery_delivery_app/products/products_provider.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

/// Fixed bar at the bottom of the details screen: quantity stepper +
/// "Add to cart" button. The chosen quantity is committed to the cart in
/// one go when the fly animation lands.
class BottomCartBar extends StatelessWidget {
  final ProductModel product;

  const BottomCartBar({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final details = context.watch<ProductDetailsProvider>();
    final bottomInset =
        context.bottomBarHeight > 14 ? context.bottomBarHeight : 14.0;

    return Container(
      color: AppColors.cardBackground,
      padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
      child: Row(
        children: [
          _QuantityStepper(
            quantity: details.quantity,
            onDecrement: details.decrementQuantity,
            onIncrement: details.incrementQuantity,
          ),
          const SizedBox(width: 14),
          Expanded(
            // Builder gives the fly animation the button's own context to
            // measure its take-off position from.
            child: Builder(
              builder: (buttonContext) => GestureDetector(
                onTap: () => _addToCart(buttonContext, details),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        color: AppColors.primaryDark,
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Add to cart',
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addToCart(BuildContext buttonContext, ProductDetailsProvider details) {
    CartFlyAnimation.fly(
      buttonContext: buttonContext,
      cartIconKey: CartIconAnchor.key4,
      startAnchorOffset: Offset.zero, // take off from the button itself
      icon: Image.asset(product.image, height: 45, width: 45),
      onComplete: () => buttonContext.read<ProductsProvider>().updateCartCount(
            product,
            increment: true,
            quantity: details.quantity,
          ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onDecrement,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: quantity > 1 ? 1.0 : 0.4,
              child: const Icon(
                Icons.remove_circle_outline,
                color: AppColors.primaryDark,
                size: 26,
              ),
            ),
          ),
          SizedBox(
            width: 40,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Text(
                  '$quantity',
                  key: ValueKey(quantity),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: onIncrement,
            child: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryDark,
              size: 26,
            ),
          ),
        ],
      ),
    );
  }
}
