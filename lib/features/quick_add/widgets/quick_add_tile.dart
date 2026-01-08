import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/data/models/frequent_food.dart';

/// Tile widget for displaying a frequent food in the Quick Add sheet
///
/// Based on otto-spec.md lines 404-423
/// Layout:
/// - Food name on the left (primary text)
/// - Calorie count on the right (using numbers font)
/// - Tappable with visual feedback
class QuickAddTile extends StatelessWidget {
  final FrequentFood food;
  final VoidCallback onTap;

  const QuickAddTile({
    super.key,
    required this.food,
    required this.onTap,
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
            color: Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Food name on the left
            Expanded(
              child: Text(
                food.foodName,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            // Calories on the right
            Text(
              '${food.calories} cal',
              style: AppTypography.numbersFont.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
