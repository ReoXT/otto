import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/number_input_field.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';
import 'package:otto/features/onboarding/widgets/pill_selector.dart';

/// Basic info screen - Third onboarding screen (age + gender)
/// Based on otto-spec.md lines 244-249
class BasicInfoScreen extends ConsumerWidget {
  const BasicInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return OnboardingPageTemplate(
      illustration: _OttoMeasuringPlaceholder(),
      title: "Let's get to know you a bit",
      content: Column(
        children: [
          NumberInputField(
            label: "Age",
            unit: "years",
            value: onboardingState.age?.toDouble(),
            min: 13,
            max: 120,
            allowDecimals: false,
            onChanged: (value) {
              controller.setAge(value.toInt());
            },
          ),
          const SizedBox(height: AppDimensions.lg),
          // Gender selection
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Gender",
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          const SizedBox(height: AppDimensions.sm),
          PillSelector(
            options: const ['Male', 'Female', 'Other'],
            selectedOption: onboardingState.gender != null
                ? _capitalizeFirst(onboardingState.gender!)
                : null,
            onSelected: (selected) {
              controller.setGender(selected.toLowerCase());
            },
          ),
        ],
      ),
      buttonText: "Continue",
      onButtonPressed: () {
        controller.nextPage();
      },
      isButtonEnabled: onboardingState.age != null &&
                       onboardingState.gender != null,
    );
  }

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}

/// Placeholder illustration for Otto with measuring tape
class _OttoMeasuringPlaceholder extends StatelessWidget {
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
          '🦦📏',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
