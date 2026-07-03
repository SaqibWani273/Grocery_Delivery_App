import 'dart:developer';

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
  double get maxExtent => statusBarHeight + 220.0 + kMaxAscend;

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
    final curveBottom = maxExtent - kMaxAscend;
    return Stack(
      children: [
        // 1. Dark Green Background with Wave
        ClipPath(
          clipper: OutwardCurve(
            x0: 0.0,
            y0: curveBottom - 70,

            x1: context.deviceWidth / 2,
            y1: curveBottom,
            x2: context.deviceWidth,
            y2: curveBottom - 70,
          ),
          child: Container(color: AppColors.primaryDark),
        ),

        // 2. Fading Content (Location & Categories)
        Opacity(
          opacity: fadeOpacity,
          child: Padding(
            padding: EdgeInsets.only(top: statusBarHeight + 75.0),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Location\nCalifornia, USA ',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.9)),
                ),
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
        Positioned(left: 0, right: 0, bottom: 0, child: CurvedCategoryRow()),
      ],
    );
  }
}

///
const double kMaxAscend = 45.0;

class CurvedScrollItem extends StatefulWidget {
  final Widget child;
  final ScrollController scrollController;

  const CurvedScrollItem({
    super.key,
    required this.child,
    required this.scrollController,
  });

  @override
  State<CurvedScrollItem> createState() => _CurvedScrollItemState();
}

class _CurvedScrollItemState extends State<CurvedScrollItem> {
  double _offsetY = 0.0;

  @override
  void initState() {
    super.initState();
    // Listen to scroll events to recalculate position dynamically
    widget.scrollController.addListener(_calculateOffset);
    // Calculate initial position after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateOffset());
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_calculateOffset);
    super.dispose();
  }

  void _calculateOffset() {
    if (!mounted) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    // Get item's X position relative to the screen width
    final positionX = renderBox.localToGlobal(Offset.zero).dx;
    final itemWidth = renderBox.size.width;
    // Calculate the center of the item from left edge
    final itemCenter = positionX + (itemWidth / 2);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenCenter = screenWidth / 2;

    // Normalize distance from center (-1.0 at left edge, 0.0 at center, 1.0 at right edge)
    double normalizedDistanceFromCenter =
        (itemCenter - screenCenter) / screenCenter;
    normalizedDistanceFromCenter = normalizedDistanceFromCenter.clamp(
      -1.0,
      1.0,
    );
    log("normalizedDistanceFromCenter: $normalizedDistanceFromCenter");

    setState(() {
      /*   Parabolic arc formula: items are highest at edges (normalized distance = -1 or 1)
      and lowest in the middle (normalized distance = 0)
      _offsetY =
          kMaxAscend *
          (1.0 - (normalizedDistanceFromCenter * normalizedDistanceFromCenter)); */

      // items are most ascendeded upwards at edges & least at center
      _offsetY =
          -kMaxAscend *
          ((normalizedDistanceFromCenter * normalizedDistanceFromCenter));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, _offsetY),
      child: widget.child,
    );
  }
}

class CurvedCategoryRow extends StatefulWidget {
  const CurvedCategoryRow({super.key});

  @override
  State<CurvedCategoryRow> createState() => _CurvedCategoryRowState();
}

class _CurvedCategoryRowState extends State<CurvedCategoryRow> {
  // Dedicated controller for horizontal scrolling
  final ScrollController _horizontalScrollController = ScrollController();

  final List<Map<String, String>> categories = [
    {"name": "Meats", "icon": "🥩"},
    {"name": "Veggies", "icon": "🥦"},
    {"name": "Fruits", "icon": "🍊"},
    {"name": "Breads", "icon": "🍞"},
    {"name": "Cleaners", "icon": "🧴"},
    {"name": "Sweets", "icon": "🍩"},
    {"name": "Snacks", "icon": "🍟"},
    {"name": "Drinks", "icon": "🍺"},
  ];

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            controller: _horizontalScrollController,
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final item = categories[index];

              return CurvedScrollItem(
                scrollController: _horizontalScrollController,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        radius: constraints.maxHeight * 0.23,
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          240,
                          186,
                        ), // Creamy color from video
                        child: Text(
                          item["icon"]!,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.05),
                      SizedBox(
                        height: constraints.maxHeight * 0.15,
                        child: Text(
                          item["name"]!,
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: kMaxAscend * 0.2),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
