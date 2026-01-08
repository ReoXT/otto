class Streak {
  final String id;
  final String userId;

  final int currentStreak;
  final int longestStreak;
  final DateTime? lastLogDate;

  const Streak({
    required this.id,
    required this.userId,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastLogDate,
  });

  /// Create a copy with optional field overrides
  Streak copyWith({
    String? id,
    String? userId,
    int? currentStreak,
    int? longestStreak,
    DateTime? lastLogDate,
  }) {
    return Streak(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      lastLogDate: lastLogDate ?? this.lastLogDate,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastLogDate': lastLogDate?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      id: json['id'] as String,
      userId: json['userId'] as String,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastLogDate: json['lastLogDate'] != null
          ? DateTime.parse(json['lastLogDate'] as String)
          : null,
    );
  }

  /// Update streak for a new log entry
  /// Returns updated Streak with incremented or reset streak
  Streak updateForNewLog(DateTime logDate) {
    if (lastLogDate == null) {
      // First log ever
      return copyWith(currentStreak: 1, longestStreak: 1, lastLogDate: logDate);
    }

    final lastDate = lastLogDate!;
    final lastDateOnly = DateTime(lastDate.year, lastDate.month, lastDate.day);
    final logDateOnly = DateTime(logDate.year, logDate.month, logDate.day);

    // Calculate days difference
    final daysDifference = logDateOnly.difference(lastDateOnly).inDays;

    int newCurrentStreak = currentStreak;
    int newLongestStreak = longestStreak;

    if (daysDifference == 1) {
      // Consecutive day - increment streak
      newCurrentStreak = currentStreak + 1;
      newLongestStreak = (currentStreak + 1) > longestStreak
          ? (currentStreak + 1)
          : longestStreak;
    } else if (daysDifference == 0) {
      // Same day - no change
      newCurrentStreak = currentStreak;
      newLongestStreak = longestStreak;
    } else if (daysDifference > 1) {
      // Streak broken - reset and start new
      newCurrentStreak = 1;
      newLongestStreak = longestStreak; // Keep longest
    }
    // daysDifference < 0 shouldn't happen in normal usage

    return copyWith(
      currentStreak: newCurrentStreak,
      longestStreak: newLongestStreak,
      lastLogDate: logDate,
    );
  }

  /// Reset streak (e.g., when user misses a day)
  Streak reset() {
    return copyWith(currentStreak: 0, lastLogDate: null);
  }
}
