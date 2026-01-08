import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:otto/data/models/food_log.dart';
import 'package:otto/data/models/daily_summary.dart';
import 'package:otto/data/models/streak.dart';
import 'package:otto/providers/local_storage_provider.dart';

/// State class for home screen
/// Based on otto-spec.md lines 287-336
class HomeState {
  /// List of food logs for today
  final List<FoodLog> todaysLogs;

  /// Daily summary with totals for today
  final DailySummary? todaysSummary;

  /// User's current streak data
  final Streak? streak;

  /// Whether the screen is loading data
  final bool isLoading;

  /// Error message if something went wrong
  final String? error;

  /// Currently selected date (defaults to today)
  final DateTime selectedDate;

  /// Whether the input field is expanded
  final bool isInputExpanded;

  /// Current text in the input field
  final String inputText;

  /// User's calorie target from profile
  final int calorieTarget;

  const HomeState({
    this.todaysLogs = const [],
    this.todaysSummary,
    this.streak,
    this.isLoading = false,
    this.error,
    DateTime? selectedDate,
    this.isInputExpanded = false,
    this.inputText = '',
    this.calorieTarget = 2000,
  }) : selectedDate = selectedDate ?? const _DefaultDate();

  HomeState copyWith({
    List<FoodLog>? todaysLogs,
    DailySummary? todaysSummary,
    Streak? streak,
    bool? isLoading,
    String? error,
    DateTime? selectedDate,
    bool? isInputExpanded,
    String? inputText,
    int? calorieTarget,
    bool clearError = false,
  }) {
    return HomeState(
      todaysLogs: todaysLogs ?? this.todaysLogs,
      todaysSummary: todaysSummary ?? this.todaysSummary,
      streak: streak ?? this.streak,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      selectedDate: selectedDate ?? this.selectedDate,
      isInputExpanded: isInputExpanded ?? this.isInputExpanded,
      inputText: inputText ?? this.inputText,
      calorieTarget: calorieTarget ?? this.calorieTarget,
    );
  }
}

/// Default date placeholder to avoid late initialization issues
class _DefaultDate implements DateTime {
  const _DefaultDate();

  DateTime get _now => DateTime.now();

  @override
  int get year => _now.year;
  @override
  int get month => _now.month;
  @override
  int get day => _now.day;
  @override
  int get hour => _now.hour;
  @override
  int get minute => _now.minute;
  @override
  int get second => _now.second;
  @override
  int get millisecond => _now.millisecond;
  @override
  int get microsecond => _now.microsecond;
  @override
  int get weekday => _now.weekday;
  @override
  bool get isUtc => _now.isUtc;
  @override
  String get timeZoneName => _now.timeZoneName;
  @override
  Duration get timeZoneOffset => _now.timeZoneOffset;
  @override
  int get millisecondsSinceEpoch => _now.millisecondsSinceEpoch;
  @override
  int get microsecondsSinceEpoch => _now.microsecondsSinceEpoch;

  @override
  DateTime add(Duration duration) => _now.add(duration);
  @override
  DateTime subtract(Duration duration) => _now.subtract(duration);
  @override
  Duration difference(DateTime other) => _now.difference(other);
  @override
  bool isAfter(DateTime other) => _now.isAfter(other);
  @override
  bool isBefore(DateTime other) => _now.isBefore(other);
  @override
  bool isAtSameMomentAs(DateTime other) => _now.isAtSameMomentAs(other);
  @override
  int compareTo(DateTime other) => _now.compareTo(other);
  @override
  String toIso8601String() => _now.toIso8601String();
  @override
  DateTime toLocal() => _now.toLocal();
  @override
  DateTime toUtc() => _now.toUtc();
  @override
  String toString() => _now.toString();
}

/// Controller for managing home screen state
/// Based on otto-spec.md lines 287-336
class HomeController extends Notifier<HomeState> {
  static const _uuid = Uuid();

  @override
  HomeState build() {
    // Load initial data when controller is created
    _loadInitialData();
    return const HomeState(isLoading: true);
  }

  /// Load today's data from storage/API
  Future<void> _loadInitialData() async {
    try {
      // Get user's calorie target from local storage
      final userAsync = ref.read(currentUserProvider);
      int calorieTarget = 2000; // Default

      userAsync.whenData((user) {
        if (user?.calorieTarget != null) {
          calorieTarget = user!.calorieTarget!;
        }
      });

      // TODO: Load actual food logs from storage/Supabase
      // For now, start with empty list
      state = state.copyWith(
        isLoading: false,
        todaysLogs: [],
        calorieTarget: calorieTarget,
        streak: Streak(
          id: _uuid.v4(),
          userId: 'temp-user',
          currentStreak: 0,
          longestStreak: 0,
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load data: $e',
      );
    }
  }

  /// Reload today's data
  Future<void> loadTodaysData() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadInitialData();
  }

  /// Change the selected date (for viewing history)
  void changeDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
    // TODO: Load food logs for the selected date
  }

  /// Toggle input field expansion
  void toggleInput() {
    state = state.copyWith(isInputExpanded: !state.isInputExpanded);
  }

  /// Expand input field
  void expandInput() {
    state = state.copyWith(isInputExpanded: true);
  }

  /// Collapse input field
  void collapseInput() {
    state = state.copyWith(isInputExpanded: false);
  }

  /// Update input text
  void setInputText(String text) {
    state = state.copyWith(inputText: text);
  }

  /// Submit a new food entry
  /// Creates a new FoodLog in processing state, then processes with AI
  Future<void> submitFoodEntry(String rawInput) async {
    if (rawInput.trim().isEmpty) return;

    // Create a new food log entry in processing state
    final newLog = FoodLog(
      id: _uuid.v4(),
      userId: 'temp-user', // TODO: Get from auth
      createdAt: DateTime.now(),
      loggedDate: state.selectedDate,
      rawInput: rawInput.trim(),
      isProcessing: true,
    );

    // Add to list immediately (optimistic update)
    final updatedLogs = [...state.todaysLogs, newLog];
    state = state.copyWith(
      todaysLogs: updatedLogs,
      inputText: '',
      isInputExpanded: false,
    );

    // Process with AI
    await _processWithAI(newLog);
  }

  /// Process a food log entry with AI
  Future<void> _processWithAI(FoodLog log) async {
    try {
      // TODO: Integrate with Gemini + Perplexity API
      // For now, simulate AI processing with a delay
      await Future.delayed(const Duration(seconds: 2));

      // Simulated AI response - replace with actual API call
      final processedLog = log.copyWith(
        isProcessing: false,
        foodName: log.rawInput,
        calories: _estimateCalories(log.rawInput),
        proteinG: 20.0,
        carbsG: 30.0,
        fatG: 15.0,
        confidenceScore: 75,
        aiReasoning: 'I estimated the calories based on typical values for "${log.rawInput}". This is a placeholder until AI integration is complete.',
      );

      // Update the log in the list
      _updateLogInList(processedLog);

      // Update daily summary
      _recalculateDailySummary();

      // Update streak
      _updateStreak();
    } catch (e) {
      // Mark log as errored
      final errorLog = log.copyWith(
        isProcessing: false,
        errorMessage: 'Failed to process: $e',
      );
      _updateLogInList(errorLog);
    }
  }

  /// Update a specific log in the list
  void _updateLogInList(FoodLog updatedLog) {
    final updatedLogs = state.todaysLogs.map((log) {
      return log.id == updatedLog.id ? updatedLog : log;
    }).toList();
    state = state.copyWith(todaysLogs: updatedLogs);
  }

  /// Recalculate daily summary from current logs
  void _recalculateDailySummary() {
    final summary = DailySummary.fromLogs(
      'temp-user', // TODO: Get from auth
      state.selectedDate,
      state.todaysLogs.where((log) => !log.isProcessing && log.errorMessage == null).toList(),
    );
    state = state.copyWith(todaysSummary: summary);
  }

  /// Update streak for today's log
  void _updateStreak() {
    if (state.streak == null) return;

    final updatedStreak = state.streak!.updateForNewLog(DateTime.now());
    state = state.copyWith(streak: updatedStreak);
  }

  /// Delete a food log entry
  Future<void> deleteEntry(String logId) async {
    final updatedLogs = state.todaysLogs.where((log) => log.id != logId).toList();
    state = state.copyWith(todaysLogs: updatedLogs);

    // Recalculate summary
    _recalculateDailySummary();

    // TODO: Delete from storage/Supabase
  }

  /// Retry processing a failed entry
  Future<void> retryEntry(String logId) async {
    final log = state.todaysLogs.firstWhere(
      (log) => log.id == logId,
      orElse: () => throw Exception('Log not found'),
    );

    if (log.errorMessage == null) return;

    // Reset to processing state
    final retryLog = log.copyWith(
      isProcessing: true,
      errorMessage: null,
    );
    _updateLogInList(retryLog);

    // Re-process
    await _processWithAI(retryLog);
  }

  /// Clear any error messages
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  /// Simple calorie estimation (placeholder until AI integration)
  int _estimateCalories(String input) {
    // Very rough estimation based on common foods
    final lowerInput = input.toLowerCase();

    if (lowerInput.contains('salad')) return 150;
    if (lowerInput.contains('burger')) return 550;
    if (lowerInput.contains('pizza')) return 285;
    if (lowerInput.contains('chicken')) return 335;
    if (lowerInput.contains('rice')) return 200;
    if (lowerInput.contains('pasta')) return 400;
    if (lowerInput.contains('sandwich')) return 350;
    if (lowerInput.contains('coffee')) return 5;
    if (lowerInput.contains('smoothie')) return 250;
    if (lowerInput.contains('egg')) return 155;

    // Default estimate
    return 300;
  }

  // ===== Computed Getters =====

  /// Total calories consumed today
  int get totalCaloriesConsumed {
    return state.todaysLogs
        .where((log) => !log.isProcessing && log.errorMessage == null)
        .fold(0, (sum, log) => sum + log.displayCalories);
  }

  /// Remaining calories for today
  int get remainingCalories {
    return state.calorieTarget - totalCaloriesConsumed;
  }

  /// Whether there are any food logs today
  bool get hasFoodLogs => state.todaysLogs.isNotEmpty;

  /// Current streak count
  int get currentStreak => state.streak?.currentStreak ?? 0;
}

/// Provider for home controller
final homeControllerProvider =
    NotifierProvider<HomeController, HomeState>(() {
  return HomeController();
});

/// Provider for remaining calories (derived from home state)
final remainingCaloriesProvider = Provider<int>((ref) {
  // Watch the state to trigger rebuilds when it changes
  ref.watch(homeControllerProvider);
  final controller = ref.read(homeControllerProvider.notifier);
  return controller.remainingCalories;
});

/// Provider for total calories consumed (derived from home state)
final totalCaloriesProvider = Provider<int>((ref) {
  // Watch the state to trigger rebuilds when it changes
  ref.watch(homeControllerProvider);
  final controller = ref.read(homeControllerProvider.notifier);
  return controller.totalCaloriesConsumed;
});

/// Provider for current streak count
final currentStreakProvider = Provider<int>((ref) {
  final homeState = ref.watch(homeControllerProvider);
  return homeState.streak?.currentStreak ?? 0;
});
