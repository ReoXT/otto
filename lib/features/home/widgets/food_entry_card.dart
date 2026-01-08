import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/data/models/food_log.dart';
import 'package:otto/shared/animations/thinking_shimmer.dart';

/// Food entry card widget for displaying individual food log items
///
/// Based on otto-spec.md lines 315-321
/// Layout:
/// - Row with rawInput text on left
/// - Right side shows one of:
///   - "Thinking..." with shimmer animation (isProcessing)
///   - "✨ {calories} cal" (completed)
///   - Error icon (has error)
/// - Subtle divider between entries
/// - InkWell for tap handling
class FoodEntryCard extends StatelessWidget {
  final FoodLog foodLog;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const FoodEntryCard({
    super.key,
    required this.foodLog,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingM,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          border: Border.all(
            color: _getBorderColor(),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Food name/raw input on the left
            Expanded(
              child: Text(
                foodLog.foodName ?? foodLog.rawInput,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            // Status indicator on the right
            _buildStatusIndicator(),
          ],
        ),
      ),
    );
  }

  /// Get border color based on status
  Color _getBorderColor() {
    if (foodLog.errorMessage != null) {
      return AppColors.error.withValues(alpha: 0.3);
    }
    if (foodLog.isProcessing) {
      return AppColors.primary.withValues(alpha: 0.3);
    }
    return Colors.transparent;
  }

  /// Build the status indicator based on food log state
  Widget _buildStatusIndicator() {
    // Error state
    if (foodLog.errorMessage != null) {
      return _buildErrorIndicator();
    }

    // Processing state
    if (foodLog.isProcessing) {
      return const ThinkingShimmer();
    }

    // Completed state - show calories
    return _buildCaloriesDisplay();
  }

  /// Build error indicator with icon and retry hint
  Widget _buildErrorIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          color: AppColors.error,
          size: AppDimensions.iconM,
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(
          'Retry',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  /// Build calories display with sparkle emoji
  Widget _buildCaloriesDisplay() {
    final calories = foodLog.displayCalories;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '✨',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(
          '$calories cal',
          style: AppTypography.numbersFont.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
