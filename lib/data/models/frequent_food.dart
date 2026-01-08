class FrequentFood {
  final String id;
  final String userId;
  final String foodName;

  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  final int useCount;
  final DateTime lastUsedAt;

  const FrequentFood({
    required this.id,
    required this.userId,
    required this.foodName,
    this.calories = 0,
    this.proteinG = 0.0,
    this.carbsG = 0.0,
    this.fatG = 0.0,
    this.useCount = 1,
    required this.lastUsedAt,
  });

  /// Create a copy with optional field overrides
  FrequentFood copyWith({
    String? id,
    String? userId,
    String? foodName,
    int? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    int? useCount,
    DateTime? lastUsedAt,
  }) {
    return FrequentFood(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      useCount: useCount ?? this.useCount,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'foodName': foodName,
      'calories': calories,
      'proteinG': proteinG,
      'carbsG': carbsG,
      'fatG': fatG,
      'useCount': useCount,
      'lastUsedAt': lastUsedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory FrequentFood.fromJson(Map<String, dynamic> json) {
    return FrequentFood(
      id: json['id'] as String,
      userId: json['userId'] as String,
      foodName: json['foodName'] as String,
      calories: json['calories'] as int? ?? 0,
      proteinG: (json['proteinG'] as num?)?.toDouble() ?? 0.0,
      carbsG: (json['carbsG'] as num?)?.toDouble() ?? 0.0,
      fatG: (json['fatG'] as num?)?.toDouble() ?? 0.0,
      useCount: json['useCount'] as int? ?? 1,
      lastUsedAt: DateTime.parse(json['lastUsedAt'] as String),
    );
  }

  /// Increment use count and update last used time
  FrequentFood incrementUse() {
    return copyWith(useCount: useCount + 1, lastUsedAt: DateTime.now());
  }
}
