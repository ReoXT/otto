import 'package:uuid/uuid.dart';
import 'food_log.dart';

class DailySummary {
  final String id;
  final String userId;
  final DateTime summaryDate;

  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final int entriesCount;

  const DailySummary({
    required this.id,
    required this.userId,
    required this.summaryDate,
    this.totalCalories = 0,
    this.totalProteinG = 0.0,
    this.totalCarbsG = 0.0,
    this.totalFatG = 0.0,
    this.entriesCount = 0,
  });

  /// Create a copy with optional field overrides
  DailySummary copyWith({
    String? id,
    String? userId,
    DateTime? summaryDate,
    int? totalCalories,
    double? totalProteinG,
    double? totalCarbsG,
    double? totalFatG,
    int? entriesCount,
  }) {
    return DailySummary(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      summaryDate: summaryDate ?? this.summaryDate,
      totalCalories: totalCalories ?? this.totalCalories,
      totalProteinG: totalProteinG ?? this.totalProteinG,
      totalCarbsG: totalCarbsG ?? this.totalCarbsG,
      totalFatG: totalFatG ?? this.totalFatG,
      entriesCount: entriesCount ?? this.entriesCount,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'summaryDate': summaryDate.toIso8601String(),
      'totalCalories': totalCalories,
      'totalProteinG': totalProteinG,
      'totalCarbsG': totalCarbsG,
      'totalFatG': totalFatG,
      'entriesCount': entriesCount,
    };
  }

  /// Create from JSON
  factory DailySummary.fromJson(Map<String, dynamic> json) {
    return DailySummary(
      id: json['id'] as String,
      userId: json['userId'] as String,
      summaryDate: DateTime.parse(json['summaryDate'] as String),
      totalCalories: json['totalCalories'] as int? ?? 0,
      totalProteinG: (json['totalProteinG'] as num?)?.toDouble() ?? 0.0,
      totalCarbsG: (json['totalCarbsG'] as num?)?.toDouble() ?? 0.0,
      totalFatG: (json['totalFatG'] as num?)?.toDouble() ?? 0.0,
      entriesCount: json['entriesCount'] as int? ?? 0,
    );
  }

  /// Factory to create from list of FoodLogs
  factory DailySummary.fromLogs(
    String userId,
    DateTime date,
    List<FoodLog> logs,
  ) {
    int totalCals = 0;
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;

    for (final log in logs) {
      totalCals += log.displayCalories;
      totalProtein += log.displayProtein;
      totalCarbs += log.displayCarbs;
      totalFat += log.displayFat;
    }

    return DailySummary(
      id: const Uuid().v4(),
      userId: userId,
      summaryDate: date,
      totalCalories: totalCals,
      totalProteinG: totalProtein,
      totalCarbsG: totalCarbs,
      totalFatG: totalFat,
      entriesCount: logs.length,
    );
  }
}
