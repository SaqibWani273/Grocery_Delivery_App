import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/app_sizes.dart';
import 'package:grocery_delivery_app/models/product_model.dart';
import 'package:grocery_delivery_app/product_details/product_details_provider.dart';
import 'package:grocery_delivery_app/product_details/widgets/bottom_cart_bar.dart';
import 'package:grocery_delivery_app/product_details/widgets/details_curved_header.dart';
import 'package:grocery_delivery_app/product_details/widgets/expandable_section.dart';
import 'package:grocery_delivery_app/product_details/widgets/others_store_section.dart';
import 'package:grocery_delivery_app/product_details/widgets/product_info_section.dart';
import 'package:grocery_delivery_app/product_details/widgets/read_more_text.dart';
import 'package:grocery_delivery_app/product_details/widgets/similar_products_section.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductModel product;

  /// Hero tag of the product image on the screen that pushed this one.
  final String heroTag;

  const ProductDetailsScreen({
    super.key,
    required this.product,
    required this.heroTag,
  });

  /// Route wrapped with the screen-scoped provider so every entry point
  /// pushes the screen the same way.
  static Route route({required ProductModel product, required String heroTag}) {
    return MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        create: (_) => ProductDetailsProvider(),
        child: ProductDetailsScreen(product: product, heroTag: heroTag),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sections below the hero image share a staggered entry; the image is
    // left out so nothing fights its hero flight.
    final sections = <Widget>[
      ProductInfoSection(product: product),
      const SizedBox(height: 20),
      ReadMoreText(text: product.description),
      const SizedBox(height: AppSizes.sectionPadding),
      OthersStoreSection(offers: product.storeOffers),
      _buildCollapsibles(),
      const SizedBox(height: AppSizes.sectionPadding),
      SimilarProductsSection(currentProduct: product),
    ]
        .animate(interval: 80.ms)
        .fadeIn(duration: 400.ms, curve: Curves.easeIn)
        .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut);

    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: DetailsCurvedHeader(
                  statusBarHeight: context.statusBarHeight,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.sectionPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Center(
                        child: Hero(
                          tag: heroTag,
                          child: Image.asset(
                            product.image,
                            height: context.heightPct(0.27),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      ...sections,
                      // Keep the last section clear of the fixed bottom bar.
                      SizedBox(height: 100 + context.bottomBarHeight),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomCartBar(product: product)
                .animate()
                .slideY(
                  begin: 1,
                  end: 0,
                  duration: 400.ms,
                  delay: 250.ms,
                  curve: Curves.easeOutCubic,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibles() {
    return Consumer<ProductDetailsProvider>(
      builder: (context, details, _) => Column(
        children: [
          Divider(color: Colors.grey.shade200, height: 1),
          ExpandableSection(
            title: 'Cooking idea',
            body: product.cookingIdea,
            expanded: details.isCookingIdeaExpanded,
            onToggle: details.toggleCookingIdea,
          ),
          Divider(color: Colors.grey.shade200, height: 1),
          ExpandableSection(
            title: 'Nutrition values',
            body: product.nutritionValues,
            expanded: details.isNutritionExpanded,
            onToggle: details.toggleNutrition,
          ),
          Divider(color: Colors.grey.shade200, height: 1),
        ],
      ),
    );
  }
}
