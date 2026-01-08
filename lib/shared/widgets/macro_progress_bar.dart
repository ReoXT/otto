import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Macro progress bar widget for displaying nutrition goals
///
/// Based on otto-spec.md lines 375-400
/// Features:
/// - Label row with emoji and label on left, current/target on right
/// - Animated progress bar below
/// - Color coding: Green (<80%), Yellow (80-100%), Red (>100%)
/// - Smooth fill animation
class MacroProgressBar extends StatelessWidget {
  final String label;
  final String emoji;
  final double current;
  final double target;
  final String unit; // "cal" or "g"
  final bool animateOnMount;

  const MacroProgressBar({
    super.key,
    required this.label,
    required this.emoji,
    required this.current,
    required this.target,
    required this.unit,
    this.animateOnMount = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = target > 0 ? (current / target).clamp(0.0, 1.5) : 0.0;
    final color = _getProgressColor(percentage);
    final displayPercentage = (percentage * 100).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left side: emoji + label
            Row(
              children: [
                Text(
                  emoji,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                Text(
                  label,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Right side: current / target
            Row(
              children: [
                Text(
                  current.toStringAsFixed(current.truncateToDouble() == current ? 0 : 1),
                  style: AppTypography.numbersFont.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  ' / ',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${target.toStringAsFixed(target.truncateToDouble() == target ? 0 : 1)}$unit',
                  style: AppTypography.numbersFont.copyWith(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: AppDimensions.spacingS),

        // Progress bar
        _buildProgressBar(percentage, color, displayPercentage),
      ],
    );
  }

  /// Build animated progress bar
  Widget _buildProgressBar(double percentage, Color color, int displayPercentage) {
    return Stack(
      children: [
        // Background track
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        ),
        // Progress fill
        FractionallySizedBox(
          widthFactor: percentage.clamp(0.0, 1.0),
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          )
              .animate(
                onPlay: animateOnMount ? null : (controller) => controller.forward(from: 1.0),
              )
              .scaleX(
                begin: 0.0,
                end: 1.0,
                duration: 800.ms,
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
              ),
        ),
        // Percentage label (shown when over 100%)
        if (percentage > 1.0)
          Positioned(
            right: 4,
            top: 0,
            bottom: 0,
            child: Center(
              child: Text(
                '+${displayPercentage - 100}%',
                style: AppTypography.label.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
                  .animate()
                  .fadeIn(duration: 400.ms, delay: 800.ms)
                  .scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    duration: 400.ms,
                    delay: 800.ms,
                  ),
            ),
          ),
      ],
    );
  }

  /// Get progress bar color based on percentage
  Color _getProgressColor(double percentage) {
    if (percentage > 1.0) {
      return AppColors.progressRed; // Over limit
    } else if (percentage >= 0.8) {
      return AppColors.progressYellow; // Approaching limit (80-100%)
    } else {
      return AppColors.progressGreen; // Under target
    }
  }
}

/// Compact macro progress indicator (just the bar, no labels)
class MacroProgressIndicator extends StatelessWidget {
  final double current;
  final double target;
  final double height;

  const MacroProgressIndicator({
    super.key,
    required this.current,
    required this.target,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = target > 0 ? (current / target).clamp(0.0, 1.5) : 0.0;
    final color = _getProgressColor(percentage);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: percentage.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage > 1.0) {
      return AppColors.progressRed;
    } else if (percentage >= 0.8) {
      return AppColors.progressYellow;
    } else {
      return AppColors.progressGreen;
    }
  }
}
