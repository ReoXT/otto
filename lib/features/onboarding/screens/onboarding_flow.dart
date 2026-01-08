import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/screens/activity_level_screen.dart';
import 'package:otto/features/onboarding/screens/basic_info_screen.dart';
import 'package:otto/features/onboarding/screens/body_stats_screen.dart';
import 'package:otto/features/onboarding/screens/goal_screen.dart';
import 'package:otto/features/onboarding/screens/name_screen.dart';
import 'package:otto/features/onboarding/screens/results_screen.dart';
import 'package:otto/features/onboarding/screens/welcome_screen.dart';
import 'package:otto/features/onboarding/widgets/progress_dots.dart';

/// Main onboarding flow with PageView navigation
/// Based on otto-spec.md lines 223-286
class OnboardingFlow extends ConsumerStatefulWidget {
  const OnboardingFlow({super.key});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final currentPage = onboardingState.currentPage;

    // Listen for page changes from controller and animate to that page
    ref.listen<OnboardingState>(
      onboardingControllerProvider,
      (previous, next) {
        if (previous?.currentPage != next.currentPage) {
          _pageController.animateToPage(
            next.currentPage,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Progress dots indicator at top
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppDimensions.lg,
              ),
              child: Row(
                children: [
                  // Back button (hidden on first page)
                  if (currentPage > 0)
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        ref
                            .read(onboardingControllerProvider.notifier)
                            .previousPage();
                      },
                    )
                  else
                    const SizedBox(width: 48), // Spacer for alignment

                  // Progress dots
                  Expanded(
                    child: ProgressDots(
                      totalDots: 7,
                      currentIndex: currentPage,
                    ),
                  ),

                  const SizedBox(width: 48), // Spacer for alignment
                ],
              ),
            ),
          ),

          // PageView with all screens
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Prevent swipe navigation
              children: const [
                WelcomeScreen(),
                NameScreen(),
                BasicInfoScreen(),
                BodyStatsScreen(),
                ActivityLevelScreen(),
                GoalScreen(),
                ResultsScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
