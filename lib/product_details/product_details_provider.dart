import 'package:flutter/material.dart';

/// Screen-scoped state for the product details page. Created per route,
/// so every visit starts fresh (quantity 1, first store selected).
class ProductDetailsProvider extends ChangeNotifier {
  int _quantity = 1;
  int get quantity => _quantity;

  int _selectedStoreIndex = 0;
  int get selectedStoreIndex => _selectedStoreIndex;

  bool _isDescriptionExpanded = true;
  bool get isDescriptionExpanded => _isDescriptionExpanded;

  bool _isCookingIdeaExpanded = false;
  bool get isCookingIdeaExpanded => _isCookingIdeaExpanded;

  bool _isNutritionExpanded = false;
  bool get isNutritionExpanded => _isNutritionExpanded;

  void incrementQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (_quantity <= 1) return;
    _quantity--;
    notifyListeners();
  }

  void selectStore(int index) {
    if (_selectedStoreIndex == index) return;
    _selectedStoreIndex = index;
    notifyListeners();
  }

  void toggleDescription() {
    _isDescriptionExpanded = !_isDescriptionExpanded;
    notifyListeners();
  }

  void toggleCookingIdea() {
    _isCookingIdeaExpanded = !_isCookingIdeaExpanded;
    notifyListeners();
  }

  void toggleNutrition() {
    _isNutritionExpanded = !_isNutritionExpanded;
    notifyListeners();
  }
}
