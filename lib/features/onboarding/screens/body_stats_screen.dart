import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/number_input_field.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';
import 'package:otto/features/onboarding/widgets/unit_toggle.dart';

/// Body stats screen - Fourth onboarding screen (height + weight with unit conversion)
/// Based on otto-spec.md lines 251-256
class BodyStatsScreen extends ConsumerWidget {
  const BodyStatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    // Calculate display values based on selected units
    final displayWeight = onboardingState.weightKg != null
        ? (onboardingState.useMetric
            ? onboardingState.weightKg!
            : OnboardingController.kgToLbs(onboardingState.weightKg!))
        : null;

    final displayHeight = onboardingState.heightCm != null
        ? (onboardingState.useMetric
            ? onboardingState.heightCm!
            : onboardingState.heightCm! / 2.54) // Convert to inches
        : null;

    return OnboardingPageTemplate(
      illustration: _OttoSwimmingPlaceholder(),
      title: "Almost there!",
      content: Column(
        children: [
          // Height input with unit toggle
          Row(
            children: [
              Expanded(
                child: NumberInputField(
                  label: "Height",
                  unit: onboardingState.useMetric ? "cm" : "in",
                  value: displayHeight,
                  min: onboardingState.useMetric ? 100 : 39,
                  max: onboardingState.useMetric ? 250 : 98,
                  allowDecimals: !onboardingState.useMetric,
                  onChanged: (value) {
                    final heightCm = onboardingState.useMetric
                        ? value
                        : value * 2.54; // Convert inches to cm
                    controller.setHeight(heightCm);
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              UnitToggle(
                leftLabel: "cm",
                rightLabel: "in",
                isLeftSelected: onboardingState.useMetric,
                onChanged: (isMetric) {
                  controller.toggleMetric();
                },
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.lg),
          // Weight input with unit toggle
          Row(
            children: [
              Expanded(
                child: NumberInputField(
                  label: "Weight",
                  unit: onboardingState.useMetric ? "kg" : "lbs",
                  value: displayWeight,
                  min: onboardingState.useMetric ? 30 : 66,
                  max: onboardingState.useMetric ? 300 : 661,
                  allowDecimals: true,
                  onChanged: (value) {
                    final weightKg = onboardingState.useMetric
                        ? value
                        : OnboardingController.lbsToKg(value);
                    controller.setWeight(weightKg);
                  },
                ),
              ),
              const SizedBox(width: AppDimensions.sm),
              UnitToggle(
                leftLabel: "kg",
                rightLabel: "lbs",
                isLeftSelected: onboardingState.useMetric,
                onChanged: (isMetric) {
                  controller.toggleMetric();
                },
              ),
            ],
          ),
        ],
      ),
      buttonText: "Continue",
      onButtonPressed: () {
        controller.nextPage();
      },
      isButtonEnabled: onboardingState.heightCm != null &&
                       onboardingState.weightKg != null,
    );
  }
}

/// Placeholder illustration for Otto swimming
class _OttoSwimmingPlaceholder extends StatelessWidget {
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
          '🦦🏊',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
