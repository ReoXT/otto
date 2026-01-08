import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/data/models/food_log.dart';
import 'package:otto/features/food_detail/widgets/macro_display_row.dart';
import 'package:otto/features/food_detail/widgets/sources_display.dart';
import 'package:otto/features/food_detail/widgets/ai_reasoning_card.dart';

/// Food detail bottom sheet showing full details for a food log entry
///
/// Based on otto-spec.md lines 337-374
/// Features:
/// - Modal bottom sheet with DraggableScrollableSheet
/// - Drag handle at top
/// - Close button (X) and more menu (...)
/// - Food name as title
/// - Large calorie display with fire emoji
/// - Macro breakdown row (protein, carbs, fat)
/// - Sources section
/// - AI reasoning section with confidence
/// - Edit option
class FoodDetailSheet extends StatelessWidget {
  final FoodLog foodLog;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const FoodDetailSheet({
    super.key,
    required this.foodLog,
    this.onEdit,
    this.onDelete,
  });

  /// Show the food detail bottom sheet
  static Future<void> show(
    BuildContext context, {
    required FoodLog foodLog,
    VoidCallback? onEdit,
    VoidCallback? onDelete,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FoodDetailSheet(
        foodLog: foodLog,
        onEdit: onEdit,
        onDelete: onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppDimensions.radiusXl),
              topRight: Radius.circular(AppDimensions.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              _buildDragHandle(),

              // Header with actions
              _buildHeader(context),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppDimensions.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food name
                      _buildFoodName(),

                      const SizedBox(height: AppDimensions.spacingXl),

                      // Large calorie display
                      _buildCaloriesDisplay(),

                      const SizedBox(height: AppDimensions.spacingXl),

                      // Macro breakdown
                      _buildMacroBreakdown(),

                      const SizedBox(height: AppDimensions.spacingXl),

                      // Divider
                      Divider(
                        color: AppColors.textSecondary.withValues(alpha: 0.1),
                        height: 1,
                      ),

                      const SizedBox(height: AppDimensions.spacingXl),

                      // Sources section
                      if (foodLog.sources != null && foodLog.sources!.isNotEmpty)
                        _buildSourcesSection(),

                      const SizedBox(height: AppDimensions.spacingXl),

                      // AI reasoning section
                      if (foodLog.aiReasoning != null)
                        _buildReasoningSection(),

                      // Bottom spacing
                      const SizedBox(height: AppDimensions.spacingXl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build drag handle indicator
  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: AppDimensions.spacingM),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(
          begin: const Offset(0.5, 1.0),
          end: const Offset(1.0, 1.0),
          duration: 300.ms,
        );
  }

  /// Build header with close and more menu buttons
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // More menu button
          IconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () => _showMoreMenu(context),
            color: AppColors.textSecondary,
          ),
          // Close button
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: 100.ms)
        .slideY(begin: -0.2, end: 0, duration: 300.ms, delay: 100.ms);
  }

  /// Build food name title
  Widget _buildFoodName() {
    return Text(
      foodLog.foodName ?? foodLog.rawInput,
      style: AppTypography.displaySmall.copyWith(
        color: AppColors.textPrimary,
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: 200.ms);
  }

  /// Build large calorie display
  Widget _buildCaloriesDisplay() {
    return Center(
      child: Column(
        children: [
          Text(
            '🔥',
            style: const TextStyle(fontSize: 48),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 300.ms)
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                delay: 300.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            '${foodLog.displayCalories}',
            style: AppTypography.numberLarge.copyWith(
              color: AppColors.primary,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 600.ms,
                delay: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: AppDimensions.spacingXs),
          Text(
            'total calories',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          )
              .animate()
              .fadeIn(duration: 400.ms, delay: 500.ms),
        ],
      ),
    );
  }

  /// Build macro breakdown section
  Widget _buildMacroBreakdown() {
    return MacroDisplayRow(
      protein: foodLog.displayProtein,
      carbs: foodLog.displayCarbs,
      fat: foodLog.displayFat,
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 600.ms)
        .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 600.ms);
  }

  /// Build sources section
  Widget _buildSourcesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Sources',
          style: AppTypography.headlineSmall.copyWith(
            color: AppColors.textPrimary,
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 700.ms)
            .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: 700.ms),
        const SizedBox(height: AppDimensions.spacingM),
        SourcesDisplay(sources: foodLog.sources!)
            .animate()
            .fadeIn(duration: 500.ms, delay: 800.ms)
            .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 800.ms),
      ],
    );
  }

  /// Build AI reasoning section
  Widget _buildReasoningSection() {
    return AIReasoningCard(
      reasoning: foodLog.aiReasoning!,
      confidenceScore: foodLog.confidenceScore ?? 50,
      onEditTapped: onEdit,
    )
        .animate()
        .fadeIn(duration: 600.ms, delay: 900.ms)
        .slideY(begin: 0.2, end: 0, duration: 600.ms, delay: 900.ms);
  }

  /// Show more menu with options
  void _showMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusL),
          topRight: Radius.circular(AppDimensions.radiusL),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: const EdgeInsets.only(top: AppDimensions.spacingM),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textSecondary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),

            // Edit option
            if (onEdit != null)
              ListTile(
                leading: Icon(
                  Icons.edit_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('Edit nutrition data'),
                onTap: () {
                  Navigator.of(context).pop();
                  onEdit?.call();
                },
              ),

            // Delete option
            if (onDelete != null)
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                ),
                title: Text(
                  'Delete entry',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(); // Close detail sheet too
                  onDelete?.call();
                },
              ),

            const SizedBox(height: AppDimensions.spacingM),
          ],
        ),
      ),
    );
  }
}
