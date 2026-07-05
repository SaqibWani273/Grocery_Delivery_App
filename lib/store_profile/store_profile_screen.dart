import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/app_sizes.dart';
import 'package:grocery_delivery_app/common_widgets/plus_promo_banner.dart';
import 'package:grocery_delivery_app/common_widgets/search_bar_widget.dart';
import 'package:grocery_delivery_app/main.dart';
import 'package:grocery_delivery_app/models/store_model.dart';
import 'package:grocery_delivery_app/products/all_products_screen.dart';
import 'package:grocery_delivery_app/products/product_card.dart';
import 'package:grocery_delivery_app/products/products_provider.dart';
import 'package:grocery_delivery_app/store_profile/store_profile_provider.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

const _bannerNavy = Color(0xFF1D4E8F);

const _storeCategories = [
  {'name': 'Meets', 'icon': '🥩'},
  {'name': 'Veggies', 'icon': '🥦'},
  {'name': 'Fruits', 'icon': '🍊'},
  {'name': 'Breads', 'icon': '🍞'},
  {'name': 'Corn', 'icon': '🌽'},
  {'name': 'Drinks', 'icon': '🍺'},
  {'name': 'Dairy', 'icon': '🧀'},
];

class StoreProfileScreen extends StatelessWidget {
  final StoreOffer offer;

  const StoreProfileScreen({super.key, required this.offer});

  static Route route({required StoreOffer offer}) {
    return MaterialPageRoute(
      builder: (_) => ChangeNotifierProvider(
        create: (_) => StoreProfileProvider(),
        child: StoreProfileScreen(offer: offer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = <Widget>[
      const SizedBox(height: 16),
      _buildFulfillmentRow(),
      const SizedBox(height: 20),
      const PlusPromoBanner(background: _bannerNavy),
      const SizedBox(height: 20),
      _buildSearchRow(),
      const SizedBox(height: 20),
      _buildCategoriesRow(),
      const SizedBox(height: AppSizes.sectionPadding),
      _buildBestSelling(context),
    ]
        .animate(interval: 70.ms)
        .fadeIn(duration: 400.ms, curve: Curves.easeIn)
        .slideY(begin: 0.15, end: 0, duration: 400.ms, curve: Curves.easeOut);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeaderBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStoreCardOnPurple(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...sections,
                        SizedBox(height: 30 + context.bottomBarHeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Purple top bar: back / title / cart.
  Widget _buildHeaderBar(BuildContext context) {
    return Container(
      color: AppColors.storePurple,
      padding: EdgeInsets.fromLTRB(16, context.statusBarHeight + 4, 16, 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'Store profile',
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
                    backgroundColor: Colors.white.withAlpha(60),
                    radius: 20,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.primaryLight,
                    ),
                  ),
                )
                .animate()
                .fadeIn(duration: 500.ms, curve: Curves.easeIn)
                .scale(duration: 200.ms, curve: Curves.easeIn),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: CartIcon(cartKey: CartIconAnchor.key5),
          ),
        ],
      ),
    );
  }

  // The white store card overlapping the purple header's bottom edge.
  Widget _buildStoreCardOnPurple(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Column(
            children: [
              Expanded(child: Container(color: AppColors.storePurple)),
              const Expanded(child: SizedBox()),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLogo(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              offer.name,
                              style: const TextStyle(
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 19,
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.chevron_right,
                            color: AppColors.textSecondaryGrey,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        offer.tags,
                        style: const TextStyle(
                          color: AppColors.textSecondaryGrey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap for hours, info, and more',
                        style: TextStyle(
                          color: AppColors.textSecondaryGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 350.ms).scale(
                begin: const Offset(0.96, 0.96),
                end: const Offset(1, 1),
                duration: 350.ms,
                curve: Curves.easeOut,
              ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    if (offer.logoPath != null) {
      return CircleAvatar(
        radius: 26,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage(offer.logoPath!),
      );
    }

    return CircleAvatar(
      radius: 26,
      backgroundColor: AppColors.accentLightTint,
      child: Text(
        offer.name[0],
        style: const TextStyle(
          color: AppColors.textAccentOrange,
          fontWeight: FontWeight.w800,
          fontSize: 22,
        ),
      ),
    );
  }

  Widget _buildFulfillmentRow() {
    return Row(
      children: [
        const _FulfillmentToggle(),
        const Spacer(),
        const Icon(Icons.bolt, color: Colors.amber, size: 18),
        const SizedBox(width: 2),
        Text(
          'In ${offer.deliveryMinutes} minute',
          style: const TextStyle(
            color: AppColors.primaryDark,
            fontWeight: FontWeight.w500,
            fontSize: 13.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        const Expanded(child: SearchBarWidget()),
        const SizedBox(width: 12),
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 22,
          child: const Icon(Icons.tune, color: AppColors.primaryDark),
        ),
      ],
    );
  }

  Widget _buildCategoriesRow() {
    return SizedBox(
      height: 100,
      child: Consumer<StoreProfileProvider>(
        builder: (context, profile, _) => ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _storeCategories.length,
          itemBuilder: (context, index) {
            final category = _storeCategories[index];
            final selected = profile.selectedCategoryIndex == index;

            return GestureDetector(
              onTap: () => profile.selectCategory(index),
              child: Padding(
                padding: const EdgeInsets.only(right: 14.0),
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected
                              ? AppColors.primaryAccent
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.categoryCircleBg,
                        child: Text(
                          category['icon']!,
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category['name']!,
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBestSelling(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Best selling',
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
                'View all',
                style: TextStyle(
                  color: AppColors.textAccentOrange,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        Consumer<ProductsProvider>(
          builder: (context, provider, _) {
            final products = provider.allProducts.take(5).toList();
            return SizedBox(
              height: context.deviceHeight * 0.3,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ProductCard(
                      product: products[index],
                      heroTag: 'store_$index',
                      cartIconKey: CartIconAnchor.key5,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Delivery / Pickup pill switch with a sliding white thumb.
class _FulfillmentToggle extends StatelessWidget {
  const _FulfillmentToggle();

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<StoreProfileProvider>();

    return Container(
      height: 46,
      width: 220,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFECEEEC),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: profile.isDelivery
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildOption(profile, label: 'Delivery', delivery: true),
              _buildOption(profile, label: 'Pickup', delivery: false),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    StoreProfileProvider profile, {
    required String label,
    required bool delivery,
  }) {
    final selected = profile.isDelivery == delivery;

    return Expanded(
      child: GestureDetector(
        onTap: () => profile.selectFulfillment(delivery: delivery),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected
                  ? AppColors.primaryDark
                  : AppColors.textSecondaryGrey,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 14.5,
            ),
          ),
        ),
      ),
    );
  }
}
