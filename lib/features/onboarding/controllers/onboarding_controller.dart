import 'package:flutter_riverpod/flutter_riverpod.dart';

/// State class for onboarding flow
/// Based on otto-spec.md lines 223-286
class OnboardingState {
  /// Current page index (0-6 for 7 screens)
  final int currentPage;

  /// User's name from name screen
  final String? name;

  /// User's age in years
  final int? age;

  /// User's gender: 'male', 'female', or 'other'
  final String? gender;

  /// User's weight in kilograms (always stored in metric)
  final double? weightKg;

  /// User's height in centimeters (always stored in metric)
  final double? heightCm;

  /// Whether to display metric units (true) or imperial (false)
  final bool useMetric;

  /// Activity level: 'sedentary', 'light', 'moderate', 'active', 'very_active'
  final String? activityLevel;

  /// Goal: 'lose', 'maintain', 'gain'
  final String? goal;

  /// Whether TDEE calculation is in progress
  final bool isCalculating;

  /// Calculated results including TDEE, calorie target, and macros
  final Map<String, dynamic>? calculatedResults;

  const OnboardingState({
    this.currentPage = 0,
    this.name,
    this.age,
    this.gender,
    this.weightKg,
    this.heightCm,
    this.useMetric = true,
    this.activityLevel,
    this.goal,
    this.isCalculating = false,
    this.calculatedResults,
  });

  OnboardingState copyWith({
    int? currentPage,
    String? name,
    int? age,
    String? gender,
    double? weightKg,
    double? heightCm,
    bool? useMetric,
    String? activityLevel,
    String? goal,
    bool? isCalculating,
    Map<String, dynamic>? calculatedResults,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      useMetric: useMetric ?? this.useMetric,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      isCalculating: isCalculating ?? this.isCalculating,
      calculatedResults: calculatedResults ?? this.calculatedResults,
    );
  }
}

/// Controller for managing onboarding flow state and validation
class OnboardingController extends Notifier<OnboardingState> {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  /// Move to the next page
  void nextPage() {
    if (state.currentPage < 6) {
      state = state.copyWith(currentPage: state.currentPage + 1);
    }
  }

  /// Move to the previous page
  void previousPage() {
    if (state.currentPage > 0) {
      state = state.copyWith(currentPage: state.currentPage - 1);
    }
  }

  /// Set user's name
  void setName(String name) {
    state = state.copyWith(name: name.trim());
  }

  /// Set user's age
  void setAge(int age) {
    state = state.copyWith(age: age);
  }

  /// Set user's gender
  void setGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  /// Set user's weight in kilograms
  void setWeight(double weight) {
    state = state.copyWith(weightKg: weight);
  }

  /// Set user's height in centimeters
  void setHeight(double height) {
    state = state.copyWith(heightCm: height);
  }

  /// Toggle between metric and imperial units
  void toggleMetric() {
    state = state.copyWith(useMetric: !state.useMetric);
  }

  /// Set user's activity level
  void setActivityLevel(String level) {
    state = state.copyWith(activityLevel: level);
  }

  /// Set user's goal
  void setGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  /// Calculate TDEE, calorie target, and macros based on user inputs
  /// Based on otto-spec.md lines 777-840
  Future<void> calculateAndSave() async {
    state = state.copyWith(isCalculating: true);

    try {
      // Simulate async calculation (replace with actual Supabase save later)
      await Future.delayed(const Duration(milliseconds: 500));

      final bmr = _calculateBMR(
        state.weightKg!,
        state.heightCm!,
        state.age!,
        state.gender!,
      );

      final tdee = _calculateTDEE(bmr, state.activityLevel!);
      final calorieTarget = _calculateCalorieTarget(tdee, state.goal!);
      final macros = _calculateMacros(calorieTarget, state.goal!);

      final results = {
        'bmr': bmr.round(),
        'tdee': tdee.round(),
        'calorie_target': calorieTarget,
        'protein_g': macros['protein_g'],
        'carbs_g': macros['carbs_g'],
        'fat_g': macros['fat_g'],
      };

      state = state.copyWith(
        isCalculating: false,
        calculatedResults: results,
      );
    } catch (e) {
      state = state.copyWith(isCalculating: false);
      rethrow;
    }
  }

  /// Mifflin-St Jeor Equation for BMR calculation
  double _calculateBMR(double weightKg, double heightCm, int age, String gender) {
    if (gender == 'male') {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else {
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    }
  }

  /// Calculate Total Daily Energy Expenditure
  double _calculateTDEE(double bmr, String activityLevel) {
    final multipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };
    return bmr * (multipliers[activityLevel] ?? 1.2);
  }

  /// Calculate daily calorie target based on goal
  int _calculateCalorieTarget(double tdee, String goal) {
    switch (goal) {
      case 'lose':
        return (tdee - 500).round(); // 500 cal deficit
      case 'gain':
        return (tdee + 300).round(); // 300 cal surplus
      default:
        return tdee.round();
    }
  }

  /// Calculate macro targets based on calories and goal
  Map<String, int> _calculateMacros(int calories, String goal) {
    double proteinPercent, carbPercent, fatPercent;

    switch (goal) {
      case 'lose':
        proteinPercent = 0.35; // Higher protein for muscle retention
        fatPercent = 0.30;
        carbPercent = 0.35;
        break;
      case 'gain':
        proteinPercent = 0.25;
        fatPercent = 0.25;
        carbPercent = 0.50; // More carbs for energy
        break;
      default:
        proteinPercent = 0.30;
        fatPercent = 0.30;
        carbPercent = 0.40;
    }

    return {
      'protein_g': ((calories * proteinPercent) / 4).round(),
      'carbs_g': ((calories * carbPercent) / 4).round(),
      'fat_g': ((calories * fatPercent) / 9).round(),
    };
  }

  /// Validation: Check if user can proceed from current page
  bool get canProceedFromCurrentPage {
    switch (state.currentPage) {
      case 0: // Welcome screen - always can proceed
        return true;
      case 1: // Name screen
        return state.name != null && state.name!.isNotEmpty;
      case 2: // Basic info screen (age + gender)
        return state.age != null && state.gender != null;
      case 3: // Body stats screen (height + weight)
        return state.heightCm != null && state.weightKg != null;
      case 4: // Activity level screen
        return state.activityLevel != null;
      case 5: // Goal screen
        return state.goal != null;
      case 6: // Results screen
        return state.calculatedResults != null;
      default:
        return false;
    }
  }

  /// Convert weight from lbs to kg
  static double lbsToKg(double lbs) {
    return lbs * 0.453592;
  }

  /// Convert weight from kg to lbs
  static double kgToLbs(double kg) {
    return kg * 2.20462;
  }

  /// Convert height from feet/inches to cm
  static double feetInchesToCm(int feet, int inches) {
    return ((feet * 12) + inches) * 2.54;
  }

  /// Convert height from cm to feet/inches
  static Map<String, int> cmToFeetInches(double cm) {
    final totalInches = (cm / 2.54).round();
    return {
      'feet': totalInches ~/ 12,
      'inches': totalInches % 12,
    };
  }
}

/// Provider for onboarding controller
final onboardingControllerProvider =
    NotifierProvider<OnboardingController, OnboardingState>(() {
  return OnboardingController();
});
