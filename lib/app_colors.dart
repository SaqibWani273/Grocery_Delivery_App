import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Prevents instantiation

  // --- Primary Palette ---
  /// The deep forest green used for the top header background, main titles, and active text.
  static const Color primaryDark = Color(0xFF032F24);
  static const Color textPrimaryDark = Color.fromARGB(255, 2, 78, 59);

  /// The bright lime/mint green used for active buttons, quantity selectors, and highlights.
  static const Color primaryAccent = Color(0xFF76D254);

  /// Light faded green tint used for the active background of the home icon and counter container.
  static const Color accentLightTint = Color(0xFFEAF9E6);

  // --- Backgrounds & Neutrals ---
  /// Main background color for the body/scaffold.
  static const Color background = Color.fromARGB(239, 251, 251, 251);

  /// Pure white used for the search bar, product cards, and bottom navigation bar background.
  static const Color cardBackground = Colors.white;
  static final Color shadowColor = Colors.grey.shade500;

  /// The off-white/cream background color used specifically for the circular category buttons.
  static const Color categoryCircleBg = Color(0xFFFFF7DF);

  // --- Typography & Accents ---
  /// The orange/coral color used for "See more", prices, and badges.
  static const Color textAccentOrange = Color(0xFFD95333);

  /// Soft grey for subtitles, product weights (e.g., "500 gm."), and inactive navigation icons.
  static const Color textSecondaryGrey = Color(0xFF8E8E93);

  // --- Banner Gradients & Highlights ---
  /// Left banner background (Grocery)
  static const Color groceryBannerBg = Color(0xFFFCEECC);

  /// Left banner text color
  static const Color groceryBannerText = Color(0xFF634205);
  static const Color textTeritiaryColor = Color.fromARGB(255, 189, 165, 121);

  /// Right banner background (Wholesale)
  static const Color wholesaleBannerBg = Color(0xFFFCDADA);

  /// Right banner text color
  static const Color wholesaleBannerText = Color(0xFF6E1B24);
}
