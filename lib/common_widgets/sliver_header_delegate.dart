import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/dashboard/widgets/custom_shapes.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

class CollapsingGroceryAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double statusBarHeight;
  final double? paddingTop;
  final List<Widget> children; //children widgets that will get collapsed and faded as the user scrolls
  final Widget? child; //child widget that will be pinned and not get collapsed or faded as the user scrolls
  final double? childHeight;
  final double childrenMaxHeight;
  final double? kMaxAscend; //this is needed only in dashboard screen,
  final Function(bool)? onAppbarCollapsed;

  CollapsingGroceryAppBarDelegate({required this.statusBarHeight,
  this.child,
   this.children = const [], this.paddingTop, this.childrenMaxHeight = 230.0,
   this.onAppbarCollapsed,
   
   this.childHeight=30,
    this.kMaxAscend});

  // Total height when fully expanded (Before Scroll)
  @override
  
  double get maxExtent => statusBarHeight + childrenMaxHeight*0.95 +  ( kMaxAscend ??0) + (child==null ? 0 : childHeight!);
  
  

  // Height when fully collapsed (After Scroll - just enough for search bar)
  @override
  double get minExtent => statusBarHeight +childrenMaxHeight*0.5 + (child==null ? 0 : childHeight!*1.5);

  @override
  bool shouldRebuild(covariant CollapsingGroceryAppBarDelegate oldDelegate) =>
     maxExtent != oldDelegate.maxExtent || minExtent != oldDelegate.minExtent;


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
    final curveBottom = maxExtent - ( kMaxAscend ?? 0) -(child==null ? 0 : childHeight!*0.5) - context.deviceHeight * 0.01;
    if(visibleProgress==1.0 || visibleProgress==0.0)onAppbarCollapsed?.call(visibleProgress==1.0); 
    return 
     ClipPath(
      
       child: OverflowBox(
        alignment: Alignment.bottomCenter, // <- pins the LAST portion, not the first
        // minHeight: maxExtent,
        minHeight: minExtent,
        maxHeight: maxExtent,  
         child: Stack(
           children: [
             ClipPath(
                  clipper: OutwardCurve(
                    x0: 0.0,
                    y0: curveBottom - 60,
             
                    x1: context.deviceWidth / 2,
                    y1: curveBottom,
                    x2: context.deviceWidth,
                    y2: curveBottom - 60,
                  ),
                  child: Container(color: AppColors.primaryDark),
                ),
                 
        // 2. Fading Content 
        Opacity(
          opacity: fadeOpacity,
          child: Padding(
            padding: EdgeInsets.only(top:paddingTop ?? statusBarHeight + 60.0),
       
            child: SizedBox(
              height: childrenMaxHeight,
              width: context.deviceWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
       
       Positioned(
         bottom:0 +(shrinkOffset*0.4),
         left: 0,
         right: 0,
         child: SizedBox(
          height: childHeight,
          child: child ?? const SizedBox.shrink()),
       ),
       
           ],
         ),
       ),
     );
    
 
  }
}