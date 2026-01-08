import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';
import 'package:otto/features/onboarding/widgets/selection_card.dart';

/// Activity level screen - Fifth onboarding screen
/// Based on otto-spec.md lines 258-267
class ActivityLevelScreen extends ConsumerWidget {
  const ActivityLevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingPageTemplate(
      illustration: _OttoThinkingPlaceholder(),
      title: "How active are you typically?",
      content: Column(
        children: [
          SelectionCard(
            emoji: "🛋️",
            title: "Sedentary",
            description: "Desk job, minimal exercise",
            isSelected: onboardingState.activityLevel == 'sedentary',
            onTap: () => controller.setActivityLevel('sedentary'),
          ),
          const SizedBox(height: AppDimensions.sm),
          SelectionCard(
            emoji: "🚶",
            title: "Lightly Active",
            description: "Light exercise 1-3 days/week",
            isSelected: onboardingState.activityLevel == 'light',
            onTap: () => controller.setActivityLevel('light'),
          ),
          const SizedBox(height: AppDimensions.sm),
          SelectionCard(
            emoji: "🏃",
            title: "Moderately Active",
            description: "Moderate exercise 3-5 days/week",
            isSelected: onboardingState.activityLevel == 'moderate',
            onTap: () => controller.setActivityLevel('moderate'),
          ),
          const SizedBox(height: AppDimensions.sm),
          SelectionCard(
            emoji: "💪",
            title: "Very Active",
            description: "Hard exercise 6-7 days/week",
            isSelected: onboardingState.activityLevel == 'active',
            onTap: () => controller.setActivityLevel('active'),
          ),
          const SizedBox(height: AppDimensions.sm),
          SelectionCard(
            emoji: "🔥",
            title: "Extremely Active",
            description: "Athlete or physical job",
            isSelected: onboardingState.activityLevel == 'very_active',
            onTap: () => controller.setActivityLevel('very_active'),
          ),
        ],
      ),
      buttonText: "Continue",
      onButtonPressed: () {
        controller.nextPage();
      },
      isButtonEnabled: onboardingState.activityLevel != null,
    );
  }
}

/// Placeholder illustration for Otto thinking
class _OttoThinkingPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '🦦🤔',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
