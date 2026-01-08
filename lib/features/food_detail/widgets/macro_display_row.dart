import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Macro display row widget showing protein, carbs, and fat breakdown
///
/// Based on otto-spec.md lines 350-351
/// Layout:
/// - Three columns evenly spaced
/// - Each shows: value in grams, emoji, and label
/// - Protein: 🥜, Carbs: 🍞, Fat: 🧈
class MacroDisplayRow extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;

  const MacroDisplayRow({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _MacroItem(
          emoji: '🥜',
          label: 'Protein',
          value: protein,
        ),
        _MacroItem(
          emoji: '🍞',
          label: 'Carbs',
          value: carbs,
        ),
        _MacroItem(
          emoji: '🧈',
          label: 'Fat',
          value: fat,
        ),
      ],
    );
  }
}

/// Individual macro item widget
class _MacroItem extends StatelessWidget {
  final String emoji;
  final String label;
  final double value;

  const _MacroItem({
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Emoji
        Text(
          emoji,
          style: const TextStyle(fontSize: 32),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        // Value with unit
        Text(
          '${value.toStringAsFixed(1)}g',
          style: AppTypography.numberSmall.copyWith(
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        // Label
        Text(
          label,
          style: AppTypography.label.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

/// Compact horizontal macro display for smaller spaces
class MacroDisplayCompact extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;

  const MacroDisplayCompact({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CompactMacroItem(emoji: '🥜', value: protein),
        const SizedBox(width: AppDimensions.spacingM),
        _CompactMacroItem(emoji: '🍞', value: carbs),
        const SizedBox(width: AppDimensions.spacingM),
        _CompactMacroItem(emoji: '🧈', value: fat),
      ],
    );
  }
}

class _CompactMacroItem extends StatelessWidget {
  final String emoji;
  final double value;

  const _CompactMacroItem({
    required this.emoji,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: AppDimensions.spacingXs),
        Text(
          '${value.toStringAsFixed(0)}g',
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
