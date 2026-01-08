import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Bottom input bar for food logging
class CalorieInputBar extends StatelessWidget {
  final int caloriesLeft;
  final VoidCallback onVoicePressed;
  final VoidCallback onQuickAddPressed;
  final VoidCallback onSubmit;
  final TextEditingController? controller;

  const CalorieInputBar({
    super.key,
    required this.caloriesLeft,
    required this.onVoicePressed,
    required this.onQuickAddPressed,
    required this.onSubmit,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.textSecondary,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Calories left display
            Text(
              '🔥 $caloriesLeft left',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            // Input row
            Row(
              children: [
                // Voice input button
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: onVoicePressed,
                  color: AppColors.primary,
                ),
                const SizedBox(width: AppDimensions.spacingS),
                // Text input field
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'What did you eat?',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingM,
                        vertical: AppDimensions.spacingS,
                      ),
                    ),
                    onSubmitted: (_) => onSubmit(),
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingS),
                // Quick add button
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: onQuickAddPressed,
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
