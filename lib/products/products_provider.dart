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
  final ValueNotifier<int> cartItemsCountNotifier = ValueNotifier<int>(0);
  

  void updateCartCount(ProductModel product, {
    required bool increment,
    int quantity = 1,
  }) {
    final index = allProducts.indexWhere((p) => p.name == product.name);
    if (index != -1) {
      allProducts[index] = allProducts[index].copyWith(cartCount: increment? (allProducts[index].cartCount+quantity): (allProducts[index].cartCount-quantity));
     increment?  cartItemsCountNotifier.value += quantity:cartItemsCountNotifier.value -=quantity ;

      notifyListeners();
    }
  }

  void toggleFavorite(ProductModel product) {
    final index = allProducts.indexWhere((p) => p.name == product.name);
    if (index != -1) {
      allProducts[index] = allProducts[index].copyWith(isFavorite: !allProducts[index].isFavorite);
      notifyListeners();
    }
  }
}