import 'package:flutter/material.dart';

/// Extension on [BuildContext] to simplify responsive UI layout and styling.
extension UIExtensions on BuildContext {
  
  // --- Media Query Shortcuts ---
  
  /// Equivalent to `MediaQuery.of(context).size`
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get the total width of the device screen
  double get deviceWidth => screenSize.width;

  /// Get the total height of the device screen
  double get deviceHeight => screenSize.height;

  /// Get the top padding (useful for custom status bars)
  double get statusBarHeight => MediaQuery.paddingOf(this).top;

  /// Get the bottom padding (useful for custom navigation bars / safe area considerations)
  double get bottomBarHeight => MediaQuery.paddingOf(this).bottom;

  /// Checks if the device is in landscape mode
  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;


  // --- Theme & Text Style Shortcuts ---

  /// Equivalent to `Theme.of(context)`
  ThemeData get theme => Theme.of(this);

  /// Equivalent to `Theme.of(context).textTheme`
  TextTheme get textTheme => theme.textTheme;

  /// Equivalent to `Theme.of(context).colorScheme`
  ColorScheme get colorScheme => theme.colorScheme;


  // --- Responsive Proportion Helpers ---

  /// Returns a width calculated as a percentage of the screen width (0.0 to 1.0)
  double widthPct(double percent) => deviceWidth * percent;

  /// Returns a height calculated as a percentage of the screen height (0.0 to 1.0)
  double heightPct(double percent) => deviceHeight * percent;
}


/// Extension on [Color] to easily manipulate colors for states (pressed, hovered, disabled) 
/// without needing to define dozens of extra constants.
extension ColorExtensions on Color {
  
  /// Darkens the color by a given percentage (0.1 = 10% darker)
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// Lightens the color by a given percentage (0.1 = 10% lighter)
  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}