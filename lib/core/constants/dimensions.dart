/// Otto app dimensions and spacing constants
class AppDimensions {
  AppDimensions._();

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  /// Common shorthand aliases used throughout the UI.
  /// Prefer these in widgets for readability.
  static const double xs = spacingXs;
  static const double sm = spacingS;
  static const double md = spacingM;
  static const double lg = spacingL;
  static const double xl = spacingXl;
  static const double xxl = spacingXxl;

  /// Legacy alias kept for backwards compatibility.
  static const double spaceMd = spacingM;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXl = 24.0;

  /// Common shorthand aliases for border radius.
  static const double radiusMd = radiusM;
  static const double radiusLg = radiusL;
  static const double radiusFull = 999.0; // For fully rounded corners

  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXl = 48.0;

  // Button heights
  static const double buttonHeightS = 40.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;

  /// Common shorthand alias for button height.
  static const double buttonHeight = buttonHeightM;

  // App bar
  static const double appBarHeight = 56.0;

  // Bottom navigation
  static const double bottomNavHeight = 80.0;

  // Card elevation
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
}
