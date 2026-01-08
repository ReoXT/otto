import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Plan card widget for displaying subscription plan options
///
/// Based on otto-spec.md lines 481-489
/// Features:
/// - Title (e.g., "Yearly", "Monthly")
/// - Price (e.g., "$79.99/year")
/// - Optional badge (e.g., "BEST VALUE")
/// - Optional savings text (e.g., "Save 17%")
/// - Selected state styling
class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge;
  final String? savings;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    this.badge,
    this.savings,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.05)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            // Main content
            Column(
              children: [
                // Add spacing for badge if present
                if (badge != null) const SizedBox(height: AppDimensions.spacingM),

                // Title
                Text(
                  title,
                  style: AppTypography.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppDimensions.spacingS),

                // Price
                Text(
                  price,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                // Savings text (if provided)
                if (savings != null) ...[
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    savings!,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),

            // Badge ribbon (if provided)
            if (badge != null) _buildBadge(),
          ],
        ),
      ),
    );
  }

  /// Build badge ribbon
  Widget _buildBadge() {
    return Positioned(
      top: -AppDimensions.spacingL,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacingM,
            vertical: AppDimensions.spacingXs,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Text(
            badge!,
            style: AppTypography.label.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ),
    );
  }
}
