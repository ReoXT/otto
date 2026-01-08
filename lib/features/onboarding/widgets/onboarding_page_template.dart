import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Reusable template widget for onboarding screens
/// Based on otto-spec.md lines 223-230
class OnboardingPageTemplate extends StatelessWidget {
  /// The otter illustration widget to display at the top
  final Widget illustration;

  /// Main title text displayed prominently
  final String title;

  /// Optional subtitle for additional context
  final String? subtitle;

  /// Optional content area for form fields or other widgets
  final Widget? content;

  /// Text to display on the primary action button
  final String buttonText;

  /// Callback when the button is pressed
  final VoidCallback onButtonPressed;

  /// Whether the button should be enabled
  final bool isButtonEnabled;

  const OnboardingPageTemplate({
    super.key,
    required this.illustration,
    required this.title,
    this.subtitle,
    this.content,
    required this.buttonText,
    required this.onButtonPressed,
    this.isButtonEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimensions.lg),
        child: Column(
          children: [
            // Top spacing
            const SizedBox(height: AppDimensions.xl),

            // Illustration section (expanded to take available space)
            Expanded(
              flex: 2,
              child: Center(
                child: illustration,
              ),
            ),

            // Title
            Text(
              title,
              style: AppTypography.displayMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppDimensions.md),

            // Optional subtitle
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.lg),
            ],

            // Optional content area
            if (content != null) ...[
              content!,
              const SizedBox(height: AppDimensions.lg),
            ] else ...[
              // Add spacing if no content
              const Spacer(flex: 1),
            ],

            // Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isButtonEnabled ? onButtonPressed : null,
                child: Text(buttonText),
              ),
            ),

            // Bottom padding
            const SizedBox(height: AppDimensions.lg),
          ],
        ),
      ),
    );
  }
}
