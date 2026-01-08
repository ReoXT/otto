import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/features/food_detail/widgets/confidence_indicator.dart';

/// AI reasoning card widget showing Otto's thought process
///
/// Based on otto-spec.md lines 356-364, 371
/// Features:
/// - "Otto's thought process" header
/// - Confidence indicator with score
/// - Reasoning text in conversational first-person style
/// - "Something off? Click to edit" prompt at bottom
/// - Tappable to edit nutrition data
class AIReasoningCard extends StatelessWidget {
  final String reasoning;
  final int confidenceScore;
  final VoidCallback? onEditTapped;

  const AIReasoningCard({
    super.key,
    required this.reasoning,
    required this.confidenceScore,
    this.onEditTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                "Otto's thought process",
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms)
                  .slideX(begin: -0.1, end: 0, duration: 400.ms),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Confidence indicator and score
          Row(
            children: [
              ConfidenceIndicator(score: confidenceScore)
                  .animate()
                  .fadeIn(duration: 500.ms, delay: 200.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 500.ms,
                    delay: 200.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(width: AppDimensions.spacingL),
              Expanded(
                child: _buildConfidenceExplanation()
                    .animate()
                    .fadeIn(duration: 400.ms, delay: 300.ms)
                    .slideX(begin: 0.1, end: 0, duration: 400.ms, delay: 300.ms),
              ),
            ],
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // Divider
          Divider(
            color: AppColors.textSecondary.withValues(alpha: 0.1),
            height: 1,
          ),

          const SizedBox(height: AppDimensions.spacingL),

          // AI reasoning text
          Text(
            reasoning,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.6,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 400.ms),

          const SizedBox(height: AppDimensions.spacingL),

          // Edit prompt
          InkWell(
            onTap: onEditTapped,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.edit_outlined,
                    size: 18,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    'Something off? Click to edit',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 600.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms, delay: 600.ms),
        ],
      ),
    );
  }

  /// Build confidence explanation text based on score
  Widget _buildConfidenceExplanation() {
    String explanation;
    if (confidenceScore >= 70) {
      explanation = "I'm quite confident about this estimate based on reliable sources.";
    } else if (confidenceScore >= 40) {
      explanation = "I found some data, but there's room for uncertainty. You might want to verify.";
    } else {
      explanation = "This is a rough estimate. Consider editing if you have more accurate info.";
    }

    return Text(
      explanation,
      style: AppTypography.bodySmall.copyWith(
        color: AppColors.textSecondary,
        height: 1.5,
      ),
    );
  }
}

/// Compact AI reasoning display for smaller spaces
class AIReasoningCompact extends StatelessWidget {
  final String reasoning;
  final int confidenceScore;

  const AIReasoningCompact({
    super.key,
    required this.reasoning,
    required this.confidenceScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Otto says:",
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ConfidenceBadge(score: confidenceScore),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            _truncateReasoning(reasoning, 120),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _truncateReasoning(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
