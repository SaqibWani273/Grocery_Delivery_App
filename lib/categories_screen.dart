import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/app_sizes.dart';
import 'package:grocery_delivery_app/common_widgets/plus_promo_banner.dart';
import 'package:grocery_delivery_app/common_widgets/search_bar_widget.dart';
import 'package:grocery_delivery_app/dashboard/widgets/custom_shapes.dart';
import 'package:grocery_delivery_app/main.dart';
import 'package:grocery_delivery_app/products/all_products_screen.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

const _bannerRust = Color(0xFFB23E1E);

const _allCategories = [
  {'title': 'Meats', 'subtitle': 'Frozen Meal', 'icon': '🥩'},
  {'title': 'Vegetables', 'subtitle': 'Markets', 'icon': '🥦'},
  {'title': 'Fruits', 'subtitle': 'Comical free', 'icon': '🍊'},
  {'title': 'Breads', 'subtitle': 'Burnt', 'icon': '🍞'},
  {'title': 'Snacks', 'subtitle': 'Evening', 'icon': '🍿'},
  {'title': 'Bakery', 'subtitle': 'Meal and Flour', 'icon': '🥐'},
  {'title': 'Dairy & Sweet', 'subtitle': 'In store', 'icon': '🧁'},
  {'title': 'Chicken', 'subtitle': 'Frozen Meal', 'icon': '🍗'},
  {'title': 'Milk & Cream', 'subtitle': 'Frozen', 'icon': '🥛'},
  {'title': 'Cleaners', 'subtitle': 'Household', 'icon': '🧴'},
];

/// "All categories" tab: curved dark header with the pinned search bar,
/// Plus+ promo banner, and a two-column category grid.
class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoriesHeaderDelegate(
              statusBarHeight: context.statusBarHeight,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PlusPromoBanner(background: _bannerRust)
                      .animate()
                      .fadeIn(duration: 400.ms, curve: Curves.easeIn)
                      .slideY(
                        begin: 0.2,
                        end: 0,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                      ),
                  const SizedBox(height: AppSizes.sectionPadding),
                  Text(
                    'All categories',
                    style: context.textTheme.titleLarge?.copyWith(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
                  const SizedBox(height: 14),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              16,
              0,
              16,
              AppSizes.bottomNavBarHeight * 2,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.0,
                crossAxisSpacing: 12.0,
                childAspectRatio: 1.6,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final category = _allCategories[index];
                return _CategoryCard(
                      title: category['title']!,
                      subtitle: category['subtitle']!,
                      icon: category['icon']!,
                    )
                    .animate(delay: (60 * index).ms)
                    .fadeIn(duration: 350.ms, curve: Curves.easeIn)
                    .scale(
                      begin: const Offset(0.92, 0.92),
                      end: const Offset(1, 1),
                      duration: 350.ms,
                      curve: Curves.easeOut,
                    );
              }, childCount: _allCategories.length),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fixed dark header with the outward curve, holding the search bar and
/// cart icon — the categories tab's counterpart of the dashboard header.
class _CategoriesHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;

  _CategoriesHeaderDelegate({required this.statusBarHeight});

  static const double _rowHeight = 56.0;
  static const double _curveZone = 100.0;

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
    final height = maxExtent;

    return Stack(
      children: [
        Positioned.fill(
          child: ClipPath(
            clipper: OutwardCurve(
              x0: 0.0,
              y0: height - 60,
              x1: context.deviceWidth / 2,
              y1: height,
              x2: context.deviceWidth,
              y2: height - 60,
            ),
            child: Container(color: AppColors.primaryDark),
          ),
        ),
        Positioned(
          top: statusBarHeight + 4,
          left: 16,
          right: 16,
          child: Row(
            children: [
              const Expanded(child: SearchBarWidget()),
              const SizedBox(width: 12),
              CartIcon(cartKey: CartIconAnchor.key6),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _CategoriesHeaderDelegate oldDelegate) =>
      statusBarHeight != oldDelegate.statusBarHeight;
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MoreProductsScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textSecondaryGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Text(icon, style: const TextStyle(fontSize: 56)),
            ),
          ],
        ),
      ),
    );
  }
}
