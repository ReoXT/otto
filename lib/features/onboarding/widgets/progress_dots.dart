import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';

/// Progress indicator dots for onboarding flow
/// Based on otto-spec.md line 229 - "Progress indicator (dots)"
class ProgressDots extends StatelessWidget {
  /// Total number of dots to display
  final int totalDots;

  /// Current active dot index (0-based)
  final int currentIndex;

  const ProgressDots({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalDots,
        (index) => _buildDot(index, index == currentIndex),
      ),
    );
  }

  Widget _buildDot(int index, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.xs),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: isActive ? 12.0 : 8.0,
        height: isActive ? 12.0 : 8.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
        ),
      ),
    )
        .animate(key: ValueKey('dot_$index'))
        .scale(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
  }
}
