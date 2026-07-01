import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

import 'custom_shapes.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CollapsingGroceryAppBarDelegate(
        statusBarHeight: context.deviceHeight * 0.04,
      ),
    );
  }
}

class CollapsingGroceryAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;

  CollapsingGroceryAppBarDelegate({required this.statusBarHeight});

  // Total height when fully expanded (Before Scroll)
  @override
  double get maxExtent => statusBarHeight + 200.0;

  // Height when fully collapsed (After Scroll - just enough for search bar)
  @override
  double get minExtent => statusBarHeight + 80.0;

  @override
  bool shouldRebuild(covariant CollapsingGroceryAppBarDelegate oldDelegate) =>
      true;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate a percentage of how collapsed the bar is (0.0 = fully open, 1.0 = fully closed)
    final double visibleProgress = (shrinkOffset / (maxExtent - minExtent))
        .clamp(0.0, 1.0);
    final double fadeOpacity = (1.0 - visibleProgress);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 1. Dark Green Background with Wave
        ClipPath(
          clipper: OutwardCurve(
            x0: 0.0,
            y0: maxExtent - 70,

            x1: context.deviceWidth / 2,
            y1: maxExtent,
            x2: context.deviceWidth,
            y2: maxExtent - 70,
          ),
          child: Container(color: AppColors.primaryDark),
        ),

        // 2. Fading Content (Location & Categories)
        Opacity(
          opacity: fadeOpacity,
          child: Padding(
            padding: EdgeInsets.only(top: statusBarHeight + 75.0),

            child: Column(
              children: [
                // Location Selection Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Current Location\nCalifornia, USA 📍',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withOpacity(0.9)),
                    ),
                  ],
                ),
                const Spacer(),
                // Horizontal Categories row (Meets, Vege, Fruits, Breads)
                _buildCategoriesRow(),
              ],
            ),
          ),
        ),

        // 3. Persistent Floating Content (Search Bar & Cart Icon)
        // Stays at the top but shifts downwards slightly as it collapses
        Positioned(
          top: statusBarHeight + (12.0 * fadeOpacity),
          left: 16,
          right: 16,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50,
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
              ),
              const SizedBox(width: 12),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesRow() {
    // Implement your category circle layout here
    return const SizedBox(height: 80);
  }
}
