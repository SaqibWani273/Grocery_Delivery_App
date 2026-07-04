import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/main.dart';
import 'package:grocery_delivery_app/models/product_model.dart';
import 'package:grocery_delivery_app/products/products_provider.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

import '../common_widgets/cart_fly_animation.dart';

final textStyle = TextStyle(
  color: AppColors.textPrimaryDark,
  fontWeight: FontWeight.bold,
  height: 1.2,
  fontSize: 15,
  fontFamily: GoogleFonts.aBeeZee().fontFamily,
);

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final GlobalKey cartIconKey;

  const ProductCard({super.key, required this.product, required this.cartIconKey});

  @override
  Widget build(BuildContext context) {
    final imgSize= context.deviceHeight*0.1;
    void flyAnimation(bool isAdding)=>CartFlyAnimation.fly(
      buttonContext: context,
      cartIconKey: cartIconKey,
      icon:  Image.asset(
        product.image,
        height: imgSize,
        width: imgSize,
      ),
      onComplete: () {
        // Add the product to the cart
        context.read<ProductsProvider>().updateCartCount(
          product,
          increment: isAdding

        );
      },
    );
    final int count = product.cartCount;
    final bool isSelected = count > 0;

    return Container(
      
      width: context.deviceWidth * 0.31,

      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 0)],
      ),

      child: Column(
        children: [
          // 1. Product Photo Image Layout
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(product.image,
              height: imgSize ,
              width: imgSize,
               fit: BoxFit.contain),
            ),
          ),

          // 2. Product Descriptive Information
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            product.weight,
            style: const TextStyle(
              color: AppColors.textSecondaryGrey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Stylized Numeric Pricing Breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                product.priceInt,
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(product.priceDec, style: textStyle),
            ],
          ),
          const SizedBox(height: 12),

          // 4. Cart Action Counter Buttons Layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: isSelected
                ? Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primaryAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () => context.read<ProductsProvider>().updateCartCount(
          product,
          increment: false

        ),
            child: const Icon(
              Icons.remove_circle_outline,
              color: AppColors.textAccentOrange,
              size: 20,
            ),
          ),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          GestureDetector(
            onTap: () => flyAnimation(true),
            child: const Icon(
              Icons.add_circle_outline,
              color: AppColors.primaryDark,
              size: 20,
            ),
          ),
        ],
      ),
    )
                : GestureDetector(
                  onTap: () => flyAnimation(true),
                  child: _buildInactiveAddButton()),
          ),
        ],
      ),
    );
  }

  // Green Active Counter (+ / - Selector)


  // Faded Grey Plus Add Button Setup
  Widget _buildInactiveAddButton() {
    return Container(
      height: 36,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryAccent.withAlpha(
          50,
        ), // Faded background tint layout
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.add, color: AppColors.primaryDark, size: 22),
    );
  }
}
