# Otto - Claude Code Build Prompts

## Instructions

Run these prompts **one at a time** in Claude Code. Wait for each to complete successfully before moving to the next. If something breaks, fix it before continuing.

**Important**: Keep the `otto-spec.md` file in your project root so Claude Code can reference it.

---

## Phase 1: Project Setup

### Prompt 1.1 - Create Flutter Project
```
Create a new Flutter project called "otto" with the following:
- Package name: com.otto.app
- Minimum Android SDK: 24
- Target Android SDK: 34
- Kotlin for Android
- Disable iOS, web, windows, linux, macos platforms (Android only)

Initialize git repository.
```

### Prompt 1.2 - Folder Structure
```
Create the following folder structure inside lib/:

lib/
├── core/
│   ├── constants/
│   ├── theme/
│   ├── utils/
│   └── extensions/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── features/
│   ├── onboarding/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── controllers/
│   ├── home/
│   │   ├── screens/
│   │   ├── widgets/
│   │   └── controllers/
│   ├── food_detail/
│   │   ├── screens/
│   │   └── widgets/
│   ├── quick_add/
│   │   ├── screens/
│   │   └── widgets/
│   ├── settings/
│   │   ├── screens/
│   │   └── widgets/
│   ├── paywall/
│   │   ├── screens/
│   │   └── widgets/
│   └── history/
│       ├── screens/
│       └── widgets/
├── shared/
│   ├── widgets/
│   └── animations/
└── providers/

Create empty .gitkeep files in each folder to preserve structure.
```

### Prompt 1.3 - Add Dependencies
```
Update pubspec.yaml with these dependencies:

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.4.0
  supabase_flutter: ^2.0.0
  purchases_flutter: ^6.0.0
  dio: ^5.0.0
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  google_fonts: ^6.0.0
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  lottie: ^2.7.0
  flutter_animate: ^4.0.0
  uuid: ^4.0.0
  intl: ^0.18.0
  url_launcher: ^6.0.0
  flutter_dotenv: ^5.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  hive_generator: ^2.0.0

Also add assets folders:
  assets:
    - assets/images/
    - assets/images/otto/
    - assets/animations/
    - assets/fonts/
    - .env

Run flutter pub get after updating.
```

### Prompt 1.4 - Create Assets Folders
```
Create these folders in the project root:
- assets/images/otto/
- assets/animations/
- assets/fonts/

Create an empty .env file in the project root with these placeholders:
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_gemini_api_key
PERPLEXITY_API_KEY=your_perplexity_api_key
REVENUECAT_API_KEY=your_revenuecat_api_key

Add .env to .gitignore
```

---

## Phase 2: Theme & Constants

### Prompt 2.1 - Color Constants
```
Create lib/core/constants/colors.dart with Otto's color palette:

- primary: #6B9DFC (soft blue)
- secondary: #FFB347 (warm orange)
- accent: #7ED4AD (mint green)
- background: #FFF9F5 (warm cream)
- surface: #FFFFFF (white)
- textPrimary: #2D3436
- textSecondary: #636E72
- error: #FF6B6B (soft red for over-limit)
- success: #7ED4AD (green for under-limit)
- warning: #FFB347 (orange for approaching limit)
- streakFlame: #FF9500

Create a static AppColors class with all these as static const Color values.
```

### Prompt 2.2 - Typography Constants
```
Create lib/core/constants/typography.dart

Define text styles using Google Fonts:
- Display/Headers: Nunito (bold, various sizes)
- Body: Inter (regular, various sizes)
- Numbers/Stats: Space Mono (for calorie numbers)

Create an AppTypography class with static TextStyle getters for:
- displayLarge (32px, Nunito Bold)
- displayMedium (24px, Nunito Bold)
- displaySmall (20px, Nunito SemiBold)
- headlineMedium (18px, Nunito SemiBold)
- bodyLarge (16px, Inter)
- bodyMedium (14px, Inter)
- bodySmall (12px, Inter)
- labelLarge (14px, Inter Medium)
- numberLarge (32px, Space Mono Bold)
- numberMedium (20px, Space Mono SemiBold)
- numberSmall (14px, Space Mono)
```

### Prompt 2.3 - Dimension Constants
```
Create lib/core/constants/dimensions.dart

Define spacing and sizing constants:

class AppDimensions {
  // Spacing
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  
  // Border Radius
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 999.0;
  
  // Icon Sizes
  static const double iconSm = 16.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  
  // Component Heights
  static const double buttonHeight = 56.0;
  static const double inputHeight = 56.0;
  static const double cardMinHeight = 72.0;
}
```

### Prompt 2.4 - App Theme
```
Create lib/core/theme/app_theme.dart

Build a complete ThemeData using the colors and typography we defined:
- Light theme only for now
- Use the warm cream background color
- Configure ElevatedButton theme with rounded corners (radiusLg) and primary color
- Configure TextButton theme
- Configure InputDecoration theme with rounded borders
- Configure Card theme with surface color and subtle shadow
- Configure AppBar theme with transparent background, no elevation
- Configure BottomSheet theme with rounded top corners

Export a static AppTheme.lightTheme getter.
```

### Prompt 2.5 - Constants Barrel File
```
Create lib/core/constants/constants.dart as a barrel file that exports:
- colors.dart
- typography.dart
- dimensions.dart

This allows single import: import 'package:otto/core/constants/constants.dart';
```

---

## Phase 3: Placeholder Assets

### Prompt 3.1 - Placeholder Otter SVG
```
Create a simple placeholder SVG for Otto the otter at assets/images/otto/otto_placeholder.svg

Make it a simple, cute otter silhouette in the primary blue color (#6B9DFC). Just a basic rounded shape that suggests an otter - we'll replace with real illustrations later.

Keep it minimal - just head and body outline, maybe simple dots for eyes.
```

### Prompt 3.2 - App Icon Placeholder
```
Create a simple app icon for Otto:
- Create assets/images/otto/app_icon.png (or describe what to create)
- Simple design: rounded square with warm cream background, blue otter silhouette in center
- This is temporary until real branding is done

Update android/app/src/main/res with appropriate icon sizes or note that this needs to be done manually.
```

### Prompt 3.3 - Onboarding Illustration Placeholders
```
Create 7 placeholder widgets in lib/shared/widgets/otto_illustrations.dart

Each should be a simple Container with:
- Rounded rectangle
- Light blue (#6B9DFC) background with 0.1 opacity
- Centered icon from Flutter's built-in icons
- Fixed size of 200x200

Create these as separate StatelessWidgets:
1. OttoWaving - Icons.waving_hand
2. OttoFloating - Icons.water
3. OttoMeasuring - Icons.straighten
4. OttoSwimming - Icons.pool
5. OttoThinking - Icons.psychology
6. OttoGoal - Icons.flag
7. OttoCelebrating - Icons.celebration

These are placeholders until real Lottie animations are added.
```

---

## Phase 4: Core Utilities

### Prompt 4.1 - TDEE Calculator
```
Create lib/core/utils/tdee_calculator.dart

Implement the Mifflin-St Jeor equation:

class TDEECalculator {
  // Calculate BMR
  static double calculateBMR({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender, // 'male', 'female', 'other'
  })
  
  // Calculate TDEE from BMR and activity level
  static double calculateTDEE({
    required double bmr,
    required String activityLevel, // 'sedentary', 'light', 'moderate', 'active', 'very_active'
  })
  
  // Calculate calorie target based on goal
  static int calculateCalorieTarget({
    required double tdee,
    required String goal, // 'lose', 'maintain', 'gain'
  })
  
  // Calculate macro targets
  static Map<String, int> calculateMacros({
    required int calories,
    required String goal,
  })
  
  // All-in-one calculation
  static Map<String, dynamic> calculateAll({
    required double weightKg,
    required double heightCm,
    required int age,
    required String gender,
    required String activityLevel,
    required String goal,
  })
}

Use the formulas from otto-spec.md. For 'other' gender, use average of male/female formulas.
```

### Prompt 4.2 - Date Utilities
```
Create lib/core/utils/date_utils.dart

class AppDateUtils {
  // Format date for display: "Today", "Yesterday", or "Jan 15"
  static String formatDisplayDate(DateTime date)
  
  // Format time: "2:30 PM"
  static String formatTime(DateTime time)
  
  // Check if date is today
  static bool isToday(DateTime date)
  
  // Check if date is yesterday
  static bool isYesterday(DateTime date)
  
  // Get start of day
  static DateTime startOfDay(DateTime date)
  
  // Get end of day
  static DateTime endOfDay(DateTime date)
  
  // Get date key for storage: "2024-01-15"
  static String toDateKey(DateTime date)
  
  // Parse date key back to DateTime
  static DateTime fromDateKey(String key)
}
```

### Prompt 4.3 - String Extensions
```
Create lib/core/extensions/string_extensions.dart

extension StringExtensions on String {
  // Capitalize first letter
  String capitalize()
  
  // Title case: "hello world" -> "Hello World"
  String toTitleCase()
  
  // Check if string is valid email
  bool get isValidEmail
  
  // Truncate with ellipsis: "Hello World" -> "Hello..."
  String truncate(int maxLength)
}
```

### Prompt 4.4 - Number Extensions
```
Create lib/core/extensions/number_extensions.dart

extension IntExtensions on int {
  // Format with commas: 1000 -> "1,000"
  String get formatted
  
  // Format as calories: 1500 -> "1,500 cal"
  String get asCalories
}

extension DoubleExtensions on double {
  // Round to decimal places
  double roundTo(int places)
  
  // Format as grams: 45.5 -> "45.5g"
  String get asGrams
}
```

### Prompt 4.5 - Extensions Barrel File
```
Create lib/core/extensions/extensions.dart as barrel file exporting:
- string_extensions.dart
- number_extensions.dart
```

### Prompt 4.6 - Utils Barrel File
```
Create lib/core/utils/utils.dart as barrel file exporting:
- tdee_calculator.dart
- date_utils.dart
```

---

## Phase 5: Data Models

### Prompt 5.1 - User Model
```
Create lib/data/models/user.dart

class User {
  final String id;
  final String? deviceId;
  final DateTime createdAt;
  
  // Profile
  final String? name;
  final int? age;
  final double? weightKg;
  final double? heightCm;
  final String? gender;
  final String? activityLevel;
  final String? goal;
  
  // Calculated targets
  final int? tdee;
  final int? calorieTarget;
  final int? proteinTargetG;
  final int? carbsTargetG;
  final int? fatTargetG;
  
  // Subscription
  final String subscriptionStatus; // 'trial', 'active', 'expired', 'cancelled'
  final DateTime? trialStartDate;
  
  // Settings
  final bool notificationsEnabled;
  final String theme;
  
  // Constructor with all fields
  // copyWith method
  // toJson method
  // fromJson factory
  // empty factory for initial state
}
```

### Prompt 5.2 - Food Log Model
```
Create lib/data/models/food_log.dart

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
  
  // Computed getters for actual values (edited or original)
  int get displayCalories => editedCalories ?? calories ?? 0;
  double get displayProtein => editedProteinG ?? proteinG ?? 0;
  double get displayCarbs => editedCarbsG ?? carbsG ?? 0;
  double get displayFat => editedFatG ?? fatG ?? 0;
  
  // Processing state
  final bool isProcessing;
  final String? errorMessage;
  
  // Constructor, copyWith, toJson, fromJson
}

class FoodSource {
  final String name;
  final String? url;
  final String? logoUrl;
  
  // Constructor, toJson, fromJson
}
```

### Prompt 5.3 - Daily Summary Model
```
Create lib/data/models/daily_summary.dart

class DailySummary {
  final String id;
  final String userId;
  final DateTime summaryDate;
  
  final int totalCalories;
  final double totalProteinG;
  final double totalCarbsG;
  final double totalFatG;
  final int entriesCount;
  
  // Constructor, copyWith, toJson, fromJson
  
  // Factory to create from list of FoodLogs
  factory DailySummary.fromLogs(String userId, DateTime date, List<FoodLog> logs)
}
```

### Prompt 5.4 - Frequent Food Model
```
Create lib/data/models/frequent_food.dart

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
  
  // Constructor, copyWith, toJson, fromJson
}
```

### Prompt 5.5 - Streak Model
```
Create lib/data/models/streak.dart

class Streak {
  final String id;
  final String userId;
  
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastLogDate;
  
  // Constructor, copyWith, toJson, fromJson
  
  // Method to check if streak should increment or reset
  Streak updateForNewLog(DateTime logDate)
}
```

### Prompt 5.6 - Models Barrel File
```
Create lib/data/models/models.dart exporting all models:
- user.dart
- food_log.dart
- daily_summary.dart
- frequent_food.dart
- streak.dart
```

---

## Phase 6: Onboarding UI - Shared Components

### Prompt 6.1 - Onboarding Page Template
```
Create lib/features/onboarding/widgets/onboarding_page_template.dart

A reusable template widget for onboarding screens:

class OnboardingPageTemplate extends StatelessWidget {
  final Widget illustration; // The otter illustration
  final String title;
  final String? subtitle;
  final Widget? content; // Form fields or other content
  final String buttonText;
  final VoidCallback onButtonPressed;
  final bool isButtonEnabled;
  
  // Layout:
  // - SafeArea
  // - Column with:
  //   - Expanded top section with illustration (centered)
  //   - Title text (displayMedium, centered)
  //   - Optional subtitle (bodyLarge, secondary color, centered)
  //   - Optional content area
  //   - Bottom padding
  //   - Full-width button
  //   - Bottom safe area padding
}

Use AppColors, AppTypography, AppDimensions from constants.
```

### Prompt 6.2 - Progress Dots Indicator
```
Create lib/features/onboarding/widgets/progress_dots.dart

class ProgressDots extends StatelessWidget {
  final int totalDots;
  final int currentIndex;
  
  // Row of dots
  // Current dot: primary color, slightly larger
  // Other dots: gray, smaller
  // Animated transitions between states using flutter_animate
}
```

### Prompt 6.3 - Pill Selection Widget
```
Create lib/features/onboarding/widgets/pill_selector.dart

class PillSelector extends StatelessWidget {
  final List<String> options;
  final String? selectedOption;
  final Function(String) onSelected;
  
  // Horizontal row of pill-shaped buttons
  // Selected: primary color background, white text
  // Unselected: surface color with border, primary text
  // Wrap if needed for long options
}
```

### Prompt 6.4 - Selection Card Widget
```
Create lib/features/onboarding/widgets/selection_card.dart

class SelectionCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  
  // Card with:
  // - Emoji on left (large)
  // - Title and description stacked on right
  // - Selected state: primary color border, light primary background
  // - Unselected: surface color, subtle border
  // - Subtle scale animation on tap
}
```

### Prompt 6.5 - Number Input Field
```
Create lib/features/onboarding/widgets/number_input_field.dart

class NumberInputField extends StatelessWidget {
  final String label;
  final String? unit; // "kg", "cm", "years"
  final double? value;
  final double min;
  final double max;
  final Function(double) onChanged;
  final bool allowDecimals;
  
  // Text field with:
  // - Label above
  // - Number keyboard
  // - Unit suffix inside field
  // - Validation for min/max
  // - Clean styling matching app theme
}
```

### Prompt 6.6 - Unit Toggle Widget
```
Create lib/features/onboarding/widgets/unit_toggle.dart

class UnitToggle extends StatelessWidget {
  final String leftLabel; // "kg"
  final String rightLabel; // "lbs"
  final bool isLeftSelected;
  final Function(bool) onChanged;
  
  // Small toggle switch for unit selection
  // Compact design, sits next to input fields
}
```

---

## Phase 7: Onboarding Screens

### Prompt 7.1 - Onboarding Controller
```
Create lib/features/onboarding/controllers/onboarding_controller.dart

Using Riverpod, create a StateNotifier to manage onboarding state:

class OnboardingState {
  final int currentPage;
  final String? name;
  final int? age;
  final String? gender;
  final double? weightKg;
  final double? heightCm;
  final bool useMetric;
  final String? activityLevel;
  final String? goal;
  final bool isCalculating;
  final Map<String, dynamic>? calculatedResults;
}

class OnboardingController extends StateNotifier<OnboardingState> {
  // Methods:
  void nextPage()
  void previousPage()
  void setName(String name)
  void setAge(int age)
  void setGender(String gender)
  void setWeight(double weight)
  void setHeight(double height)
  void toggleMetric()
  void setActivityLevel(String level)
  void setGoal(String goal)
  Future<void> calculateAndSave()
  
  // Validation getters
  bool get canProceedFromCurrentPage
}

Create the provider:
final onboardingControllerProvider = StateNotifierProvider<OnboardingController, OnboardingState>
```

### Prompt 7.2 - Welcome Screen (Page 1)
```
Create lib/features/onboarding/screens/welcome_screen.dart

First onboarding screen:
- OttoWaving illustration at top (use placeholder)
- Title: "Hey there! I'm Otto 🦦"
- Subtitle: "I'll help you track what you eat—no complicated food databases, just type like you're taking notes"
- Button: "Get Started"

Use OnboardingPageTemplate.
Add subtle fade-in animation using flutter_animate when screen appears.
```

### Prompt 7.3 - Name Screen (Page 2)
```
Create lib/features/onboarding/screens/name_screen.dart

- OttoFloating illustration
- Title: "What should I call you?"
- Single text input field for name
- Placeholder: "Your name"
- Button: "Continue" (disabled until name entered)

Auto-focus the text field when screen appears.
```

### Prompt 7.4 - Basic Info Screen (Page 3)
```
Create lib/features/onboarding/screens/basic_info_screen.dart

- OttoMeasuring illustration
- Title: "Let's get to know you a bit"
- Age input (NumberInputField with "years" unit)
- Gender selection (PillSelector with "Male", "Female", "Other")
- Button: "Continue" (disabled until both filled)
```

### Prompt 7.5 - Body Stats Screen (Page 4)
```
Create lib/features/onboarding/screens/body_stats_screen.dart

- OttoSwimming illustration
- Title: "Almost there!"
- Height input with unit toggle (cm/ft)
- Weight input with unit toggle (kg/lbs)
- Handle unit conversions internally, always store in metric
- Button: "Continue" (disabled until both filled)
```

### Prompt 7.6 - Activity Level Screen (Page 5)
```
Create lib/features/onboarding/screens/activity_level_screen.dart

- OttoThinking illustration
- Title: "How active are you typically?"
- 5 SelectionCards:
  - 🛋️ Sedentary - "Desk job, minimal exercise"
  - 🚶 Lightly Active - "Light exercise 1-3 days/week"
  - 🏃 Moderately Active - "Moderate exercise 3-5 days/week"
  - 💪 Very Active - "Hard exercise 6-7 days/week"
  - 🔥 Extremely Active - "Athlete or physical job"
- Only one can be selected at a time
- Button: "Continue" (disabled until selected)
```

### Prompt 7.7 - Goal Screen (Page 6)
```
Create lib/features/onboarding/screens/goal_screen.dart

- OttoGoal illustration
- Title: "What's your goal?"
- 3 large SelectionCards:
  - 📉 Lose Weight - "Burn more than you eat"
  - ⚖️ Maintain Weight - "Keep things balanced"
  - 📈 Gain Weight - "Build muscle or increase intake"
- Button: "Continue"
```

### Prompt 7.8 - Results Screen (Page 7)
```
Create lib/features/onboarding/screens/results_screen.dart

- OttoCelebrating illustration (with confetti-like animation using flutter_animate)
- Title: "Here's your personalized plan!"
- Large calorie number display (use numberLarge style)
- Macro breakdown row: Protein | Carbs | Fat (each with target grams)
- Brief explanation text: "Based on your info, this is your daily target to [reach your goal]"
- Button: "Start Tracking"

Trigger calculation when screen appears (from controller).
Show loading state while calculating.
```

### Prompt 7.9 - Onboarding Flow Container
```
Create lib/features/onboarding/screens/onboarding_flow.dart

Main container that manages the PageView of all onboarding screens:

class OnboardingFlow extends ConsumerWidget {
  // PageController for smooth transitions
  // PageView with all 7 screens
  // ProgressDots indicator at top
  // Back button (except on first page)
  // Handle page transitions from controller state changes
  // Prevent swipe navigation (button-only navigation)
}
```

---

## Phase 8: App Entry & Routing

### Prompt 8.1 - Environment Config
```
Create lib/core/config/env_config.dart

class EnvConfig {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  static String get perplexityApiKey => dotenv.env['PERPLEXITY_API_KEY'] ?? '';
  static String get revenueCatApiKey => dotenv.env['REVENUECAT_API_KEY'] ?? '';
  
  static bool get isConfigured => supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;
}
```

### Prompt 8.2 - App Router
```
Create lib/core/router/app_router.dart

Simple routing setup (no package needed for MVP):

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String foodDetail = '/food-detail';
  static const String paywall = '/paywall';
  static const String history = '/history';
}

Create a generateRoute function that returns appropriate MaterialPageRoute for each route.
```

### Prompt 8.3 - Splash Screen
```
Create lib/features/splash/screens/splash_screen.dart

Simple splash screen:
- Background: primary color or warm cream
- Center: Otto logo/placeholder
- Subtle pulse animation on logo
- Check if user exists in local storage
- Navigate to onboarding (new user) or home (returning user)
- Timeout of 2 seconds minimum for branding
```

### Prompt 8.4 - Main App File
```
Update lib/main.dart:

- Load environment variables with dotenv
- Initialize Hive for local storage
- Wrap app in ProviderScope (Riverpod)
- Set up MaterialApp with:
  - AppTheme.lightTheme
  - Initial route: splash
  - onGenerateRoute: AppRouter.generateRoute
  - debugShowCheckedModeBanner: false
```

### Prompt 8.5 - App Widget
```
Create lib/app.dart

Separate the MaterialApp configuration into its own file.
Keep main.dart minimal - just initialization and runApp.
```

---

## Phase 9: Local Storage Setup

### Prompt 9.1 - Local Storage Service
```
Create lib/data/services/local_storage_service.dart

class LocalStorageService {
  static const String _userBoxName = 'user_box';
  static const String _settingsBoxName = 'settings_box';
  
  // Initialize Hive boxes
  static Future<void> init()
  
  // User data
  Future<void> saveUser(User user)
  Future<User?> getUser()
  Future<void> clearUser()
  
  // Onboarding status
  Future<void> setOnboardingComplete(bool complete)
  Future<bool> isOnboardingComplete()
  
  // Simple key-value for settings
  Future<void> setValue(String key, dynamic value)
  Future<T?> getValue<T>(String key)
}
```

### Prompt 9.2 - Local Storage Provider
```
Create lib/providers/local_storage_provider.dart

Riverpod provider for LocalStorageService:

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});

Also create derived providers:
- currentUserProvider (watches local user data)
- isOnboardingCompleteProvider
```

---

## Phase 10: Home Screen - Basic Structure

### Prompt 10.1 - Home Screen Scaffold
```
Create lib/features/home/screens/home_screen.dart

Basic structure without functionality:
- Scaffold with warm cream background
- Custom AppBar with:
  - Otto icon (left)
  - "Today" button (center)
  - Streak badge placeholder (right)
  - Settings icon (right)
- Body: placeholder text "Food logs will appear here"
- Bottom: Input bar placeholder

No functionality yet, just the layout structure.
```

### Prompt 10.2 - Home App Bar
```
Create lib/features/home/widgets/home_app_bar.dart

Custom app bar widget:
- Row layout
- Left: Small Otto icon (tappable)
- Center: "Today" pill button (tappable, shows date picker later)
- Right: Row of streak badge + settings icon

PreferredSizeWidget so it can be used as AppBar.
```

### Prompt 10.3 - Streak Badge Widget
```
Create lib/features/home/widgets/streak_badge.dart

class StreakBadge extends StatelessWidget {
  final int streakCount;
  
  // Display: 🔥 {count}
  // Pill-shaped container
  // Subtle background color
  // Flame emoji + number
  // Add flame flicker animation (subtle opacity pulse)
}
```

### Prompt 10.4 - Calorie Input Bar
```
Create lib/features/home/widgets/calorie_input_bar.dart

Bottom input bar:
- Container with white background, top border or shadow
- Left: Remaining calories display "🔥 1,415 left"
- Right: Row of action buttons
  - Microphone icon (voice input - disabled for now)
  - Plus icon (quick add)
  - Keyboard icon (toggle input field)
- When keyboard mode active: show text field that expands

For now, static display only.
```

### Prompt 10.5 - Empty State Widget
```
Create lib/features/home/widgets/empty_state.dart

Shown when no food logs for the day:
- Centered content
- Otto illustration (floating pose)
- "No food logged yet today"
- "Type what you ate below to get started"
- Subtle and encouraging tone
```

---

## Phase 11: Food Entry Card

### Prompt 11.1 - Food Entry Card Widget
```
Create lib/features/home/widgets/food_entry_card.dart

class FoodEntryCard extends StatelessWidget {
  final FoodLog foodLog;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  
  // Layout:
  // - Row with rawInput text on left
  // - Right side shows one of:
  //   - "Thinking..." with shimmer animation (isProcessing)
  //   - "✨ {calories} cal" (completed)
  //   - Error icon (has error)
  // - Subtle divider between entries
  // - InkWell for tap handling
}
```

### Prompt 11.2 - Thinking Shimmer Animation
```
Create lib/shared/animations/thinking_shimmer.dart

class ThinkingShimmer extends StatelessWidget {
  // Animated shimmer effect on "Thinking..." text
  // Use flutter_animate for gradient shimmer
  // Subtle, not distracting
  // Loop animation
}
```

### Prompt 11.3 - Food Entry List
```
Create lib/features/home/widgets/food_entry_list.dart

class FoodEntryList extends StatelessWidget {
  final List<FoodLog> logs;
  final Function(FoodLog) onLogTap;
  final Function(FoodLog) onLogDelete;
  
  // ListView.builder
  // FoodEntryCard for each log
  // Swipe to delete with Dismissible
  // Empty state when list is empty
  // Reverse order (newest at top? or oldest at top - match notes style)
}
```

---

## Phase 12: Home Screen State Management

### Prompt 12.1 - Home Controller
```
Create lib/features/home/controllers/home_controller.dart

class HomeState {
  final List<FoodLog> todaysLogs;
  final DailySummary? todaysSummary;
  final Streak? streak;
  final bool isLoading;
  final String? error;
  final DateTime selectedDate;
  final bool isInputExpanded;
  final String inputText;
}

class HomeController extends StateNotifier<HomeState> {
  // Methods:
  void loadTodaysData()
  void changeDate(DateTime date)
  void toggleInput()
  void setInputText(String text)
  Future<void> submitFoodEntry(String rawInput)
  Future<void> deleteEntry(String logId)
  void clearError()
  
  // Computed getters
  int get remainingCalories
  int get totalCaloriesConsumed
}

final homeControllerProvider = StateNotifierProvider<HomeController, HomeState>
```

### Prompt 12.2 - Connect Home Screen to Controller
```
Update lib/features/home/screens/home_screen.dart

Convert to ConsumerWidget and:
- Watch homeControllerProvider
- Show loading state
- Display FoodEntryList with actual data (or empty list for now)
- Connect CalorieInputBar to controller
- Update remaining calories display from controller
- Handle input submission
```

### Prompt 12.3 - Expandable Input Field
```
Create lib/features/home/widgets/expandable_input.dart

When user taps keyboard icon or the input area:
- Animate input field expanding upward
- Auto-focus text field
- Show send button
- Press enter or send button to submit
- Collapse after submission
- Handle keyboard appearance smoothly
```

---

## Phase 13: Food Detail Bottom Sheet

### Prompt 13.1 - Food Detail Sheet
```
Create lib/features/food_detail/screens/food_detail_sheet.dart

Modal bottom sheet showing full food details:
- Drag handle at top
- Close button (X) and more menu (...)
- Food name as title
- Large calorie display with fire emoji
- Macro breakdown row (protein, carbs, fat)
- Divider
- Sources section
- AI reasoning section
- "Something off? Click to edit" link

Use showModalBottomSheet with DraggableScrollableSheet for expandable behavior.
```

### Prompt 13.2 - Macro Display Row
```
Create lib/features/food_detail/widgets/macro_display_row.dart

class MacroDisplayRow extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;
  
  // Horizontal row of three items:
  // [value]g
  // [emoji] [label]
  // 
  // Protein: 🥜
  // Carbs: 🍞
  // Fat: 🧈
}
```

### Prompt 13.3 - Sources Display Widget
```
Create lib/features/food_detail/widgets/sources_display.dart

class SourcesDisplay extends StatelessWidget {
  final List<FoodSource> sources;
  
  // "Found {n} sources" header
  // Row of source logos/icons
  // Expandable to show full list with names and links
}
```

### Prompt 13.4 - AI Reasoning Card
```
Create lib/features/food_detail/widgets/ai_reasoning_card.dart

class AIReasoningCard extends StatelessWidget {
  final String reasoning;
  final int confidenceScore;
  
  // Card with:
  // - "Otto's thought process" header
  // - Confidence indicator (circular progress with score)
  // - Confidence label (High/Medium/Low based on score)
  // - Reasoning text in conversational style
  // - Edit prompt at bottom
}
```

### Prompt 13.5 - Confidence Indicator
```
Create lib/features/food_detail/widgets/confidence_indicator.dart

class ConfidenceIndicator extends StatelessWidget {
  final int score; // 0-100
  
  // Circular progress indicator
  // Color: green (70+), yellow (40-69), red (<40)
  // Score number in center
  // Label below: "High", "Medium", "Low"
}
```

---

## Phase 14: Goals Summary View

### Prompt 14.1 - Goals Summary Sheet
```
Create lib/features/home/widgets/goals_summary_sheet.dart

Pull-down or tap-to-reveal summary showing:
- "Goals" header
- Calorie progress bar with current/target
- Carbs progress bar with current/target
- Protein progress bar with current/target
- Fat progress bar with current/target

Color coding:
- Green: under target
- Yellow: 80-100% of target
- Red: over target
```

### Prompt 14.2 - Macro Progress Bar
```
Create lib/shared/widgets/macro_progress_bar.dart

class MacroProgressBar extends StatelessWidget {
  final String label;
  final String emoji;
  final double current;
  final double target;
  final String unit; // "cal" or "g"
  
  // Label row: emoji + label on left, current/target on right
  // Progress bar below
  // Animated fill
  // Color changes based on percentage
}
```

### Prompt 14.3 - Integrate Goals into Home
```
Update home_screen.dart to include goals summary:

Option 1: Pull-down gesture reveals goals
Option 2: Tappable summary bar at bottom (above input) shows sheet
Option 3: Floating action button to toggle goals overlay

Implement Option 2 - a compact summary bar that expands to full goals sheet when tapped.
```

---

## Phase 15: Settings Screen

### Prompt 15.1 - Settings Screen Structure
```
Create lib/features/settings/screens/settings_screen.dart

Scaffold with:
- AppBar with back button and "Settings" title
- ListView of setting sections:
  - Profile section
  - Account section
  - App section
  - About section

Each section is a card with grouped list tiles.
```

### Prompt 15.2 - Settings List Tile
```
Create lib/features/settings/widgets/settings_list_tile.dart

class SettingsListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  
  // Consistent styling for all settings items
  // Trailing arrow icon by default if onTap provided
}
```

### Prompt 15.3 - Settings Section Card
```
Create lib/features/settings/widgets/settings_section.dart

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  
  // Section header text
  // Card containing children list tiles
  // Dividers between items
}
```

### Prompt 15.4 - Edit Goals Screen
```
Create lib/features/settings/screens/edit_goals_screen.dart

Allow user to manually adjust:
- Calorie target (number input)
- Protein target (number input)
- Carbs target (number input)
- Fat target (number input)

Show current values, allow editing, save button.
```

### Prompt 15.5 - Edit Profile Screen
```
Create lib/features/settings/screens/edit_profile_screen.dart

Allow user to update:
- Name
- Age
- Weight
- Height
- Activity level
- Goal

Recalculate TDEE when relevant fields change.
"Recalculate Targets" button.
```

---

## Phase 16: Quick Add Feature

### Prompt 16.1 - Quick Add Sheet
```
Create lib/features/quick_add/screens/quick_add_sheet.dart

Modal bottom sheet showing:
- "Quick Add" header with close button
- Search input field
- "Recent" section with recent foods
- "Most Used" section with frequent foods

Tapping a food instantly adds it to today's log.
```

### Prompt 16.2 - Quick Add Food Tile
```
Create lib/features/quick_add/widgets/quick_add_tile.dart

class QuickAddTile extends StatelessWidget {
  final FrequentFood food;
  final VoidCallback onTap;
  
  // Food name on left
  // Calories on right
  // Tap to add
}
```

### Prompt 16.3 - Frequent Foods Controller
```
Create lib/features/quick_add/controllers/quick_add_controller.dart

class QuickAddController extends StateNotifier<QuickAddState> {
  // Load recent foods (last 10 unique)
  // Load most used foods (by useCount)
  // Search/filter functionality
  // Add food to log (calls home controller)
}
```

---

## Phase 17: Paywall Screen

### Prompt 17.1 - Paywall Screen
```
Create lib/features/paywall/screens/paywall_screen.dart

Full screen paywall:
- Close button (top right, only if dismissible)
- Otto celebration illustration
- "Unlock Otto Pro 🦦✨" headline
- Feature list with checkmarks
- Yearly plan option (highlighted as best value)
- Monthly plan option
- "Start Free Trial" button
- "5 days free, cancel anytime" text
- "Restore Purchase" link at bottom
```

### Prompt 17.2 - Plan Selection Card
```
Create lib/features/paywall/widgets/plan_card.dart

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String? badge; // "BEST VALUE"
  final String? savings; // "Save 17%"
  final bool isSelected;
  final VoidCallback onTap;
  
  // Card with border
  // Badge ribbon if provided
  // Selected state styling
}
```

### Prompt 17.3 - Feature List Item
```
Create lib/features/paywall/widgets/feature_list_item.dart

class FeatureListItem extends StatelessWidget {
  final String text;
  
  // Row with:
  // - Checkmark icon (green)
  // - Feature text
}
```

---

## Phase 18: Supabase Integration

### Prompt 18.1 - Supabase Service
```
Create lib/data/services/supabase_service.dart

class SupabaseService {
  final SupabaseClient _client;
  
  // Initialize
  static Future<void> init()
  
  // Auth
  Future<User> signInAnonymously()
  Future<void> linkWithGoogle()
  Future<void> signOut()
  String? get currentUserId
  
  // Stream auth changes
  Stream<AuthState> get authStateChanges
}
```

### Prompt 18.2 - User Repository
```
Create lib/data/repositories/user_repository.dart

class UserRepository {
  final SupabaseService _supabase;
  final LocalStorageService _localStorage;
  
  // Create user in Supabase
  Future<User> createUser(User user)
  
  // Get user by ID
  Future<User?> getUser(String id)
  
  // Update user
  Future<User> updateUser(User user)
  
  // Delete user data
  Future<void> deleteUserData(String userId)
  
  // Sync local to remote
  Future<void> syncUser()
}

final userRepositoryProvider = Provider<UserRepository>
```

### Prompt 18.3 - Food Repository
```
Create lib/data/repositories/food_repository.dart

class FoodRepository {
  // Add food log
  Future<FoodLog> addFoodLog(FoodLog log)
  
  // Get logs for date
  Future<List<FoodLog>> getLogsForDate(String userId, DateTime date)
  
  // Update food log
  Future<FoodLog> updateFoodLog(FoodLog log)
  
  // Delete food log
  Future<void> deleteFoodLog(String logId)
  
  // Get daily summary
  Future<DailySummary?> getDailySummary(String userId, DateTime date)
  
  // Update or create daily summary
  Future<void> updateDailySummary(DailySummary summary)
}

final foodRepositoryProvider = Provider<FoodRepository>
```

### Prompt 18.4 - Streak Repository
```
Create lib/data/repositories/streak_repository.dart

class StreakRepository {
  // Get streak for user
  Future<Streak?> getStreak(String userId)
  
  // Update streak
  Future<Streak> updateStreak(Streak streak)
  
  // Increment streak (handles logic)
  Future<Streak> recordLog(String userId, DateTime logDate)
}

final streakRepositoryProvider = Provider<StreakRepository>
```

### Prompt 18.5 - Frequent Food Repository
```
Create lib/data/repositories/frequent_food_repository.dart

class FrequentFoodRepository {
  // Get frequent foods for user
  Future<List<FrequentFood>> getFrequentFoods(String userId)
  
  // Get recent foods (last N unique)
  Future<List<FrequentFood>> getRecentFoods(String userId, int limit)
  
  // Add or increment frequent food
  Future<void> recordFoodUsage(String userId, FoodLog log)
}
```

---

## Phase 19: AI Services

### Prompt 19.1 - Gemini Service
```
Create lib/data/services/gemini_service.dart

class GeminiService {
  final Dio _dio;
  
  // Parse food input and return structured data
  Future<FoodParseResult> parseFood({
    required String rawInput,
    required String nutritionContext, // From Perplexity
  })
  
  // Generate friendly reasoning text
  Future<String> generateReasoning({
    required String foodName,
    required int calories,
    required Map<String, double> macros,
    required List<String> sources,
  })
}

class FoodParseResult {
  final String foodName;
  final int calories;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final int confidenceScore;
  final String reasoning;
  final List<FoodItem>? breakdown;
}
```

### Prompt 19.2 - Perplexity Service
```
Create lib/data/services/perplexity_service.dart

class PerplexityService {
  final Dio _dio;
  
  // Search for nutrition data
  Future<NutritionSearchResult> searchNutrition(String query)
}

class NutritionSearchResult {
  final String summary;
  final List<FoodSource> sources;
  final String rawResponse;
}
```

### Prompt 19.3 - AI Orchestrator Service
```
Create lib/data/services/ai_orchestrator_service.dart

Coordinates Gemini and Perplexity:

class AIOrchestrator {
  final GeminiService _gemini;
  final PerplexityService _perplexity;
  
  // Main entry point for food analysis
  Future<FoodLog> analyzeFoodInput({
    required String rawInput,
    required String userId,
  })
  
  // Pipeline:
  // 1. Send rawInput to Perplexity for nutrition data
  // 2. Pass Perplexity results + rawInput to Gemini
  // 3. Gemini parses, calculates, generates reasoning
  // 4. Return complete FoodLog object
}

final aiOrchestratorProvider = Provider<AIOrchestrator>
```

### Prompt 19.4 - Mock AI Service
```
Create lib/data/services/mock_ai_service.dart

Mock implementation for development without API keys:

class MockAIService implements AIOrchestrator {
  // Return fake but realistic data
  // Random delays to simulate network
  // Useful for UI development
}

Add a flag to switch between mock and real services.
```

---

## Phase 20: RevenueCat Integration

### Prompt 20.1 - RevenueCat Service
```
Create lib/data/services/revenuecat_service.dart

class RevenueCatService {
  // Initialize
  static Future<void> init(String apiKey)
  
  // Get customer info
  Future<CustomerInfo> getCustomerInfo()
  
  // Check subscription status
  Future<bool> isSubscribed()
  
  // Check if in trial
  Future<bool> isInTrial()
  
  // Get trial days remaining
  Future<int> getTrialDaysRemaining()
  
  // Purchase subscription
  Future<CustomerInfo> purchase(Package package)
  
  // Restore purchases
  Future<CustomerInfo> restorePurchases()
  
  // Get available packages
  Future<Offerings> getOfferings()
}
```

### Prompt 20.2 - Subscription Provider
```
Create lib/providers/subscription_provider.dart

class SubscriptionState {
  final bool isLoading;
  final bool isSubscribed;
  final bool isInTrial;
  final int trialDaysRemaining;
  final String? error;
}

class SubscriptionController extends StateNotifier<SubscriptionState> {
  // Check subscription status
  // Purchase flow
  // Restore flow
}

final subscriptionProvider = StateNotifierProvider<SubscriptionController, SubscriptionState>
```

### Prompt 20.3 - Paywall Logic Integration
```
Update lib/features/paywall/screens/paywall_screen.dart

Connect to RevenueCatService:
- Load offerings on screen open
- Display actual prices from RevenueCat
- Handle purchase flow with loading states
- Handle restore purchases
- Show error states
- Navigate away on successful purchase
```

### Prompt 20.4 - Subscription Gate
```
Create lib/shared/widgets/subscription_gate.dart

class SubscriptionGate extends ConsumerWidget {
  final Widget child;
  final Widget? lockedWidget; // Optional custom locked state
  
  // If subscribed or in trial: show child
  // If not: show paywall or lockedWidget
}

Use this to wrap premium features.
```

---

## Phase 21: Connect Everything

### Prompt 21.1 - Update Onboarding to Save Data
```
Update onboarding_controller.dart:

In calculateAndSave() method:
1. Calculate TDEE and macros using TDEECalculator
2. Create User object with all data
3. Save to LocalStorageService
4. Create anonymous Supabase user
5. Save user to Supabase
6. Mark onboarding complete
7. Navigate to home screen
```

### Prompt 21.2 - Update Home to Load Real Data
```
Update home_controller.dart:

In loadTodaysData():
1. Get current user from provider
2. Load today's food logs from FoodRepository
3. Calculate daily summary
4. Load streak data
5. Update state

In submitFoodEntry():
1. Create pending FoodLog with isProcessing=true
2. Add to local state immediately (optimistic UI)
3. Call AIOrchestrator.analyzeFoodInput()
4. Update log with results
5. Save to FoodRepository
6. Update daily summary
7. Record streak
8. Record frequent food usage
```

### Prompt 21.3 - Update Splash Screen Logic
```
Update splash_screen.dart:

On init:
1. Initialize Supabase
2. Initialize RevenueCat
3. Check if onboarding complete
4. Check subscription status
5. Route appropriately:
   - New user → Onboarding
   - Returning user, subscribed → Home
   - Returning user, trial expired → Paywall
   - Returning user, in trial → Home
```

### Prompt 21.4 - Error Handling Wrapper
```
Create lib/shared/widgets/error_boundary.dart

class ErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error)? errorBuilder;
  
  // Catch and display errors gracefully
  // Show retry button
  // Log errors
}

Wrap main app content in error boundary.
```

### Prompt 21.5 - Loading States
```
Create lib/shared/widgets/loading_overlay.dart

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  
  // Overlay with:
  // - Semi-transparent background
  // - Centered loading indicator
  // - Optional message
  // - Otto animation (thinking pose)
}
```

---

## Phase 22: Polish & Animations

### Prompt 22.1 - Page Transition Animations
```
Create lib/core/theme/page_transitions.dart

Custom page route transitions:
- SlideUpPageRoute (for bottom sheets becoming full pages)
- FadePageRoute (for simple transitions)
- SharedAxisPageRoute (for forward/back navigation)

Apply to app router.
```

### Prompt 22.2 - Food Entry Animation
```
Update food_entry_card.dart:

Add animations:
- Fade in when new entry added
- Shimmer on "Thinking..." text
- Scale + sparkle when calories appear
- Swipe delete animation
```

### Prompt 22.3 - Progress Bar Animations
```
Update macro_progress_bar.dart:

Add animations:
- Smooth fill animation on load
- Color transition when threshold crossed
- Subtle pulse when over limit
```

### Prompt 22.4 - Streak Badge Celebration
```
Update streak_badge.dart:

Add milestone celebrations:
- Confetti burst on 7, 30, 100 day milestones
- Flame grows briefly when streak increments
- Haptic feedback on increment
```

### Prompt 22.5 - Button Haptics
```
Create lib/core/utils/haptics.dart

class HapticUtils {
  static void lightTap()
  static void mediumTap()
  static void success()
  static void error()
}

Add haptic feedback to:
- All buttons
- Swipe to delete
- Food log submission
- Streak increment
```

### Prompt 22.6 - Pull to Refresh
```
Add pull-to-refresh to home screen:

- RefreshIndicator wrapper
- Custom indicator with Otto diving animation
- Refresh today's data from server
```

---

## Phase 23: History Feature

### Prompt 23.1 - History Screen
```
Create lib/features/history/screens/history_screen.dart

Calendar-based history view:
- Month calendar at top
- Dots on days with logs
- Selected day shows that day's logs below
- Swipe between months
```

### Prompt 23.2 - Calendar Widget
```
Create lib/features/history/widgets/calendar_widget.dart

Custom calendar widget:
- Month/year header with navigation arrows
- Day grid
- Highlight current day
- Dots/indicators for days with logs
- Selected day highlight
- Tap to select day
```

### Prompt 23.3 - Day Summary Card
```
Create lib/features/history/widgets/day_summary_card.dart

Summary for selected day:
- Date header
- Total calories
- Macro breakdown
- List of food entries
- "No data" state for empty days
```

### Prompt 23.4 - Weekly Summary View
```
Create lib/features/history/widgets/weekly_summary.dart

Alternative view showing:
- Bar chart of daily calories for the week
- Average daily intake
- Days on target vs over/under
- Macro averages
```

---

## Phase 24: Data Export

### Prompt 24.1 - Export Service
```
Create lib/data/services/export_service.dart

class ExportService {
  // Export food logs to CSV
  Future<File> exportToCSV({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  })
  
  // CSV format:
  // Date, Time, Food, Calories, Protein, Carbs, Fat
}
```

### Prompt 24.2 - Export Screen
```
Create lib/features/settings/screens/export_screen.dart

Screen for data export:
- Date range picker (start/end)
- Preview of data count
- Export button
- Share sheet to save/send file
```

---

## Phase 25: UserJot Feedback Integration

### Prompt 25.1 - UserJot Service
```
Create lib/data/services/userjot_service.dart

Integration with UserJot:
- Open feedback widget/webview
- Pass user ID for tracking
- Handle deep links back to app
```

### Prompt 25.2 - Feedback Button
```
Update settings_screen.dart:

Add "Send Feedback" option that:
- Opens UserJot feedback form
- Pre-fills user ID
- Returns to app after submission
```

---

## Phase 26: Final Integration & Testing

### Prompt 26.1 - Environment Switching
```
Create lib/core/config/app_config.dart

class AppConfig {
  static const bool useMockAI = true; // Toggle for development
  static const bool enableAnalytics = false;
  static const bool showDebugInfo = true;
}

Update services to check these flags.
```

### Prompt 26.2 - Debug Screen
```
Create lib/features/settings/screens/debug_screen.dart (dev only)

Debug utilities:
- Clear all local data
- Reset onboarding
- View raw user data
- Test AI services
- Toggle mock mode
- Force paywall
- Simulate subscription states
```

### Prompt 26.3 - App Review Flow
```
Run through complete app flow and fix issues:

1. Fresh install → Splash → Onboarding
2. Complete onboarding → Home
3. Add food entry → See calories
4. View food details
5. Check goals summary
6. Quick add food
7. View history
8. Check settings
9. Close and reopen → Data persists
10. Uninstall/reinstall → Onboarding again (unless Google backup)
```

### Prompt 26.4 - Error State Review
```
Review and implement error states for:

1. No internet connection
2. AI service failure
3. Supabase sync failure
4. Invalid user input
5. Subscription check failure

Each should have:
- User-friendly error message
- Retry option where applicable
- Fallback behavior
```

### Prompt 26.5 - Performance Review
```
Review app performance:

1. Check for unnecessary rebuilds (add const constructors)
2. Optimize list rendering (keys, const items)
3. Image caching
4. Lazy loading where appropriate
5. Dispose controllers properly
```

---

## Phase 27: Pre-Launch Checklist

### Prompt 27.1 - Update App Metadata
```
Update Android app metadata:

android/app/src/main/AndroidManifest.xml:
- App name: Otto
- Permissions needed (internet, etc.)

android/app/build.gradle:
- Version name: 1.0.0
- Version code: 1
- Application ID: com.otto.app
```

### Prompt 27.2 - Splash Screen Native
```
Configure native splash screen:

- Add flutter_native_splash package
- Configure splash with Otto colors
- Simple centered logo
- Run flutter pub run flutter_native_splash:create
```

### Prompt 27.3 - App Icons
```
Configure app icons:

- Add flutter_launcher_icons package
- Configure with Otto icon
- Run flutter pub run flutter_launcher_icons
- Verify icon appears correctly
```

### Prompt 27.4 - ProGuard Rules
```
Add ProGuard rules for release build:

android/app/proguard-rules.pro:
- Rules for Supabase
- Rules for RevenueCat
- Rules for any reflection-based libraries
```

### Prompt 27.5 - Build Release APK
```
Build release APK:

1. Ensure .env has production keys
2. flutter build apk --release
3. Test release APK on device
4. Verify all features work
5. Check no debug banners/logs
```

---

## Notes

### Between Prompts
- Always test the feature before moving on
- Commit working code to git
- Fix any errors before continuing

### If Something Breaks
- Ask Claude Code to fix the specific error
- Don't skip ahead hoping it'll resolve itself

### API Keys
You'll need to pause and set up:
1. Supabase project (after Phase 18)
2. Gemini API key (after Phase 19)
3. Perplexity API key (after Phase 19)
4. RevenueCat account (after Phase 20)
5. UserJot project (after Phase 25)

### Illustrations
The placeholder otter illustrations can be replaced anytime. Consider:
- Commissioning an illustrator
- Using AI image generation (Midjourney, DALL-E)
- Creating simple vector art in Figma

Good luck building Otto! 🦦
