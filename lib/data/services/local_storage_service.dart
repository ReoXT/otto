import 'package:hive_flutter/hive_flutter.dart';
import 'package:otto/data/models/user.dart';

/// Local storage service using Hive
class LocalStorageService {
  static const String _userBoxName = 'user_box';
  static const String _settingsBoxName = 'settings_box';
  static const String _onboardingKey = 'onboarding_complete';
  static const String _currentUserKey = 'current_user';

  /// Initialize Hive boxes
  static Future<void> init() async {
    await Hive.initFlutter();
    
    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(UserAdapter());
    }

    // Open boxes
    await Hive.openBox(_userBoxName);
    await Hive.openBox(_settingsBoxName);
  }

  /// Get user box
  Box get _userBox => Hive.box(_userBoxName);

  /// Get settings box
  Box get _settingsBox => Hive.box(_settingsBoxName);

  // User data methods

  /// Save user to local storage
  Future<void> saveUser(User user) async {
    await _userBox.put(_currentUserKey, user);
  }

  /// Get current user from local storage
  Future<User?> getUser() async {
    return _userBox.get(_currentUserKey) as User?;
  }

  /// Clear user data
  Future<void> clearUser() async {
    await _userBox.delete(_currentUserKey);
  }

  // Onboarding methods

  /// Set onboarding complete status
  Future<void> setOnboardingComplete(bool complete) async {
    await _settingsBox.put(_onboardingKey, complete);
  }

  /// Check if onboarding is complete
  Future<bool> isOnboardingComplete() async {
    return _settingsBox.get(_onboardingKey, defaultValue: false) as bool;
  }

  // Generic key-value methods

  /// Save a value to settings
  Future<void> setValue(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  /// Get a value from settings
  Future<T?> getValue<T>(String key) async {
    return _settingsBox.get(key) as T?;
  }

  /// Delete a value from settings
  Future<void> deleteValue(String key) async {
    await _settingsBox.delete(key);
  }

  /// Clear all data (useful for logout/reset)
  Future<void> clearAll() async {
    await _userBox.clear();
    await _settingsBox.clear();
  }

  /// Close all boxes (call on app dispose)
  Future<void> close() async {
    await _userBox.close();
    await _settingsBox.close();
  }
}
