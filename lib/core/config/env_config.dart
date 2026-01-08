import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration class for accessing API keys and secrets
///
/// This class provides a centralized way to access environment variables
/// stored in the .env file. All sensitive data like API keys should be
/// stored in .env and never committed to version control.
class EnvConfig {
  // Supabase Configuration
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // AI Services Configuration
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get perplexityApiKey => dotenv.env['PERPLEXITY_API_KEY'] ?? '';

  // Payments Configuration
  static String get revenueCatApiKey => dotenv.env['REVENUECAT_API_KEY'] ?? '';

  // Feedback Service Configuration
  static String get userJotProjectId => dotenv.env['USERJOT_PROJECT_ID'] ?? '';

  // Validation Helpers

  /// Check if core configuration is valid (Supabase must be configured)
  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// Check if AI services are configured
  static bool get isAIConfigured =>
      geminiApiKey.isNotEmpty && perplexityApiKey.isNotEmpty;

  /// Check if payment service is configured
  static bool get isPaymentConfigured => revenueCatApiKey.isNotEmpty;

  /// Check if feedback service is configured
  static bool get isFeedbackConfigured => userJotProjectId.isNotEmpty;

  /// Initialize dotenv - call this in main() before runApp()
  static Future<void> initialize() async {
    await dotenv.load(fileName: '.env');
  }
}
