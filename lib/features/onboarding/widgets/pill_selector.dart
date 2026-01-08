import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Pill-shaped button selector for multiple choice options
/// Used in onboarding screens for gender selection (otto-spec.md line 248)
class PillSelector extends StatelessWidget {
  /// List of options to display
  final List<String> options;

  /// Currently selected option
  final String? selectedOption;

  /// Callback when an option is selected
  final Function(String) onSelected;

  const PillSelector({
    super.key,
    required this.options,
    this.selectedOption,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimensions.sm,
      runSpacing: AppDimensions.sm,
      alignment: WrapAlignment.center,
      children: options.map((option) {
        final isSelected = option == selectedOption;
        return _buildPillButton(option, isSelected);
      }).toList(),
    );
  }

  Widget _buildPillButton(String option, bool isSelected) {
    return Material(
      color: isSelected ? AppColors.primary : AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      elevation: 0,
      child: InkWell(
        onTap: () => onSelected(option),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.lg,
            vertical: AppDimensions.md,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.textSecondary.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Text(
            option,
            style: AppTypography.button.copyWith(
              color: isSelected ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}
