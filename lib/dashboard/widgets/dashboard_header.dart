import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

import 'custom_shapes.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      // floating: true,
      pinned:true,
      delegate: CollapsingGroceryAppBarDelegate(
        statusBarHeight: context.statusBarHeight
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
  double get minExtent => statusBarHeight +120;

  @override
  bool shouldRebuild(covariant CollapsingGroceryAppBarDelegate oldDelegate) =>true;
    //  maxExtent != oldDelegate.maxExtent || minExtent != oldDelegate.minExtent;


  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    // Calculate a percentage of how collapsed the bar is (0.0 = fully open, 1.0 = fully closed)
    final double visibleProgress = (shrinkOffset / (maxExtent - minExtent)) //maxExtent - minExtent -> total height that is going to be shrunk
        .clamp(0.0, 1.0);
    final double fadeOpacity = (1.0 - visibleProgress);
    final curveBottom = maxExtent - kMaxAscend - context.deviceHeight * 0.03;
    return 
     ClipPath(
      
       child: OverflowBox(
        alignment: Alignment.bottomCenter, // <- pins the LAST portion, not the first
        minHeight: maxExtent,
        maxHeight: maxExtent,  
         child: Stack(
           children: [
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
            padding: EdgeInsets.only(top: statusBarHeight + 60.0),
       
            child: SizedBox(
              height: 120,
              width: context.deviceWidth,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Current Location ',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: const Color.fromARGB(255, 183, 183, 186), fontSize: 12,fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                           "California, USA" ,
                          style: context.textTheme.titleLarge?.copyWith(
                            color: AppColors.textTeritiaryColor,
                            fontWeight: FontWeight.bold,
                            
                            fontSize: 18,
                          )
                         
                          ),
                          Icon(
                            Icons.location_on,
                            color: AppColors.textTeritiaryColor,
                            size: 18,
                            fontWeight: FontWeight.w800
                          ),
                      ],
                    ),
                  
                ],
              ),
            ),
          ),
        ),
       
        Positioned(left: 0, right: 0, bottom: 0, child: Opacity(
          opacity: fadeOpacity,
          child: CurvedCategoryRow())),
           ],
         ),
       ),
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateOffset();
    });
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
  final ScrollController _horizontalScrollController = ScrollController(
    initialScrollOffset: 0.0,
  );
@override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //initially put it as a work around to make sure items remain in curved position after coming back from another screen
     _horizontalScrollController.animateTo(200, duration: Duration(milliseconds: 1500), curve: Curves.fastOutSlowIn);
      
    });
    super.initState();
  }
  final List<Map<String, String>> categories = [
    {"name": "Meats", "icon": "🥩"},
    {"name": "Veggies", "icon": "🥦"},
    {"name": "Fruits", "icon": "🍊"},
    {"name": "Breads", "icon": "🍞"},
    {"name": "Cleaners", "icon": "🧴"},
    {"name": "Sweets", "icon": "🍩"},
    {"name": "Snacks", "icon": "🍟"},
    {"name": "Drinks", "icon": "🍺"},
    {"name": "Dairy", "icon": "🧀"},
    {"name": "Frozen", "icon": "🥶"},
    {"name": "fish", "icon": "🐟"},
    {"name": "Can", "icon": "🥫"},
   
  ];

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final item = categories[index];

                    return SizedBox(
                      width: context.deviceWidth * 0.2,
                      child: CurvedScrollItem(
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
                              const SizedBox(height: kMaxAscend * 0.1),
                            ],
                          ).animate(
                            effects: [
                              // FadeEffect(
                              //   duration: 300.ms,
                              //   delay: (index * 100).ms,
                              // ),
                              // SlideEffect(
                              //   begin: const Offset(0.0, 0.3),
                              //   end: Offset.zero,
                              //   duration: 300.ms,
                              //   curve: Curves.easeOut,
                              //   delay: (index * 100).ms,
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              ),

              //indicator
              SizedBox(
                height: context.deviceHeight * 0.03,

                child: AnimatedBuilder(
                  animation: _horizontalScrollController,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        ((categories.length * context.deviceWidth * 0.2) /
                                context.deviceWidth)
                            .ceil(),
                        (index) {
                          log(
                            "${_horizontalScrollController.offset}($index) ->  ${(index + 1) * context.deviceWidth}   ---  ${index * context.deviceWidth}",
                          );
                          final isActive =
                              (_horizontalScrollController.offset <=
                                  index * context.deviceWidth) &&
                              (_horizontalScrollController.offset >
                                  (index - 1) * context.deviceWidth);
                          return LinedIndicator(isActive: isActive);
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class LinedIndicator extends StatelessWidget {
  final bool isActive;
  const LinedIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 30 : 20,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: isActive
            ? AppColors.primaryDark
            : AppColors.primaryDark.withAlpha(50),
      ),
    );
  }
}
