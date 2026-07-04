import 'package:flutter/material.dart';

import '../models/product_model.dart';

class ProductsProvider  extends ChangeNotifier{

 final List<ProductModel> allProducts;
 
  ProductsProvider({ required this.allProducts});

//  void setProducts(List<ProductModel> products) {
//     allProducts = products;
//     notifyListeners();
//   }

  List<ProductModel> get products => allProducts;

  void updateCartCount(ProductModel product, int newCount) {
    final index = allProducts.indexWhere((p) => p.name == product.name);
    if (index != -1) {
      allProducts[index] = allProducts[index].copyWith(cartCount: newCount);
      notifyListeners();
    }
  }
}