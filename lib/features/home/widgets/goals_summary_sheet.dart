import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/features/home/controllers/home_controller.dart';
import 'package:otto/providers/local_storage_provider.dart';
import 'package:otto/shared/widgets/macro_progress_bar.dart';

/// Goals summary sheet showing nutrition progress
///
/// Based on otto-spec.md lines 375-400
/// Features:
/// - "Goals" header
/// - Calorie progress bar with current/target
/// - Carbs progress bar with current/target
/// - Protein progress bar with current/target
/// - Fat progress bar with current/target
/// - Color coding: Green (<80%), Yellow (80-100%), Red (>100%)
class GoalsSummarySheet extends ConsumerWidget {
  const GoalsSummarySheet({super.key});

  /// Show the goals summary as a modal bottom sheet
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const GoalsSummarySheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    // Get user data for targets
    final userAsync = ref.watch(currentUserProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusXl),
          topRight: Radius.circular(AppDimensions.radiusXl),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
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
                    ),
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Goals',
                    style: AppTypography.displaySmall.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 100.ms)
                      .slideX(begin: -0.1, end: 0, duration: 400.ms, delay: 100.ms),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    color: AppColors.textSecondary,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms, delay: 100.ms),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingXl),

              // Progress bars
              userAsync.when(
                data: (user) {
                  if (user == null) {
                    return _buildNoUserState();
                  }

                  final calorieTarget = user.calorieTarget ?? homeState.calorieTarget;
                  final proteinTarget = user.proteinTargetG?.toDouble() ?? 100.0;
                  final carbsTarget = user.carbsTargetG?.toDouble() ?? 150.0;
                  final fatTarget = user.fatTargetG?.toDouble() ?? 50.0;

                  final totalCalories = controller.totalCaloriesConsumed.toDouble();
                  final totalProtein = _getTotalMacro(homeState.todaysLogs, 'protein');
                  final totalCarbs = _getTotalMacro(homeState.todaysLogs, 'carbs');
                  final totalFat = _getTotalMacro(homeState.todaysLogs, 'fat');

                  return Column(
                    children: [
                      // Calories
                      MacroProgressBar(
                        label: 'Calories',
                        emoji: '🔥',
                        current: totalCalories,
                        target: calorieTarget.toDouble(),
                        unit: 'cal',
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 200.ms)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 200.ms),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Carbs
                      MacroProgressBar(
                        label: 'Carbs',
                        emoji: '🍞',
                        current: totalCarbs,
                        target: carbsTarget,
                        unit: 'g',
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 300.ms)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 300.ms),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Protein
                      MacroProgressBar(
                        label: 'Protein',
                        emoji: '🥜',
                        current: totalProtein,
                        target: proteinTarget,
                        unit: 'g',
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 400.ms)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 400.ms),

                      const SizedBox(height: AppDimensions.spacingL),

                      // Fat
                      MacroProgressBar(
                        label: 'Fat',
                        emoji: '🧈',
                        current: totalFat,
                        target: fatTarget,
                        unit: 'g',
                      )
                          .animate()
                          .fadeIn(duration: 500.ms, delay: 500.ms)
                          .slideY(begin: 0.2, end: 0, duration: 500.ms, delay: 500.ms),

                      const SizedBox(height: AppDimensions.spacingXl),
                    ],
                  );
                },
                loading: () => _buildLoadingState(),
                error: (error, stack) => _buildErrorState(error.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Calculate total macro from food logs
  double _getTotalMacro(List logs, String macroType) {
    return logs.fold<double>(0.0, (sum, log) {
      if (log.isProcessing || log.errorMessage != null) return sum;

      switch (macroType) {
        case 'protein':
          return sum + log.displayProtein;
        case 'carbs':
          return sum + log.displayCarbs;
        case 'fat':
          return sum + log.displayFat;
        default:
          return sum;
      }
    });
  }

  Widget _buildNoUserState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: AppColors.textSecondary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'No user profile found',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spacingXl),
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error.withValues(alpha: 0.5),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Failed to load goals',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              error,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact goals summary bar for home screen
class CompactGoalsSummaryBar extends ConsumerWidget {
  final VoidCallback? onTap;

  const CompactGoalsSummaryBar({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final userAsync = ref.watch(currentUserProvider);

    return userAsync.when(
      data: (user) {
        if (user == null) return const SizedBox.shrink();

        final calorieTarget = user.calorieTarget ?? homeState.calorieTarget;
        final totalCalories = controller.totalCaloriesConsumed.toDouble();
        final percentage = calorieTarget > 0 ? (totalCalories / calorieTarget) : 0.0;

        return InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: AppColors.background,
              border: Border(
                top: BorderSide(
                  color: AppColors.textSecondary.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                // Progress ring
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: percentage.clamp(0.0, 1.0),
                        strokeWidth: 4,
                        backgroundColor: AppColors.surface,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getProgressColor(percentage),
                        ),
                      ),
                      Text(
                        '${(percentage * 100).round()}%',
                        style: AppTypography.label.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                // Text info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Daily Goals',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Tap to view details',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(
                  Icons.keyboard_arrow_up,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, _) => const SizedBox.shrink(),
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage > 1.0) {
      return AppColors.progressRed;
    } else if (percentage >= 0.8) {
      return AppColors.progressYellow;
    } else {
      return AppColors.progressGreen;
    }
  }
}
