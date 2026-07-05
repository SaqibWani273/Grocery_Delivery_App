import 'package:flutter/material.dart';

/// Screen-scoped state for the store profile page.
class StoreProfileProvider extends ChangeNotifier {
  bool _isDelivery = true;
  bool get isDelivery => _isDelivery;

  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  void selectFulfillment({required bool delivery}) {
    if (_isDelivery == delivery) return;
    _isDelivery = delivery;
    notifyListeners();
  }

  void selectCategory(int index) {
    if (_selectedCategoryIndex == index) return;
    _selectedCategoryIndex = index;
    notifyListeners();
  }
}
