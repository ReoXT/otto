import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Selection card widget for choosing between options
/// Used in onboarding for activity level (otto-spec.md lines 258-267) and goals (lines 269-276)
class SelectionCard extends StatelessWidget {
  /// Emoji to display on the left
  final String emoji;

  /// Title text for the option
  final String title;

  /// Description text explaining the option
  final String description;

  /// Whether this card is currently selected
  final bool isSelected;

  /// Callback when the card is tapped
  final VoidCallback onTap;

  const SelectionCard({
    super.key,
    required this.emoji,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColors.primary.withValues(alpha: 0.1)
          : AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(AppDimensions.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.textSecondary.withValues(alpha: 0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Emoji
              Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),

              const SizedBox(width: AppDimensions.md),

              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.xs),
                    Text(
                      description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate(
          target: isSelected ? 1 : 0,
        )
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(0.98, 0.98),
          duration: const Duration(milliseconds: 100),
        );
  }
}
