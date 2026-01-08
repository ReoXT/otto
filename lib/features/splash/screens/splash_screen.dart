import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/router/app_router.dart';
import 'package:otto/data/services/local_storage_service.dart';

/// Splash screen with Otto logo and navigation logic
///
/// Based on otto-spec.md screen flow (lines 93-111)
/// Shows for minimum 2 seconds while checking user state
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _minimumSplashDuration = Duration(seconds: 2);

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  /// Initialize app and navigate to appropriate screen
  ///
  /// This method:
  /// 1. Waits minimum 2 seconds for branding
  /// 2. Checks if user has completed onboarding
  /// 3. Navigates to onboarding (new user) or home (returning user)
  Future<void> _initializeApp() async {
    final startTime = DateTime.now();

    try {
      // Check if onboarding is complete
      final localStorage = LocalStorageService();
      final isOnboardingComplete = await localStorage.isOnboardingComplete();

      // Ensure minimum splash duration for branding
      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = _minimumSplashDuration - elapsedTime;

      if (remainingTime > Duration.zero) {
        await Future.delayed(remainingTime);
      }

      // Navigate to appropriate screen
      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(
        isOnboardingComplete ? AppRoutes.home : AppRoutes.onboarding,
      );
    } catch (e) {
      // On error, default to onboarding
      // This handles cases where local storage might not be initialized
      debugPrint('Error during splash initialization: $e');

      final elapsedTime = DateTime.now().difference(startTime);
      final remainingTime = _minimumSplashDuration - elapsedTime;

      if (remainingTime > Duration.zero) {
        await Future.delayed(remainingTime);
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Otto logo placeholder with pulse animation
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.water_drop,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.05, 1.05),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                )
                .then()
                .scale(
                  begin: const Offset(1.05, 1.05),
                  end: const Offset(1.0, 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeInOut,
                ),

            const SizedBox(height: AppDimensions.spacingXl),

            // Otto text logo
            Text(
              'Otto',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                ),

            const SizedBox(height: AppDimensions.spacingS),

            // Tagline
            Text(
              'Track calories like writing in your notes',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.9),
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
            )
                .animate()
                .fadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                )
                .slideY(
                  begin: 0.3,
                  end: 0,
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                ),
          ],
        ),
      ),
    );
  }
}
