import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/typography.dart';

/// Streak badge widget showing current streak with flame animation
///
/// Based on otto-spec.md:
/// - Lines 312: "Streak badge with flame emoji (🔥 5)"
/// - Lines 600-602: "Flame flicker animation"
///
/// Features:
/// - Pill-shaped container with warm background
/// - Flame emoji + streak count
/// - Subtle opacity pulse animation (flicker effect)
class StreakBadge extends StatelessWidget {
  /// Current streak count
  final int streakCount;

  const StreakBadge({
    super.key,
    this.streakCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Flame emoji with flicker animation
          Text(
            '🔥',
            style: const TextStyle(fontSize: 16),
          )
              .animate(
                onPlay: (controller) => controller.repeat(),
              )
              .fadeIn(duration: 800.ms)
              .then()
              .shimmer(
                duration: 1500.ms,
                color: AppColors.secondary.withValues(alpha: 0.3),
              ),
          
          const SizedBox(width: 4),
          
          // Streak count
          Text(
            '$streakCount',
            style: AppTypography.label.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
