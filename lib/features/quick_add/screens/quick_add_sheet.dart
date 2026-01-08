import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/features/quick_add/controllers/quick_add_controller.dart';
import 'package:otto/features/quick_add/widgets/quick_add_tile.dart';

/// Quick Add modal bottom sheet for adding frequent foods
///
/// Based on otto-spec.md lines 404-423
/// Features:
/// - Search input field for filtering foods
/// - "Recent" section with last 10 unique foods
/// - "Most Used" section with foods by useCount
/// - Tap to instantly add to today's log
class QuickAddSheet extends ConsumerStatefulWidget {
  const QuickAddSheet({super.key});

  /// Show the Quick Add sheet as a modal
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickAddSheet(),
    );
  }

  @override
  ConsumerState<QuickAddSheet> createState() => _QuickAddSheetState();
}

class _QuickAddSheetState extends ConsumerState<QuickAddSheet> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Load data when sheet opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quickAddControllerProvider.notifier).loadFoods();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quickAddControllerProvider);
    final controller = ref.read(quickAddControllerProvider.notifier);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimensions.radiusXl),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingM,
                ),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quick Add',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        color: AppColors.textSecondary,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppDimensions.spacingM),

              // Search input
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                ),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: '🔍 Search your foods...',
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingM,
                      vertical: AppDimensions.spacingM,
                    ),
                  ),
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                  onChanged: (value) {
                    controller.setSearchQuery(value);
                  },
                ),
              ),

              const SizedBox(height: AppDimensions.spacingL),

              // Content (scrollable)
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : state.error != null
                        ? _buildErrorState(state.error!)
                        : _buildContent(scrollController, state, controller),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build error state
  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'Failed to load foods',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
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

  /// Build main content with recent and most used foods
  Widget _buildContent(
    ScrollController scrollController,
    QuickAddState state,
    QuickAddController controller,
  ) {
    final recentFoods = state.filteredRecentFoods;
    final mostUsedFoods = state.filteredMostUsedFoods;

    // Show empty state if no foods at all
    if (recentFoods.isEmpty && mostUsedFoods.isEmpty && state.searchQuery.isEmpty) {
      return _buildEmptyState();
    }

    // Show "no results" if searching with no matches
    if (recentFoods.isEmpty && mostUsedFoods.isEmpty && state.searchQuery.isNotEmpty) {
      return _buildNoResultsState(state.searchQuery);
    }

    return ListView(
      controller: scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingL,
      ),
      children: [
        // Recent section
        if (recentFoods.isNotEmpty) ...[
          Text(
            'Recent',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          ...recentFoods.map((food) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
                child: QuickAddTile(
                  food: food,
                  onTap: () => _handleFoodTap(food.foodName),
                ),
              )),
          const SizedBox(height: AppDimensions.spacingL),
        ],

        // Most Used section
        if (mostUsedFoods.isNotEmpty) ...[
          Text(
            'Most Used',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          ...mostUsedFoods.map((food) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimensions.spacingS),
                child: QuickAddTile(
                  food: food,
                  onTap: () => _handleFoodTap(food.foodName),
                ),
              )),
          const SizedBox(height: AppDimensions.spacingXl),
        ],
      ],
    );
  }

  /// Build empty state when no foods have been logged yet
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '📝',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'No foods yet',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Your frequent foods will appear here after you start logging meals',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Build no results state when search returns nothing
  Widget _buildNoResultsState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '🔍',
              style: TextStyle(fontSize: 64),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'No results found',
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Try a different search term',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Handle food tap - add to log and close sheet
  Future<void> _handleFoodTap(String foodName) async {
    final controller = ref.read(quickAddControllerProvider.notifier);

    // Add to log
    await controller.addFoodToLog(foodName);

    // Close the sheet
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}
