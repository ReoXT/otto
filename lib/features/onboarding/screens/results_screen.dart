import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/core/router/app_router.dart';
import 'package:otto/data/models/user.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';
import 'package:otto/providers/local_storage_provider.dart';

/// Results screen - Seventh onboarding screen showing calculated plan
/// Based on otto-spec.md lines 278-285
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    // Trigger calculation when screen appears if not already calculated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(onboardingControllerProvider);
      if (state.calculatedResults == null && !state.isCalculating) {
        ref.read(onboardingControllerProvider.notifier).calculateAndSave();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final onboardingState = ref.watch(onboardingControllerProvider);

    // Show loading state
    if (onboardingState.isCalculating || onboardingState.calculatedResults == null) {
      return OnboardingPageTemplate(
        illustration: _OttoCelebratingPlaceholder(animate: false),
        title: "Calculating your plan...",
        buttonText: "Please wait",
        onButtonPressed: () {},
        isButtonEnabled: false,
      );
    }

    final results = onboardingState.calculatedResults!;
    final calorieTarget = results['calorie_target'] as int;
    final proteinG = results['protein_g'] as int;
    final carbsG = results['carbs_g'] as int;
    final fatG = results['fat_g'] as int;

    final goalText = _getGoalDescription(onboardingState.goal!);

    return OnboardingPageTemplate(
      illustration: _OttoCelebratingPlaceholder(animate: true),
      title: "Here's your personalized plan!",
      content: Column(
        children: [
          // Large calorie number
          Text(
            '$calorieTarget',
            style: AppTypography.numberLarge.copyWith(
              color: AppColors.primary,
            ),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: AppDimensions.xs),

          Text(
            'calories per day',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms),

          const SizedBox(height: AppDimensions.xl),

          // Macro breakdown
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _MacroDisplay(
                emoji: '🥜',
                label: 'Protein',
                value: '${proteinG}g',
                delay: 600,
              ),
              _MacroDisplay(
                emoji: '🍞',
                label: 'Carbs',
                value: '${carbsG}g',
                delay: 700,
              ),
              _MacroDisplay(
                emoji: '🧈',
                label: 'Fat',
                value: '${fatG}g',
                delay: 800,
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.xl),

          // Explanation
          Container(
            padding: const EdgeInsets.all(AppDimensions.md),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            ),
            child: Text(
              'Based on your info, this is your daily target to $goalText',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(delay: 900.ms, duration: 400.ms)
              .slideY(begin: 0.2, end: 0, delay: 900.ms, duration: 400.ms),
        ],
      ),
      buttonText: "Start Tracking",
      onButtonPressed: () => _handleStartTracking(context),
    );
  }

  /// Handle the "Start Tracking" button press
  /// Saves user data to local storage and navigates to home screen
  Future<void> _handleStartTracking(BuildContext context) async {
    final onboardingState = ref.read(onboardingControllerProvider);
    final localStorage = ref.read(localStorageServiceProvider);
    final results = onboardingState.calculatedResults!;

    try {
      // Create user object with all onboarding data
      final user = User(
        id: const Uuid().v4(),
        createdAt: DateTime.now(),
        name: onboardingState.name,
        age: onboardingState.age,
        gender: onboardingState.gender,
        weightKg: onboardingState.weightKg,
        heightCm: onboardingState.heightCm,
        activityLevel: onboardingState.activityLevel,
        goal: onboardingState.goal,
        tdee: results['tdee'] as int,
        calorieTarget: results['calorie_target'] as int,
        proteinTargetG: results['protein_g'] as int,
        carbsTargetG: results['carbs_g'] as int,
        fatTargetG: results['fat_g'] as int,
        subscriptionStatus: 'trial',
        trialStartDate: DateTime.now(),
        notificationsEnabled: true,
        theme: 'light',
      );

      // Save user to local storage
      await localStorage.saveUser(user);

      // Mark onboarding as complete
      await localStorage.setOnboardingComplete(true);

      // Navigate to home screen and remove all previous routes
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.home,
          (route) => false,
        );
      }
    } catch (e) {
      // Show error to user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  String _getGoalDescription(String goal) {
    switch (goal) {
      case 'lose':
        return 'reach your weight loss goal';
      case 'gain':
        return 'reach your weight gain goal';
      default:
        return 'maintain your current weight';
    }
  }
}

/// Macro display widget
class _MacroDisplay extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final int delay;

  const _MacroDisplay({
    required this.emoji,
    required this.label,
    required this.value,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: AppDimensions.xs),
        Text(
          value,
          style: AppTypography.numberSmall.copyWith(
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: delay.ms, duration: 400.ms)
        .slideY(begin: 0.3, end: 0, delay: delay.ms, duration: 400.ms);
  }
}

/// Placeholder illustration for Otto celebrating
class _OttoCelebratingPlaceholder extends StatelessWidget {
  final bool animate;

  const _OttoCelebratingPlaceholder({this.animate = true});

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '🦦🎉',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );

    if (!animate) return widget;

    return widget
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.1, 1.1),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .scale(
          begin: const Offset(1.1, 1.1),
          end: const Offset(1.0, 1.0),
          duration: 1000.ms,
          curve: Curves.easeInOut,
        );
  }
}
