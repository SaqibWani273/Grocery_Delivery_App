import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  // Add a PageController to handle the sliding animation
  final PageController pageController = PageController();

  set selectedIndex(int index) {
    if (_selectedIndex == index) return;
    _selectedIndex = index;
    notifyListeners();

    // Trigger the smooth slide transition
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic, // Smooth acceleration and deceleration
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
