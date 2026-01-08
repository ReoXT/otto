import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Small toggle switch for unit selection (e.g., kg/lbs, cm/ft)
/// Used in onboarding body stats screen (otto-spec.md lines 254-255)
class UnitToggle extends StatelessWidget {
  /// Label for the left option (e.g., "kg")
  final String leftLabel;

  /// Label for the right option (e.g., "lbs")
  final String rightLabel;

  /// Whether the left option is currently selected
  final bool isLeftSelected;

  /// Callback when selection changes
  final Function(bool) onChanged;

  const UnitToggle({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.isLeftSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(
          color: AppColors.textSecondary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleButton(
            label: leftLabel,
            isSelected: isLeftSelected,
            onTap: () => onChanged(true),
            isLeft: true,
          ),
          _buildToggleButton(
            label: rightLabel,
            isSelected: !isLeftSelected,
            onTap: () => onChanged(false),
            isLeft: false,
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isLeft,
  }) {
    return Material(
      color: isSelected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.horizontal(
        left: isLeft ? const Radius.circular(AppDimensions.radiusM) : Radius.zero,
        right: !isLeft ? const Radius.circular(AppDimensions.radiusM) : Radius.zero,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.horizontal(
          left: isLeft ? const Radius.circular(AppDimensions.radiusM) : Radius.zero,
          right: !isLeft ? const Radius.circular(AppDimensions.radiusM) : Radius.zero,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.md,
            vertical: AppDimensions.sm,
          ),
          child: Text(
            label,
            style: AppTypography.button.copyWith(
              fontSize: 14,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
