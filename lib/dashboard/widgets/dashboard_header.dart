import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderAbstractViewport;
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/common_widgets/sliver_header_delegate.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CollapsingGroceryAppBarDelegate(
        statusBarHeight: context.statusBarHeight,
        kMaxAscend: 45,
        paddingTop: context.statusBarHeight + 55.0,
        children: [
          Text(
            'Current Location ',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color.fromARGB(255, 183, 183, 186),
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: .center,
            children: [
              Text(
                "California, USA",
                style: context.textTheme.titleLarge?.copyWith(
                  color: AppColors.textTeritiaryColor,
                  fontWeight: FontWeight.bold,

                  fontSize: 18,
                ),
              ),
              Icon(
                Icons.location_on,
                color: AppColors.textTeritiaryColor,
                size: 18,
                fontWeight: FontWeight.w800,
              ),
            ],
          ),

          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: CurvedCategoryRow(
                    maxHeight: constraints.maxHeight,
                    kMaxAscend:
                        45.0, // Pass the maximum vertical offset to the CurvedCategoryRow
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CurvedScrollItem extends StatefulWidget {
  final Widget child;
  final double kMaxAscend; // Maximum vertical offset for the parabolic curve
  final ScrollController scrollController;

  const CurvedScrollItem({
    super.key,
    required this.child,
    required this.kMaxAscend,
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
    if (renderBox == null || !renderBox.hasSize) return;

    // Measure against the horizontal list's own viewport, not the screen:
    // global coordinates are poisoned while an ancestor is mid-transition
    // (tab switch, route push/pop), which froze every item at the fully
    // raised edge position
    final viewportObject = RenderAbstractViewport.maybeOf(renderBox);
    if (viewportObject is! RenderBox) return;
    final viewportBox = viewportObject as RenderBox;

    // Get item's X position relative to the viewport's left edge
    final positionX = renderBox
        .localToGlobal(Offset.zero, ancestor: viewportBox)
        .dx;
    final itemWidth = renderBox.size.width;
    // Calculate the center of the item from left edge
    final itemCenter = positionX + (itemWidth / 2);

    final viewportWidth = viewportBox.size.width;
    final viewportCenter = viewportWidth / 2;

    // Normalize distance from center (-1.0 at left edge, 0.0 at center, 1.0 at right edge)
    double normalizedDistanceFromCenter =
        (itemCenter - viewportCenter) / viewportCenter;
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
          -widget.kMaxAscend *
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
  final double maxHeight;
  final double kMaxAscend; // Maximum vertical offset for the parabolic curve
  const CurvedCategoryRow({
    super.key,
    required this.maxHeight,
    required this.kMaxAscend,
  });

  @override
  State<CurvedCategoryRow> createState() => _CurvedCategoryRowState();
}

class _CurvedCategoryRowState extends State<CurvedCategoryRow> {
  // Entrance plays once per app session, not on every rebuild of this widget
  static bool _hasPlayedEntrance = false;

  static const String _spacerKey = 'entrance-spacer';

  // Dedicated controller for horizontal scrolling
  final ScrollController _horizontalScrollController = ScrollController(
    initialScrollOffset: 0.0,
  );

  // While true, a viewport-wide leading spacer keeps every item parked
  // off-screen to the right so the row starts empty
  bool _entranceActive = !_hasPlayedEntrance;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runEntranceAnimation();
    });
    super.initState();
  }

  Future<void> _runEntranceAnimation() async {
    if (!mounted || !_horizontalScrollController.hasClients) return;

    if (!_entranceActive) {
      // Coming back from another screen: nudge the controller so every
      // CurvedScrollItem recalculates its curved position
      final offset = _horizontalScrollController.offset;
      _horizontalScrollController.jumpTo(offset + 0.1);
      _horizontalScrollController.jumpTo(offset);
      return;
    }

    _hasPlayedEntrance = true;
    final spacerWidth = context.deviceWidth;

    // Scrolling across the spacer drags the items in from the right; each
    // CurvedScrollItem tracks the scroll, so they ride the curve on the way in
    await _horizontalScrollController.animateTo(
      spacerWidth,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.fastOutSlowIn,
    );
    if (!mounted) return;

    // Drop the spacer and rebase the offset: item 0 stays exactly where the
    // animation left it, but the empty region can no longer be scrolled back to
    setState(() => _entranceActive = false);
    _horizontalScrollController.jumpTo(0);
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
      // height: 170,
      height: widget.maxHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            // mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  physics: _entranceActive
                      ? const NeverScrollableScrollPhysics()
                      : null,
                  itemCount: categories.length + (_entranceActive ? 1 : 0),
                  // When the spacer is dropped every index shifts down by
                  // one; matching children by key lets each CurvedScrollItem
                  // keep its element (and its curved offset) instead of
                  // inheriting a neighbour's stale position
                  findChildIndexCallback: (key) {
                    final value = (key as ValueKey).value;
                    if (value == _spacerKey) {
                      return _entranceActive ? 0 : null;
                    }
                    final i = categories.indexWhere((c) => c["name"] == value);
                    if (i == -1) return null;
                    return _entranceActive ? i + 1 : i;
                  },
                  itemBuilder: (context, index) {
                    // Leading spacer keeps every item off-screen right until
                    // the entrance animation has swept across it
                    if (_entranceActive && index == 0) {
                      return SizedBox(
                        key: const ValueKey(_spacerKey),
                        width: context.deviceWidth,
                      );
                    }
                    final item =
                        categories[_entranceActive ? index - 1 : index];

                    return SizedBox(
                      key: ValueKey(item["name"]),
                      width: context.deviceWidth * 0.2,
                      child: CurvedScrollItem(
                        kMaxAscend: widget
                            .kMaxAscend, // Pass the maximum vertical offset to the CurvedScrollItem
                        scrollController: _horizontalScrollController,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 12.0,
                            right: 12.0,
                            // top: 8.0,
                          ),
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
                              // SizedBox(height: constraints.maxHeight * 0.01),
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
                              SizedBox(height: widget.kMaxAscend * 0.05),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
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
                          // During the entrance sweep the offset crosses the
                          // spacer, not real pages — pin the first dash active
                          final offset = _entranceActive
                              ? 0.0
                              : _horizontalScrollController.offset;
                          final isActive =
                              (offset <= index * context.deviceWidth) &&
                              (offset > (index - 1) * context.deviceWidth);
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
