import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';
import 'package:otto/features/onboarding/widgets/selection_card.dart';

/// Goal screen - Sixth onboarding screen
/// Based on otto-spec.md lines 269-276
class GoalScreen extends ConsumerWidget {
  const GoalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingPageTemplate(
      illustration: _OttoGoalPlaceholder(),
      title: "What's your goal?",
      content: Column(
        children: [
          SelectionCard(
            emoji: "📉",
            title: "Lose Weight",
            description: "Burn more than you eat",
            isSelected: onboardingState.goal == 'lose',
            onTap: () => controller.setGoal('lose'),
          ),
          const SizedBox(height: AppDimensions.md),
          SelectionCard(
            emoji: "⚖️",
            title: "Maintain Weight",
            description: "Keep things balanced",
            isSelected: onboardingState.goal == 'maintain',
            onTap: () => controller.setGoal('maintain'),
          ),
          const SizedBox(height: AppDimensions.md),
          SelectionCard(
            emoji: "📈",
            title: "Gain Weight",
            description: "Build muscle or increase intake",
            isSelected: onboardingState.goal == 'gain',
            onTap: () => controller.setGoal('gain'),
          ),
        ],
      ),
      buttonText: "Continue",
      onButtonPressed: () async {
        // Calculate TDEE and navigate to results
        await controller.calculateAndSave();
        controller.nextPage();
      },
      isButtonEnabled: onboardingState.goal != null,
    );
  }
}

/// Placeholder illustration for Otto with goals
class _OttoGoalPlaceholder extends StatelessWidget {
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
          '🦦🎯',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
