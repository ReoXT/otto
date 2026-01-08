import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/features/onboarding/controllers/onboarding_controller.dart';
import 'package:otto/features/onboarding/widgets/onboarding_page_template.dart';

/// Welcome screen - First onboarding screen
/// Based on otto-spec.md lines 232-236
class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingPageTemplate(
      illustration: _OttoWavingPlaceholder()
          .animate()
          .fadeIn(duration: 600.ms, curve: Curves.easeOut)
          .slideY(begin: 0.1, end: 0, duration: 600.ms, curve: Curves.easeOut),
      title: "Hey there! I'm Otto 🦦",
      subtitle: "I'll help you track what you eat—no complicated food databases, "
          "just type like you're taking notes",
      buttonText: "Get Started",
      onButtonPressed: () {
        ref.read(onboardingControllerProvider.notifier).nextPage();
      },
    );
  }
}

/// Placeholder illustration for Otto waving
/// Replace with actual Lottie/Rive animation or image asset when available
class _OttoWavingPlaceholder extends StatelessWidget {
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
          '🦦👋',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
