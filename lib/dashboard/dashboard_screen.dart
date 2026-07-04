
import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/common_widgets/search_bar_widget.dart';

import 'package:grocery_delivery_app/dashboard/widgets/dashboard_header.dart';
import 'package:grocery_delivery_app/products/mightneed_widget.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';


import '../app_sizes.dart';
import '../models/product_model.dart';
import 'widgets/featured_stores_widget.dart';
import 'widgets/promo_banner_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          
          slivers: [
            DashboardHeader(),
            
            SliverToBoxAdapter(child: YouMightNeedSection(
            products:productsList. sublist(0, productsList.length~/1.5), // 
          )),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.sectionPadding)),
           SliverToBoxAdapter(child: PromoBannersRow()),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.sectionPadding)),
           
          SliverToBoxAdapter(child: FeaturedStoreSection()),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.bottomNavBarHeight+ AppSizes.bottomNavBarHeight*0.7)),  
        
        ],
      ),
       Positioned(
          top: context.statusBarHeight ,
          left: 16,
          right: 16,
          child: 
         SizedBox(
           height: 45,
           child: Row(
             children: [
               Expanded(child: const   SearchBarWidget(
                height: 45,
               )),
               const SizedBox(width: 16),
            CartIcon(),
             ],
           ),
         )      
          
        ),
        ]
    );
  }
}