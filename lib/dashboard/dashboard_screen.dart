import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/dashboard/dashboard_provider.dart';
import 'package:grocery_delivery_app/dashboard/widgets/dashboard_header.dart';
import 'package:grocery_delivery_app/dashboard/widgets/mightneed_widget.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

import '../app_sizes.dart';
import '../models/product_model.dart';
import 'widgets/featured_stores_widget.dart';
import 'widgets/promo_banner_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(() {
      log(
        "scrollController: ${_scrollController.offset}, listening in dashboard",
      );
    });
    context.read<DashboardProvider>().initScrollController(
      _scrollController,
    ); // call initScrollController()
    
    super.initState();
  }
 
  @override
  dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            DashboardHeader(),
            
            SliverToBoxAdapter(child: YouMightNeedSection(
            products:productsList
          )),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.sectionPadding)),
           SliverToBoxAdapter(child: PromoBannersRow()),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.sectionPadding)),
           
          SliverToBoxAdapter(child: FeaturedStoreSection()),
          SliverToBoxAdapter(child: SizedBox(height: AppSizes.bottomNavBarHeight+ AppSizes.bottomNavBarHeight*0.7)),  
        
        ],
      ), Positioned(
          top: context.statusBarHeight ,
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
        ),]
    );
  }
}