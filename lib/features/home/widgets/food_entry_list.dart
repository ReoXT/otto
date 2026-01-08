import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/data/models/food_log.dart';
import 'package:otto/features/home/widgets/food_entry_card.dart';

/// Food entry list widget for displaying all food logs
///
/// Based on otto-spec.md lines 315-321
/// Features:
/// - ListView.builder for efficient rendering
/// - FoodEntryCard for each log
/// - Swipe to delete with Dismissible
/// - Empty state when list is empty
/// - Oldest entries at top (chronological order like notes)
class FoodEntryList extends StatelessWidget {
  final List<FoodLog> logs;
  final Function(FoodLog) onLogTap;
  final Function(FoodLog) onLogDelete;

  const FoodEntryList({
    super.key,
    required this.logs,
    required this.onLogTap,
    required this.onLogDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      itemCount: logs.length,
      separatorBuilder: (context, index) => const SizedBox(
        height: AppDimensions.spacingS,
      ),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildDismissibleEntry(context, log, index);
      },
    );
  }

  /// Build a dismissible food entry card with swipe-to-delete
  Widget _buildDismissibleEntry(BuildContext context, FoodLog log, int index) {
    return Dismissible(
      key: Key(log.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(context),
      onDismissed: (direction) => onLogDelete(log),
      background: _buildDismissBackground(),
      child: FoodEntryCard(
        foodLog: log,
        onTap: () => onLogTap(log),
        onDelete: () => onLogDelete(log),
      )
          .animate()
          .fadeIn(
            duration: 300.ms,
            delay: Duration(milliseconds: index * 50),
          )
          .slideX(
            begin: 0.1,
            end: 0,
            duration: 300.ms,
            delay: Duration(milliseconds: index * 50),
            curve: Curves.easeOutCubic,
          ),
    );
  }

  /// Build the red delete background shown when swiping
  Widget _buildDismissBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Delete',
            style: AppTypography.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingS),
          const Icon(
            Icons.delete_outline,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  /// Show confirmation dialog before deleting
  Future<bool> _confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This will remove this food log from your daily total.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Build empty state when no logs exist
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          Text(
            'No food logged yet',
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingS),
          Text(
            'Type what you ate below to get started',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
