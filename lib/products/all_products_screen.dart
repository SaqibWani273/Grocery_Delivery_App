import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/common_widgets/search_bar_widget.dart';
import 'package:grocery_delivery_app/common_widgets/sliver_header_delegate.dart';
import 'package:grocery_delivery_app/main.dart';
import 'package:grocery_delivery_app/products/product_card.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';
import 'package:provider/provider.dart';

import 'products_provider.dart';

const List<String> categories = [
  'Bakery',
  'Fresh',
  'Beverages',
  'Snacks',
  'Frozen',
  'Dairy & Eggs',
  'Fruits & Vegetables',
  'Pantry Staples',
  'Personal Care',
  'Meat & Seafood',
  'Household Supplies',
];

class MoreProductsScreen extends StatefulWidget {
  const MoreProductsScreen({super.key});

  @override
  State<MoreProductsScreen> createState() => _MoreProductsScreenState();
}

class _MoreProductsScreenState extends State<MoreProductsScreen> {
  final ValueNotifier<bool> showingCartFAB = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ValueListenableBuilder(
        valueListenable: showingCartFAB,
        child: CartIcon(cartKey: CartIconAnchor.key3),
        builder: (context, showing, child) {
          if (!showing) return SizedBox.shrink();
          return child!;
        },
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, provider, child) {
          return CustomScrollView(
            slivers: [
              SliverPersistentHeader(
                pinned: true,
                delegate: CollapsingGroceryAppBarDelegate(
                  statusBarHeight: context.statusBarHeight,
                  paddingTop: context.statusBarHeight,
                  childrenMaxHeight: 160.0,
                  childHeight: 45,
                  onAppbarCollapsed: (isCollapsed) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (isCollapsed && !showingCartFAB.value) {
                        showingCartFAB.value = true;
                      } else if (!isCollapsed && showingCartFAB.value) {
                        showingCartFAB.value = false;
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(child: SearchBarWidget()),
                        const SizedBox(width: 12.0),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: const Icon(
                            Icons.sort,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 20,
                                  child: const Icon(
                                    Icons.arrow_back_ios_new,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms, curve: Curves.easeIn)
                              .scale(duration: 200.ms, curve: Curves.easeIn),

                          const Text(
                            "Daily Foods",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryLight,
                            ),
                          ),
                          CartIcon(cartKey: CartIconAnchor.key2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 12.0),
                          ...categories.map(
                            (category) => Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Text(
                                category,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: categories.indexOf(category) == 2
                                      ? AppColors.primaryAccent
                                      : AppColors.textSecondaryGrey,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ).animate().slide(
                      begin: Offset(2.0, 0),
                      end: const Offset(0, 0),
                      duration: 800.ms,
                      curve: Curves.ease,
                    ),
                  ],
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12.0,
                    crossAxisSpacing: 12.0,
                    childAspectRatio: 0.5,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final product = provider.allProducts[index];
                    return ValueListenableBuilder(
                      valueListenable: showingCartFAB,
                      builder: (context, showing, child) {
                        return ProductCard(
                          product: product,
                          cartIconKey: showing
                              ? CartIconAnchor.key3
                              : CartIconAnchor.key2,
                        );
                      },
                    );
                  }, childCount: provider.allProducts.length),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
