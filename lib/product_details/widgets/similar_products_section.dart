import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/models/product_model.dart';
import 'package:grocery_delivery_app/product_details/product_details_screen.dart';
import 'package:grocery_delivery_app/products/all_products_screen.dart';
import 'package:grocery_delivery_app/products/product_card.dart';
import 'package:grocery_delivery_app/products/products_provider.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

/// "Similar products" strip — lightweight cards without cart actions.
/// Tapping one pushes its own details screen on top of this one.
class SimilarProductsSection extends StatelessWidget {
  final ProductModel currentProduct;

  const SimilarProductsSection({super.key, required this.currentProduct});

  @override
  Widget build(BuildContext context) {
    final similar = context
        .read<ProductsProvider>()
        .allProducts
        .where((p) => p.name != currentProduct.name)
        .take(3)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Similar products',
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.primaryDark,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MoreProductsScreen(),
                  ),
                );
              },
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: const Text(
                'See more',
                style: TextStyle(
                  color: AppColors.textAccentOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < similar.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              Expanded(
                child: _SimilarProductCard(
                  product: similar[i],
                  // Namespaced per parent product so the tag can't clash
                  // with this screen's own hero image.
                  heroTag: 'similar_${currentProduct.name}_$i',
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _SimilarProductCard extends StatelessWidget {
  final ProductModel product;
  final String heroTag;

  const _SimilarProductCard({required this.product, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        ProductDetailsScreen.route(product: product, heroTag: heroTag),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9F9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Hero(
              tag: heroTag,
              child: Image.asset(product.image, height: 64, fit: BoxFit.contain),
            ),
            const SizedBox(height: 10),
            Text(
              product.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textStyle.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 4),
            Text(
              product.weight,
              style: const TextStyle(
                color: AppColors.textSecondaryGrey,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.priceInt,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                Text(product.priceDec, style: textStyle.copyWith(fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
