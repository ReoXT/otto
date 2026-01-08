import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Feature list item widget for displaying a single feature with checkmark
///
/// Based on otto-spec.md lines 474-478
/// Layout:
/// - Checkmark icon (green) on the left
/// - Feature text on the right
class FeatureListItem extends StatelessWidget {
  final String text;

  const FeatureListItem({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Checkmark icon
        Icon(
          Icons.check_circle,
          color: AppColors.accent,
          size: 24,
        ),

        const SizedBox(width: AppDimensions.spacingM),

        // Feature text
        Expanded(
          child: Text(
            text,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
