import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/data/models/food_log.dart';
import 'package:otto/features/home/controllers/home_controller.dart';
import 'package:otto/features/home/widgets/home_app_bar.dart';
import 'package:otto/features/home/widgets/calorie_input_bar.dart';
import 'package:otto/features/home/widgets/empty_state.dart';
import 'package:otto/features/home/widgets/food_entry_list.dart';
import 'package:otto/features/home/widgets/goals_summary_sheet.dart';
import 'package:otto/features/food_detail/screens/food_detail_sheet.dart';

/// Home screen - Main interface per otto-spec.md lines 287-336
///
/// Layout:
/// - Custom AppBar with Otto icon, "Today" button, streak, settings
/// - Body: Empty state or food logs list
/// - Bottom: Calorie input bar
///
/// Features:
/// - Clean, uncluttered interface
/// - Warm cream background (#FFF9F5)
/// - Natural language food input
/// - Real-time calorie tracking
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Sync text controller with state
    _inputController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _inputController.removeListener(_onInputChanged);
    _inputController.dispose();
    super.dispose();
  }

  void _onInputChanged() {
    ref.read(homeControllerProvider.notifier).setInputText(_inputController.text);
  }

  void _handleOttoIconTap() {
    // TODO: Navigate to profile screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile coming soon!')),
    );
  }

  void _handleTodayTap() {
    // TODO: Show date picker for history
    _showDatePicker();
  }

  Future<void> _showDatePicker() async {
    final homeState = ref.read(homeControllerProvider);
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: homeState.selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      ref.read(homeControllerProvider.notifier).changeDate(selectedDate);
    }
  }

  void _handleSettings() {
    // TODO: Navigate to settings screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings coming soon!')),
    );
  }

  void _handleVoiceInput() {
    // TODO: Implement voice input
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Voice input coming soon!')),
    );
  }

  void _handleQuickAdd() {
    // TODO: Navigate to quick add screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick add coming soon!')),
    );
  }

  void _handleSubmit() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;

    // Submit to controller
    ref.read(homeControllerProvider.notifier).submitFoodEntry(text);
    _inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Watch home state for reactive updates
    final homeState = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);

    // Get computed values
    final remainingCalories = controller.remainingCalories;
    final streakCount = controller.currentStreak;
    final hasFoodLogs = controller.hasFoodLogs;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeAppBar(
        onOttoIconTap: _handleOttoIconTap,
        onTodayTap: _handleTodayTap,
        onSettingsTap: _handleSettings,
        streakCount: streakCount,
      ),
      body: Column(
        children: [
          // Loading indicator
          if (homeState.isLoading)
            const LinearProgressIndicator(
              backgroundColor: Colors.transparent,
              color: AppColors.primary,
            ),

          // Error banner
          if (homeState.error != null)
            _buildErrorBanner(homeState.error!),

          // Food logs list or empty state
          Expanded(
            child: homeState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  )
                : hasFoodLogs
                    ? FoodEntryList(
                        logs: homeState.todaysLogs,
                        onLogTap: _handleLogTap,
                        onLogDelete: _handleLogDelete,
                      )
                    : const EmptyFoodLogState(),
          ),

          // Compact goals summary bar
          CompactGoalsSummaryBar(
            onTap: () => GoalsSummarySheet.show(context),
          ),

          // Bottom input bar
          CalorieInputBar(
            caloriesLeft: remainingCalories,
            onVoicePressed: _handleVoiceInput,
            onQuickAddPressed: _handleQuickAdd,
            onSubmit: _handleSubmit,
            controller: _inputController,
          ),
        ],
      ),
    );
  }

  /// Build error banner widget
  Widget _buildErrorBanner(String error) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingM,
        vertical: AppDimensions.spacingS,
      ),
      color: AppColors.error.withValues(alpha: 0.1),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: AppColors.error,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 20),
            color: AppColors.error,
            onPressed: () {
              ref.read(homeControllerProvider.notifier).clearError();
            },
          ),
        ],
      ),
    );
  }

  /// Handle tapping on a food log entry
  void _handleLogTap(FoodLog foodLog) {
    // Check if it's an error state - retry
    if (foodLog.errorMessage != null) {
      ref.read(homeControllerProvider.notifier).retryEntry(foodLog.id);
      return;
    }

    // Show food detail bottom sheet
    FoodDetailSheet.show(
      context,
      foodLog: foodLog,
      onEdit: () => _handleEditEntry(foodLog),
      onDelete: () => _handleLogDelete(foodLog),
    );
  }

  /// Handle editing a food log entry
  void _handleEditEntry(FoodLog foodLog) {
    // TODO: Show edit dialog/sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Handle deleting a food log entry
  void _handleLogDelete(FoodLog foodLog) {
    ref.read(homeControllerProvider.notifier).deleteEntry(foodLog.id);
  }
}
