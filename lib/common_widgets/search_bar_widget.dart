

import 'package:flutter/material.dart';
import 'package:grocery_delivery_app/app_colors.dart';

class SearchBarWidget extends StatelessWidget {
  final double? height;
  const SearchBarWidget({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search_bar',
     
      child:  Material(
        type: MaterialType.transparency,
        child : Container(
         height: height ?? 45,
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
      )
    );
  }
}

class CartIcon extends StatelessWidget {
  const CartIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'cart_icon',
      child: Material(
         type: MaterialType.transparency,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 25,
          child: Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.primaryDark,
          ),
        ),
      ),
    );
  }
}