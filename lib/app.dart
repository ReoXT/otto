import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otto/core/router/app_router.dart';
import 'package:otto/core/theme/app_theme.dart';

/// Main Otto application widget
///
/// This widget serves as the root of the application, configuring:
/// - Material Design theme
/// - Navigation/routing
/// - System UI overlays
/// - Global app settings
///
/// Based on otto-spec.md for theming and navigation setup
class OttoApp extends StatelessWidget {
  const OttoApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set system UI overlay style (status bar, navigation bar)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      // App metadata
      title: 'Otto',
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Currently only light theme per spec

      // Routing configuration
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.generateRoute,

      // Builder for wrapping the entire app (useful for overlays, etc.)
      builder: (context, child) {
        // Ensure text scale factor doesn't exceed reasonable limits
        // This prevents UI breaking on extreme accessibility settings
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: MediaQuery.of(context).textScaler.clamp(
                  minScaleFactor: 0.8,
                  maxScaleFactor: 1.3,
                ),
          ),
          child: child!,
        );
      },
    );
  }
}
