import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:otto/data/models/frequent_food.dart';
import 'package:otto/features/home/controllers/home_controller.dart';
import 'package:otto/providers/local_storage_provider.dart';

/// State class for Quick Add feature
/// Based on otto-spec.md lines 404-423
class QuickAddState {
  /// Recent foods (last 10 unique foods logged)
  final List<FrequentFood> recentFoods;

  /// Most used foods (sorted by useCount)
  final List<FrequentFood> mostUsedFoods;

  /// Current search query
  final String searchQuery;

  /// Whether the data is loading
  final bool isLoading;

  /// Error message if something went wrong
  final String? error;

  const QuickAddState({
    this.recentFoods = const [],
    this.mostUsedFoods = const [],
    this.searchQuery = '',
    this.isLoading = false,
    this.error,
  });

  /// Filtered recent foods based on search query
  List<FrequentFood> get filteredRecentFoods {
    if (searchQuery.isEmpty) return recentFoods;

    final lowerQuery = searchQuery.toLowerCase();
    return recentFoods
        .where((food) => food.foodName.toLowerCase().contains(lowerQuery))
        .toList();
  }

  /// Filtered most used foods based on search query
  List<FrequentFood> get filteredMostUsedFoods {
    if (searchQuery.isEmpty) return mostUsedFoods;

    final lowerQuery = searchQuery.toLowerCase();
    return mostUsedFoods
        .where((food) => food.foodName.toLowerCase().contains(lowerQuery))
        .toList();
  }

  QuickAddState copyWith({
    List<FrequentFood>? recentFoods,
    List<FrequentFood>? mostUsedFoods,
    String? searchQuery,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return QuickAddState(
      recentFoods: recentFoods ?? this.recentFoods,
      mostUsedFoods: mostUsedFoods ?? this.mostUsedFoods,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Controller for managing Quick Add feature
/// Handles loading frequent foods, searching, and adding to log
class QuickAddController extends Notifier<QuickAddState> {
  static const _uuid = Uuid();
  static const String _frequentFoodsKey = 'frequent_foods';
  static const int _maxRecentFoods = 10;
  static const int _maxMostUsedFoods = 10;

  @override
  QuickAddState build() {
    return const QuickAddState();
  }

  /// Load foods from local storage
  /// In production, this would load from Supabase
  Future<void> loadFoods() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final storage = ref.read(localStorageServiceProvider);

      // Load frequent foods from storage
      final storedFoodsJson =
          await storage.getValue<List<dynamic>>(_frequentFoodsKey);

      if (storedFoodsJson == null || storedFoodsJson.isEmpty) {
        // No foods yet
        state = state.copyWith(
          isLoading: false,
          recentFoods: [],
          mostUsedFoods: [],
        );
        return;
      }

      // Parse stored foods
      final allFoods = storedFoodsJson
          .map((json) => FrequentFood.fromJson(json as Map<String, dynamic>))
          .toList();

      // Get recent foods (last 10 unique, sorted by lastUsedAt)
      final recentFoods = allFoods
          .toList()
        ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
      final recent = recentFoods.take(_maxRecentFoods).toList();

      // Get most used foods (sorted by useCount)
      final mostUsedFoods = allFoods.toList()
        ..sort((a, b) => b.useCount.compareTo(a.useCount));
      final mostUsed = mostUsedFoods.take(_maxMostUsedFoods).toList();

      state = state.copyWith(
        isLoading: false,
        recentFoods: recent,
        mostUsedFoods: mostUsed,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load foods: $e',
      );
    }
  }

  /// Update search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  /// Add a food to today's log
  /// This method:
  /// 1. Calls HomeController to add the food entry
  /// 2. Updates the frequent foods list (increment use count)
  /// 3. Saves to local storage
  Future<void> addFoodToLog(String foodName) async {
    try {
      // Get the home controller to add the food to today's log
      final homeController = ref.read(homeControllerProvider.notifier);
      await homeController.submitFoodEntry(foodName);

      // Update frequent foods list
      await _updateFrequentFood(foodName);

      // Reload foods to reflect the updated use count
      await loadFoods();
    } catch (e) {
      // Error handling - the HomeController will show any processing errors
      // We don't need to show an error here
    }
  }

  /// Update or create a frequent food entry
  /// Increments use count and updates lastUsedAt
  Future<void> _updateFrequentFood(String foodName) async {
    try {
      final storage = ref.read(localStorageServiceProvider);

      // Load current frequent foods
      final storedFoodsJson =
          await storage.getValue<List<dynamic>>(_frequentFoodsKey);

      List<FrequentFood> frequentFoods = [];
      if (storedFoodsJson != null) {
        frequentFoods = storedFoodsJson
            .map((json) => FrequentFood.fromJson(json as Map<String, dynamic>))
            .toList();
      }

      // Find existing food or create new one
      final existingIndex =
          frequentFoods.indexWhere((f) => f.foodName == foodName);

      if (existingIndex != -1) {
        // Update existing food - increment use count and update timestamp
        final updated = frequentFoods[existingIndex].incrementUse();
        frequentFoods[existingIndex] = updated;
      } else {
        // Create new frequent food entry
        // Note: Calories and macros will be updated when AI processes the food
        final newFood = FrequentFood(
          id: _uuid.v4(),
          userId: 'temp-user', // TODO: Get from auth
          foodName: foodName,
          calories: 0, // Will be updated after AI processing
          proteinG: 0.0,
          carbsG: 0.0,
          fatG: 0.0,
          useCount: 1,
          lastUsedAt: DateTime.now(),
        );
        frequentFoods.add(newFood);
      }

      // Save back to storage
      final foodsJson = frequentFoods.map((f) => f.toJson()).toList();
      await storage.setValue(_frequentFoodsKey, foodsJson);
    } catch (e) {
      // Silently fail - this is a nice-to-have feature
      // The food will still be added to the log
    }
  }

  /// Update a frequent food's nutrition data after AI processing
  /// This should be called after the AI has processed a food entry
  /// to update the stored calories and macros
  Future<void> updateFoodNutrition(
    String foodName, {
    required int calories,
    required double proteinG,
    required double carbsG,
    required double fatG,
  }) async {
    try {
      final storage = ref.read(localStorageServiceProvider);

      // Load current frequent foods
      final storedFoodsJson =
          await storage.getValue<List<dynamic>>(_frequentFoodsKey);

      if (storedFoodsJson == null) return;

      List<FrequentFood> frequentFoods = storedFoodsJson
          .map((json) => FrequentFood.fromJson(json as Map<String, dynamic>))
          .toList();

      // Find the food and update its nutrition data
      final existingIndex =
          frequentFoods.indexWhere((f) => f.foodName == foodName);

      if (existingIndex != -1) {
        final updated = frequentFoods[existingIndex].copyWith(
          calories: calories,
          proteinG: proteinG,
          carbsG: carbsG,
          fatG: fatG,
        );
        frequentFoods[existingIndex] = updated;

        // Save back to storage
        final foodsJson = frequentFoods.map((f) => f.toJson()).toList();
        await storage.setValue(_frequentFoodsKey, foodsJson);
      }
    } catch (e) {
      // Silently fail
    }
  }

  /// Clear all frequent foods (useful for testing or reset)
  Future<void> clearFrequentFoods() async {
    try {
      final storage = ref.read(localStorageServiceProvider);
      await storage.deleteValue(_frequentFoodsKey);
      state = state.copyWith(
        recentFoods: [],
        mostUsedFoods: [],
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to clear foods: $e');
    }
  }
}

/// Provider for Quick Add controller
final quickAddControllerProvider =
    NotifierProvider<QuickAddController, QuickAddState>(() {
  return QuickAddController();
});
