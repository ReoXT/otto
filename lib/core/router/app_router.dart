import 'package:flutter/material.dart';
import 'package:otto/features/splash/screens/splash_screen.dart';
import 'package:otto/features/onboarding/screens/onboarding_flow.dart';
import 'package:otto/features/home/screens/home_screen.dart';

/// App routing configuration
/// Based on otto-spec.md screen flow (lines 93-111)
class AppRoutes {
  AppRoutes._();

  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String foodDetail = '/food-detail';
  static const String paywall = '/paywall';
  static const String history = '/history';
  static const String quickAdd = '/quick-add';

  /// Generate route based on route settings
  ///
  /// This function creates the appropriate MaterialPageRoute for each route name.
  /// Supports passing arguments through RouteSettings for screens that need them.
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _buildRoute(const SplashScreen());

      case '/onboarding':
        return _buildRoute(const OnboardingFlow());

      case '/home':
        return _buildRoute(const HomeScreen());

      // Placeholder routes for future implementation
      case '/settings':
        return _buildRoute(const _ComingSoonScreen(title: 'Settings'));

      case '/food-detail':
        // TODO: Extract food log from arguments when screen is implemented
        return _buildRoute(const _ComingSoonScreen(title: 'Food Detail'));

      case '/paywall':
        return _buildRoute(const _ComingSoonScreen(title: 'Paywall'));

      case '/history':
        return _buildRoute(const _ComingSoonScreen(title: 'History'));

      case '/quick-add':
        return _buildRoute(const _ComingSoonScreen(title: 'Quick Add'));

      default:
        return _buildRoute(
          Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }

  /// Helper method to build a route with fade transition
  static MaterialPageRoute _buildRoute(Widget screen) {
    return MaterialPageRoute(
      builder: (_) => screen,
    );
  }
}

/// Temporary placeholder screen for routes not yet implemented
class _ComingSoonScreen extends StatelessWidget {
  final String title;

  const _ComingSoonScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              '$title Coming Soon',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'This feature is under development',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
