import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/models/product_model.dart';
import 'package:grocery_delivery_app/products/product_card.dart';
import 'package:grocery_delivery_app/products/products_provider.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

/// Name + favorite button, weight, price with delivery availability,
/// and the quality badges / rating row.
class ProductInfoSection extends StatelessWidget {
  final ProductModel product;

  const ProductInfoSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Favorite state lives on the product itself, so read the live copy.
    final liveProduct = context.watch<ProductsProvider>().allProducts.firstWhere(
          (p) => p.name == product.name,
          orElse: () => product,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            _FavoriteButton(
              isFavorite: liveProduct.isFavorite,
              onTap: () =>
                  context.read<ProductsProvider>().toggleFavorite(product),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          product.weight,
          style: const TextStyle(
            color: AppColors.textSecondaryGrey,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            // Same superscript-cents pattern as ProductCard, just bigger.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.priceInt,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(product.priceDec, style: textStyle),
              ],
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 10,
              backgroundColor: Color(0xFFB05CE2),
              child: Icon(Icons.bolt, size: 13, color: Colors.white),
            ),
            const SizedBox(width: 6),
            const Text(
              'Available on fast delivery',
              style: TextStyle(
                color: AppColors.textSecondaryGrey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _qualityBadge(const Color(0xFF8E2F84), LucideIcons.leaf),
            const SizedBox(width: 8),
            _qualityBadge(const Color(0xFFC2571B), LucideIcons.sun),
            const SizedBox(width: 8),
            _qualityBadge(const Color(0xFF1F4E9C), LucideIcons.wheat),
            const Spacer(),
            const Icon(Icons.star, color: AppColors.primaryDark, size: 20),
            const SizedBox(width: 4),
            Text(
              '${product.rating} Rating',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _qualityBadge(Color color, IconData icon) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: color,
      child: Icon(icon, size: 14, color: Colors.white),
    );
  }
}

class _FavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const _FavoriteButton({required this.isFavorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1.4),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            key: ValueKey(isFavorite),
            color: isFavorite
                ? AppColors.textAccentOrange
                : AppColors.primaryDark,
            size: 22,
          ),
        ),
      ),
    );
  }
}
