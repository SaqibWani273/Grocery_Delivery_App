import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';
import 'package:grocery_delivery_app/ui_extensions.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          const Center(
            child: Text('Categories Screen'),
          ),
          Positioned(
          top: context.statusBarHeight*4 ,
          left: 16,
          right: 16,
          child: Hero(
            tag: 'search_bar',
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
        ),
        ],
      ),
    );
  }
}