class FoodSource {
  final String name;
  final String? url;
  final String? logoUrl;

  const FoodSource({required this.name, this.url, this.logoUrl});

  /// Create a copy with optional field overrides
  FoodSource copyWith({String? name, String? url, String? logoUrl}) {
    return FoodSource(
      name: name ?? this.name,
      url: url ?? this.url,
      logoUrl: logoUrl ?? this.logoUrl,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {'name': name, 'url': url, 'logoUrl': logoUrl};
  }

  /// Create from JSON
  factory FoodSource.fromJson(Map<String, dynamic> json) {
    return FoodSource(
      name: json['name'] as String,
      url: json['url'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }
}

class FoodLog {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime loggedDate;

  // User input
  final String rawInput;

  // AI parsed data
  final String? foodName;
  final int? calories;
  final double? proteinG;
  final double? carbsG;
  final double? fatG;

  // Sources
  final List<FoodSource>? sources;
  final String? aiReasoning;
  final int? confidenceScore;

  // User edits
  final bool isEdited;
  final int? editedCalories;
  final double? editedProteinG;
  final double? editedCarbsG;
  final double? editedFatG;

  // Processing state
  final bool isProcessing;
  final String? errorMessage;

  const FoodLog({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.loggedDate,
    required this.rawInput,
    this.foodName,
    this.calories,
    this.proteinG,
    this.carbsG,
    this.fatG,
    this.sources,
    this.aiReasoning,
    this.confidenceScore,
    this.isEdited = false,
    this.editedCalories,
    this.editedProteinG,
    this.editedCarbsG,
    this.editedFatG,
    this.isProcessing = false,
    this.errorMessage,
  });

  /// Computed getters for actual values (edited or original)
  int get displayCalories => editedCalories ?? calories ?? 0;
  double get displayProtein => editedProteinG ?? proteinG ?? 0.0;
  double get displayCarbs => editedCarbsG ?? carbsG ?? 0.0;
  double get displayFat => editedFatG ?? fatG ?? 0.0;

  /// Create a copy with optional field overrides
  FoodLog copyWith({
    String? id,
    String? userId,
    DateTime? createdAt,
    DateTime? loggedDate,
    String? rawInput,
    String? foodName,
    int? calories,
    double? proteinG,
    double? carbsG,
    double? fatG,
    List<FoodSource>? sources,
    String? aiReasoning,
    int? confidenceScore,
    bool? isEdited,
    int? editedCalories,
    double? editedProteinG,
    double? editedCarbsG,
    double? editedFatG,
    bool? isProcessing,
    String? errorMessage,
  }) {
    return FoodLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      loggedDate: loggedDate ?? this.loggedDate,
      rawInput: rawInput ?? this.rawInput,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      proteinG: proteinG ?? this.proteinG,
      carbsG: carbsG ?? this.carbsG,
      fatG: fatG ?? this.fatG,
      sources: sources ?? this.sources,
      aiReasoning: aiReasoning ?? this.aiReasoning,
      confidenceScore: confidenceScore ?? this.confidenceScore,
      isEdited: isEdited ?? this.isEdited,
      editedCalories: editedCalories ?? this.editedCalories,
      editedProteinG: editedProteinG ?? this.editedProteinG,
      editedCarbsG: editedCarbsG ?? this.editedCarbsG,
      editedFatG: editedFatG ?? this.editedFatG,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'loggedDate': loggedDate.toIso8601String(),
      'rawInput': rawInput,
      'foodName': foodName,
      'calories': calories,
      'proteinG': proteinG,
      'carbsG': carbsG,
      'fatG': fatG,
      'sources': sources?.map((s) => s.toJson()).toList(),
      'aiReasoning': aiReasoning,
      'confidenceScore': confidenceScore,
      'isEdited': isEdited,
      'editedCalories': editedCalories,
      'editedProteinG': editedProteinG,
      'editedCarbsG': editedCarbsG,
      'editedFatG': editedFatG,
      'isProcessing': isProcessing,
      'errorMessage': errorMessage,
    };
  }

  /// Create from JSON
  factory FoodLog.fromJson(Map<String, dynamic> json) {
    return FoodLog(
      id: json['id'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      loggedDate: DateTime.parse(json['loggedDate'] as String),
      rawInput: json['rawInput'] as String,
      foodName: json['foodName'] as String?,
      calories: json['calories'] as int?,
      proteinG: (json['proteinG'] as num?)?.toDouble(),
      carbsG: (json['carbsG'] as num?)?.toDouble(),
      fatG: (json['fatG'] as num?)?.toDouble(),
      sources: (json['sources'] as List<dynamic>?)
          ?.map((s) => FoodSource.fromJson(s as Map<String, dynamic>))
          .toList(),
      aiReasoning: json['aiReasoning'] as String?,
      confidenceScore: json['confidenceScore'] as int?,
      isEdited: json['isEdited'] as bool? ?? false,
      editedCalories: json['editedCalories'] as int?,
      editedProteinG: (json['editedProteinG'] as num?)?.toDouble(),
      editedCarbsG: (json['editedCarbsG'] as num?)?.toDouble(),
      editedFatG: (json['editedFatG'] as num?)?.toDouble(),
      isProcessing: json['isProcessing'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );
  }
}
