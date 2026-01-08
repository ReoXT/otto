/// TDEE Calculator using Mifflin-St Jeor equation
/// Calculates BMR (Basal Metabolic Rate), TDEE (Total Daily Energy Expenditure),
/// calorie targets, and macro nutrient recommendations.
library;

import 'dart:math';

class TDEECalculator {
  /// Calculate Basal Metabolic Rate (BMR) using Mifflin-St Jeor equation
  ///
  /// Parameters:
  /// - [weightKg]: Body weight in kilograms
  /// - [heightCm]: Height in centimeters
  /// - [age]: Age in years
  /// - [gender]: 'male', 'female', or 'other' (averages male/female)
  ///
  /// Returns: BMR in calories per day
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
  }) {
    final genderLower = gender.toLowerCase();

    if (genderLower == 'male') {
      // BMR = (10 × weight) + (6.25 × height) − (5 × age) + 5
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
    } else if (genderLower == 'female') {
      // BMR = (10 × weight) + (6.25 × height) − (5 × age) − 161
      return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
    } else {
      // For 'other', use average of male and female formulas
      final maleBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
      final femaleBMR = (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
      return (maleBMR + femaleBMR) / 2;
    }
  }

  /// Calculate Total Daily Energy Expenditure (TDEE) from BMR and activity level
  ///
  /// Parameters:
  /// - [bmr]: Basal Metabolic Rate (from calculateBMR)
  /// - [activityLevel]: One of 'sedentary', 'light', 'moderate', 'active', 'very_active'
  ///
  /// Activity multipliers:
  /// - sedentary (1.2): Little or no exercise
  /// - light (1.375): Light exercise 1-3 days/week
  /// - moderate (1.55): Moderate exercise 3-5 days/week
  /// - active (1.725): Hard exercise 6-7 days/week
  /// - very_active (1.9): Athlete or physical job
  ///
  /// Returns: TDEE in calories per day
  static double calculateTDEE({
    required double bmr,
    required String activityLevel,
  }) {
    const activityMultipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };

    final multiplier = activityMultipliers[activityLevel.toLowerCase()] ?? 1.2;
    return bmr * multiplier;
  }

  /// Calculate daily calorie target based on goal
  ///
  /// Parameters:
  /// - [tdee]: Total Daily Energy Expenditure
  /// - [goal]: One of 'lose', 'maintain', 'gain'
  ///
  /// Adjustments:
  /// - lose: TDEE - 500 (500 cal deficit for ~0.5 kg/lb per week loss)
  /// - maintain: TDEE (no change)
  /// - gain: TDEE + 300 (300 cal surplus for lean muscle gain)
  ///
  /// Returns: Daily calorie target as integer
  static int calculateCalorieTarget({
    required double tdee,
    required String goal,
  }) {
    final goalLower = goal.toLowerCase();

    switch (goalLower) {
      case 'lose':
        return (tdee - 500).round();
      case 'gain':
        return (tdee + 300).round();
      case 'maintain':
      default:
        return tdee.round();
    }
  }

  /// Calculate macro nutrient targets (protein, carbs, fat) based on calorie goal and objective
  ///
  /// Parameters:
  /// - [calories]: Daily calorie target
  /// - [goal]: One of 'lose', 'maintain', 'gain'
  ///
  /// Macros are calculated as percentages of total calories:
  /// - Protein: 4 kcal/gram
  /// - Carbs: 4 kcal/gram
  /// - Fat: 9 kcal/gram
  ///
  /// For weight loss: Higher protein to preserve muscle
  /// For maintenance: Balanced macros
  /// For weight gain: Higher carbs for energy and performance
  ///
  /// Returns: Map with keys 'protein_g', 'carbs_g', 'fat_g'
  static Map<String, int> calculateMacros({
    required int calories,
    required String goal,
  }) {
    final goalLower = goal.toLowerCase();

    double proteinPercent = 0.30;
    double carbPercent = 0.40;
    double fatPercent = 0.30;

    switch (goalLower) {
      case 'lose':
        // Higher protein for muscle retention during deficit
        proteinPercent = 0.35;
        carbPercent = 0.35;
        fatPercent = 0.30;
        break;
      case 'gain':
        // More carbs for energy and performance
        proteinPercent = 0.25;
        carbPercent = 0.50;
        fatPercent = 0.25;
        break;
      case 'maintain':
      default:
        // Balanced approach
        proteinPercent = 0.30;
        carbPercent = 0.40;
        fatPercent = 0.30;
        break;
    }

    return {
      'protein_g': ((calories * proteinPercent) / 4).round(),
      'carbs_g': ((calories * carbPercent) / 4).round(),
      'fat_g': ((calories * fatPercent) / 9).round(),
    };
  }

  /// All-in-one calculation method
  ///
  /// Combines all calculations into a single call
  /// Returns a map with all calculated values
  ///
  /// Returns:
  /// {
  ///   'bmr': double,
  ///   'tdee': double,
  ///   'calorieTarget': int,
  ///   'proteinTargetG': int,
  ///   'carbsTargetG': int,
  ///   'fatTargetG': int,
  /// }
  static Map<String, dynamic> calculateAll({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  }) {
    final bmr = calculateBMR(
      weightKg: weightKg,
      heightCm: heightCm,
      age: age,
      gender: gender,
    );

    final tdee = calculateTDEE(bmr: bmr, activityLevel: activityLevel);

    final calorieTarget = calculateCalorieTarget(tdee: tdee, goal: goal);

    final macros = calculateMacros(calories: calorieTarget, goal: goal);

    return {
      'bmr': bmr.roundToPlaces(2),
      'tdee': tdee.roundToPlaces(2),
      'calorieTarget': calorieTarget,
      'proteinTargetG': macros['protein_g'],
      'carbsTargetG': macros['carbs_g'],
      'fatTargetG': macros['fat_g'],
    };
  }
}

/// Helper extension to round doubles to specific decimal places

extension DoubleRounding on double {
  double roundToPlaces(int places) {
    final factor = pow(10, places).toDouble();
    return (this * factor).round() / factor;
  }
}
