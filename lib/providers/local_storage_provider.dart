import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/data/models/user.dart';
import 'package:otto/data/services/local_storage_service.dart';

/// Provider for LocalStorageService instance
///
/// This provides a single instance of LocalStorageService throughout the app.
/// The service is used for Hive-based local storage operations.
///
/// Based on otto-spec.md lines 40-42 (Local Storage with Hive)
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

/// Provider for current user data from local storage
///
/// This is a FutureProvider that asynchronously fetches the current user
/// from Hive local storage. Returns null if no user is stored.
///
/// Usage:
/// ```dart
/// final user = ref.watch(currentUserProvider);
/// user.when(
///   data: (user) => user != null ? Text(user.name) : Text('No user'),
///   loading: () => CircularProgressIndicator(),
///   error: (err, stack) => Text('Error: $err'),
/// );
/// ```
final currentUserProvider = FutureProvider<User?>((ref) async {
  final localStorage = ref.watch(localStorageServiceProvider);
  return await localStorage.getUser();
});

/// Provider for onboarding completion status
///
/// This is a FutureProvider that checks if the user has completed onboarding.
/// Used by the splash screen to determine navigation path.
///
/// Returns:
/// - `true` if onboarding is complete (navigate to home)
/// - `false` if onboarding is not complete (navigate to onboarding)
///
/// Based on otto-spec.md lines 96-104 (Screen Flow)
final isOnboardingCompleteProvider = FutureProvider<bool>((ref) async {
  final localStorage = ref.watch(localStorageServiceProvider);
  return await localStorage.isOnboardingComplete();
});
