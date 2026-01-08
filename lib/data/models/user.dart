import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? deviceId;

  @HiveField(2)
  DateTime createdAt;

  // Profile data (from onboarding)
  @HiveField(3)
  String? name;

  @HiveField(4)
  int? age;

  @HiveField(5)
  double? weightKg;

  @HiveField(6)
  double? heightCm;

  @HiveField(7)
  String? gender; // 'male', 'female', 'other'

  @HiveField(8)
  String? activityLevel; // 'sedentary', 'light', 'moderate', 'active', 'very_active'

  @HiveField(9)
  String? goal; // 'lose', 'maintain', 'gain'

  // Calculated values
  @HiveField(10)
  int? tdee; // Total Daily Energy Expenditure

  @HiveField(11)
  int? calorieTarget;

  @HiveField(12)
  int? proteinTargetG;

  @HiveField(13)
  int? carbsTargetG;

  @HiveField(14)
  int? fatTargetG;

  // Subscription
  @HiveField(15)
  String subscriptionStatus; // 'trial', 'active', 'expired', 'cancelled'

  @HiveField(16)
  DateTime? trialStartDate;

  // Settings
  @HiveField(17)
  bool notificationsEnabled;

  @HiveField(18)
  String theme; // 'light', 'dark'

  User({
    required this.id,
    this.deviceId,
    required this.createdAt,
    this.name,
    this.age,
    this.weightKg,
    this.heightCm,
    this.gender,
    this.activityLevel,
    this.goal,
    this.tdee,
    this.calorieTarget,
    this.proteinTargetG,
    this.carbsTargetG,
    this.fatTargetG,
    this.subscriptionStatus = 'trial',
    this.trialStartDate,
    this.notificationsEnabled = true,
    this.theme = 'light',
  });

  // Factory constructor for creating a new user
  factory User.create({required String id, String? deviceId}) {
    return User(
      id: id,
      deviceId: deviceId,
      createdAt: DateTime.now(),
      subscriptionStatus: 'trial',
      trialStartDate: DateTime.now(),
      notificationsEnabled: true,
      theme: 'light',
    );
  }

  // Copy with method for immutability
  User copyWith({
    String? id,
    String? deviceId,
    DateTime? createdAt,
    String? name,
    int? age,
    double? weightKg,
    double? heightCm,
    String? gender,
    String? activityLevel,
    String? goal,
    int? tdee,
    int? calorieTarget,
    int? proteinTargetG,
    int? carbsTargetG,
    int? fatTargetG,
    String? subscriptionStatus,
    DateTime? trialStartDate,
    bool? notificationsEnabled,
    String? theme,
  }) {
    return User(
      id: id ?? this.id,
      deviceId: deviceId ?? this.deviceId,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      age: age ?? this.age,
      weightKg: weightKg ?? this.weightKg,
      heightCm: heightCm ?? this.heightCm,
      gender: gender ?? this.gender,
      activityLevel: activityLevel ?? this.activityLevel,
      goal: goal ?? this.goal,
      tdee: tdee ?? this.tdee,
      calorieTarget: calorieTarget ?? this.calorieTarget,
      proteinTargetG: proteinTargetG ?? this.proteinTargetG,
      carbsTargetG: carbsTargetG ?? this.carbsTargetG,
      fatTargetG: fatTargetG ?? this.fatTargetG,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      trialStartDate: trialStartDate ?? this.trialStartDate,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      theme: theme ?? this.theme,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, goal: $goal, calorieTarget: $calorieTarget)';
  }
}
