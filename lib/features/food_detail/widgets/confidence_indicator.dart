import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Confidence indicator widget showing AI confidence score
///
/// Based on otto-spec.md lines 358-365
/// Displays:
/// - Circular progress indicator
/// - Score number in center (0-100)
/// - Color coded: green (70+), yellow (40-69), red (<40)
/// - Confidence label below: "High", "Medium", "Low"
class ConfidenceIndicator extends StatelessWidget {
  final int score; // 0-100

  const ConfidenceIndicator({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final confidence = _getConfidenceLevel(score);
    final color = _getConfidenceColor(score);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular progress indicator with score
        SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 8,
                backgroundColor: AppColors.background,
                valueColor: AlwaysStoppedAnimation<Color>(
                  color.withValues(alpha: 0.2),
                ),
              ),
              // Progress circle
              CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              // Score in center
              Text(
                '$score',
                style: AppTypography.numberSmall.copyWith(
                  fontSize: 28,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        // Confidence label
        Text(
          confidence,
          style: AppTypography.label.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Get confidence level label based on score
  String _getConfidenceLevel(int score) {
    if (score >= 70) {
      return 'High Confidence';
    } else if (score >= 40) {
      return 'Medium Confidence';
    } else {
      return 'Low Confidence';
    }
  }

  /// Get color based on confidence score
  Color _getConfidenceColor(int score) {
    if (score >= 70) {
      return AppColors.success; // Green
    } else if (score >= 40) {
      return AppColors.progressYellow; // Yellow
    } else {
      return AppColors.error; // Red
    }
  }
}

/// Compact confidence badge for smaller spaces
class ConfidenceBadge extends StatelessWidget {
  final int score;

  const ConfidenceBadge({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getConfidenceColor(score);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingS,
        vertical: AppDimensions.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingXs),
          Text(
            '$score',
            style: AppTypography.label.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(int score) {
    if (score >= 70) {
      return AppColors.success;
    } else if (score >= 40) {
      return AppColors.progressYellow;
    } else {
      return AppColors.error;
    }
  }
}
