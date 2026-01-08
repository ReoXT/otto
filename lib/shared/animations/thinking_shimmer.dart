import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/typography.dart';

/// Animated shimmer effect on "Thinking..." text
///
/// Uses flutter_animate for gradient shimmer effect.
/// Subtle, not distracting, with looping animation.
///
/// Based on otto-spec.md lines 595-598:
/// - Subtle shimmer/pulse on "Thinking..." text
/// - Smooth transition to calorie display
/// - Brief sparkle animation on completion
class ThinkingShimmer extends StatelessWidget {
  const ThinkingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Animated thinking indicator dot
        _buildPulsingDot(),
        const SizedBox(width: 6),
        // "Thinking..." text with shimmer
        Text(
          'Thinking...',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        )
            .animate(
              onPlay: (controller) => controller.repeat(),
            )
            .shimmer(
              duration: 1500.ms,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
      ],
    );
  }

  /// Build a small pulsing dot indicator
  Widget _buildPulsingDot() {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(reverse: true),
        )
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.2, 1.2),
          duration: 600.ms,
          curve: Curves.easeInOut,
        )
        .then()
        .fadeOut(
          duration: 300.ms,
          begin: 1.0,
        )
        .then()
        .fadeIn(
          duration: 300.ms,
        );
  }
}

/// Alternative shimmer widget with three animated dots
/// Can be used instead of ThinkingShimmer for a different style
class ThinkingDots extends StatelessWidget {
  const ThinkingDots({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Thinking',
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(width: 2),
        // Three animated dots
        ...List.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(left: 2),
            child: Text(
              '.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .fadeIn(
                  duration: 400.ms,
                  delay: Duration(milliseconds: index * 200),
                )
                .then()
                .fadeOut(
                  duration: 400.ms,
                ),
          );
        }),
      ],
    );
  }
}
