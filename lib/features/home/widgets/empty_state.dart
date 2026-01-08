import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Empty state widget shown when no food logs exist for the day
///
/// Based on otto-spec.md lines 99-127 (Home Screen empty state)
/// Shows:
/// - Otto otter icon (placeholder for illustration)
/// - "No food logged yet today" message
/// - Encouraging subtitle
/// - Subtle animations for engagement
class EmptyFoodLogState extends StatelessWidget {
  const EmptyFoodLogState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Otto illustration placeholder with floating animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.water_drop,
              size: 64,
              color: AppColors.primary,
            ),
          )
              .animate(
                onPlay: (controller) => controller.repeat(reverse: true),
              )
              .moveY(
                begin: 0,
                end: -10,
                duration: 2000.ms,
                curve: Curves.easeInOut,
              ),

          const SizedBox(height: AppDimensions.spacingL),

          // "No food logged yet" message
          Text(
            'No food logged yet today',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 200.ms,
              ),

          const SizedBox(height: AppDimensions.spacingS),

          // Encouraging subtitle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingXl),
            child: Text(
              'Type what you ate below to get started',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          )
              .animate()
              .fadeIn(duration: 600.ms, delay: 400.ms)
              .slideY(
                begin: 0.2,
                end: 0,
                duration: 600.ms,
                delay: 400.ms,
              ),
        ],
      ),
    );
  }
}
