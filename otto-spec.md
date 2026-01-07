# Otto - AI-Powered Calorie Tracker

## Project Overview

Otto is a minimalist, playful calorie tracking app that lets users log food in natural language—like writing in a notes app—and instantly see nutritional information powered by AI. The app features an otter mascot and is designed to be delightful for users with ADHD through playful animations, satisfying interactions, and a clean, uncluttered interface.

**Tagline**: "Track calories like writing in your notes"

---

## Technical Stack

### Core Framework
- **Flutter** (latest stable)
- **Dart**
- **Target Platform**: Android only (initially)

### Backend & Data
- **Supabase**
  - Anonymous authentication (UUID on first launch, optional account linking later)
  - PostgreSQL database for user data, food logs, preferences
  - Real-time sync

### AI Services
- **Google Gemini 2.5 Flash Lite** - Natural language food parsing, calorie estimation
- **Perplexity Sonar** - Sourced nutrition data with citations

### Payments
- **RevenueCat** - Subscription management
  - 5-day free trial
  - $7.99/month
  - $79.99/year

### Feedback
- **UserJot** - In-app feedback collection (free tier)

### State Management
- **Riverpod** (recommended for Flutter)

### Local Storage
- **Hive** or **SharedPreferences** for local caching
- **Drift** (SQLite) for structured local data

---

## Brand Identity

### Name & Mascot
- **App Name**: Otto
- **Mascot**: Friendly otter character
- **Personality**: Helpful, playful, encouraging, never judgmental

### Design Direction
- **Aesthetic**: Minimalist + Playful
- **Feel**: Calm, uncluttered, satisfying micro-interactions
- **Target User**: People with ADHD who need simple, engaging interfaces

### Color Palette
```
Primary: #6B9DFC (Soft blue - trust, calm)
Secondary: #FFB347 (Warm orange - energy, playfulness)
Accent: #7ED4AD (Mint green - success, freshness)
Background: #FFF9F5 (Warm cream - soft, easy on eyes)
Surface: #FFFFFF
Text Primary: #2D3436
Text Secondary: #636E72
Error/Over: #FF6B6B (Soft red)
Success/Under: #7ED4AD
```

### Typography
```
Display/Headers: Nunito (rounded, friendly)
Body: Inter or SF Pro (clean readability)
Numbers/Stats: Space Mono or JetBrains Mono (clear, distinct)
```

### Otter Illustrations (6-7 poses needed)
1. Floating on back, relaxed (welcome screen)
2. Holding food/fish, excited (food logging)
3. Sleeping peacefully (night mode / rest)
4. Swimming energetically (activity/goals)
5. Waving hello (onboarding intro)
6. Celebrating with arms up (achievements/streaks)
7. Thinking pose with paw on chin (AI processing)

**Animation Style**: Simple 2D, subtle movements (floating, blinking, gentle sway). Use Rive or Lottie for animations.

---

## App Architecture

### Screen Flow

```
App Launch
    ↓
[First Launch?] → Yes → Onboarding (6-7 screens)
    ↓ No                      ↓
    ↓                   TDEE Calculation
    ↓                         ↓
    ↓               Save to Supabase
    ↓                         ↓
    └──────────────→ Home Screen
                          ↓
                    [Log Food] → AI Processing → Results
                          ↓
                    [View History]
                          ↓
                    [Settings/Profile]
```

### Database Schema (Supabase)

```sql
-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  device_id TEXT UNIQUE,
  created_at TIMESTAMP DEFAULT NOW(),
  
  -- Profile data (from onboarding)
  name TEXT,
  age INTEGER,
  weight_kg DECIMAL,
  height_cm DECIMAL,
  gender TEXT, -- 'male', 'female', 'other'
  activity_level TEXT, -- 'sedentary', 'light', 'moderate', 'active', 'very_active'
  goal TEXT, -- 'lose', 'maintain', 'gain'
  
  -- Calculated values
  tdee INTEGER, -- Total Daily Energy Expenditure
  calorie_target INTEGER,
  protein_target_g INTEGER,
  carbs_target_g INTEGER,
  fat_target_g INTEGER,
  
  -- Subscription
  subscription_status TEXT DEFAULT 'trial', -- 'trial', 'active', 'expired', 'cancelled'
  trial_start_date TIMESTAMP,
  
  -- Settings
  notifications_enabled BOOLEAN DEFAULT true,
  theme TEXT DEFAULT 'light'
);

-- Food logs table
CREATE TABLE food_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  logged_date DATE DEFAULT CURRENT_DATE,
  
  -- User input
  raw_input TEXT NOT NULL, -- What user typed
  
  -- AI parsed data
  food_name TEXT,
  calories INTEGER,
  protein_g DECIMAL,
  carbs_g DECIMAL,
  fat_g DECIMAL,
  
  -- Source attribution
  sources JSONB, -- Array of {name, url, logo_url}
  ai_reasoning TEXT, -- "Otto's thought process"
  confidence_score INTEGER, -- 0-100
  
  -- User corrections
  is_edited BOOLEAN DEFAULT false,
  edited_calories INTEGER,
  edited_protein_g DECIMAL,
  edited_carbs_g DECIMAL,
  edited_fat_g DECIMAL
);

-- Daily summaries (cached/computed)
CREATE TABLE daily_summaries (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  summary_date DATE NOT NULL,
  
  total_calories INTEGER DEFAULT 0,
  total_protein_g DECIMAL DEFAULT 0,
  total_carbs_g DECIMAL DEFAULT 0,
  total_fat_g DECIMAL DEFAULT 0,
  
  entries_count INTEGER DEFAULT 0,
  
  UNIQUE(user_id, summary_date)
);

-- Frequent foods (for quick add)
CREATE TABLE frequent_foods (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  
  food_name TEXT NOT NULL,
  calories INTEGER,
  protein_g DECIMAL,
  carbs_g DECIMAL,
  fat_g DECIMAL,
  
  use_count INTEGER DEFAULT 1,
  last_used_at TIMESTAMP DEFAULT NOW()
);

-- Streaks
CREATE TABLE streaks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  
  current_streak INTEGER DEFAULT 0,
  longest_streak INTEGER DEFAULT 0,
  last_log_date DATE
);
```

---

## Feature Specifications

### 1. Onboarding Flow (6-7 Screens)

Each screen should have:
- Full-screen illustration with otter animation
- Large, friendly headline
- Minimal input (one thing per screen)
- Progress indicator (dots)
- Smooth page transitions

**Screen 1: Welcome**
- Otter waving animation
- "Hey there! I'm Otto 🦦"
- "I'll help you track what you eat—no complicated food databases, just type like you're taking notes"
- [Get Started] button

**Screen 2: Name**
- Otter floating happily
- "What should I call you?"
- Single text input for name
- [Continue]

**Screen 3: Basic Info**
- Otter with measuring tape (playful)
- "Let's get to know you a bit"
- Age (number picker/slider)
- Gender (pill buttons: Male / Female / Other)
- [Continue]

**Screen 4: Body Stats**
- Otter swimming
- "Almost there!"
- Height (cm or ft/in toggle)
- Current weight (kg or lbs toggle)
- [Continue]

**Screen 5: Activity Level**
- Otter in different energy states
- "How active are you typically?"
- Visual cards (not dropdown):
  - 🛋️ Sedentary (desk job, minimal exercise)
  - 🚶 Lightly Active (light exercise 1-3 days/week)
  - 🏃 Moderately Active (moderate exercise 3-5 days/week)
  - 💪 Very Active (hard exercise 6-7 days/week)
  - 🔥 Extremely Active (athlete/physical job)
- [Continue]

**Screen 6: Goal**
- Otter thinking pose
- "What's your goal?"
- Three large visual cards:
  - 📉 Lose Weight
  - ⚖️ Maintain Weight
  - 📈 Gain Weight
- [Continue]

**Screen 7: Your Plan**
- Otter celebrating
- "Here's your personalized plan!"
- Show calculated:
  - Daily calorie target (large number)
  - Macro breakdown (P/C/F)
- Brief explanation of how it was calculated
- [Start Tracking] → Home Screen

### 2. Home Screen (Main Interface)

**Layout (top to bottom):**

```
┌─────────────────────────────────────┐
│ [Otto logo]  Today  [🔥 streak] [⚙️] │
├─────────────────────────────────────┤
│                                     │
│  [Food entry 1]           180 cal   │
│  [Food entry 2]          Thinking   │
│  [Food entry 3]      ✨ 620 cal     │
│                                     │
│  ... (scrollable list)              │
│                                     │
├─────────────────────────────────────┤
│  🔥 1,415 left  [🎤] [+] [⌨️]       │
└─────────────────────────────────────┘
```

**Components:**

**Header Bar**
- Small Otto otter icon (tappable → goes to profile)
- "Today" button (tappable → date picker for history)
- Streak badge with flame emoji (🔥 5)
- Settings gear icon

**Food Log List**
- Each entry shows:
  - Raw text input (left-aligned, primary text)
  - Calorie count (right-aligned)
  - States: "Thinking..." (processing), "✨ XXX cal" (complete)
- Tappable to expand details (bottom sheet)
- Swipe to delete

**Bottom Input Area**
- Remaining calories display: "🔥 1,415 left"
- Voice input button
- Plus button (quick add from frequent foods)
- Keyboard toggle
- Text input field (expands when focused)

**Input Behavior:**
- User types naturally: "chipotle chicken bowl with guac"
- Press enter or tap send
- Entry appears with "Thinking..." state
- AI processes → updates with calories
- Subtle success animation

### 3. Food Detail Bottom Sheet

When user taps a logged food item:

```
┌─────────────────────────────────────┐
│ ─────────── (drag handle)           │
│                           [...] [X] │
│ Chipotle chicken bowl with guac     │
├─────────────────────────────────────┤
│         🔥 785                      │
│       total calories                │
│                                     │
│   23.0g      95.0g      37.0g      │
│  🥜 Protein  🍞 Carbs   🧈 Fat     │
├─────────────────────────────────────┤
│ Found 6 sources                     │
│ [logo][logo][logo]...  6 sources ▼  │
├─────────────────────────────────────┤
│ Otto's thought process              │
│ ┌─────────────────────────────────┐ │
│ │ [75] Confidence: High           │ │
│ │                                 │ │
│ │ I found nutrition data for...   │ │
│ │ (AI explanation)                │ │
│ │                                 │ │
│ │ ✏️ Something off? Click to edit │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

**Features:**
- Expandable source list showing where data came from
- Confidence score (visual indicator)
- AI reasoning in friendly, first-person tone
- Edit option for user corrections
- More menu (...) for delete, add to favorites

### 4. Goals/Summary View

Accessible via pull-down on home screen or dedicated tab:

```
┌─────────────────────────────────────┐
│           Goals                     │
├─────────────────────────────────────┤
│ 🔥 Calories        1,116 / 1,300   │
│ ████████████░░░░                    │
│                                     │
│ 🍞 Carbs              135 / 80g    │
│ ████████████████████ (over - red)  │
│                                     │
│ 🥜 Protein            42 / 120g    │
│ ███████░░░░░░░░░                    │
│                                     │
│ 🧈 Fat                37 / 45g     │
│ ██████████████░░░                   │
└─────────────────────────────────────┘
```

**Color coding:**
- Green: Under/on target
- Yellow: Approaching limit (80-100%)
- Red: Over limit

### 5. Quick Add (Frequent Foods)

When user taps [+] button:

```
┌─────────────────────────────────────┐
│ Quick Add                       [X] │
├─────────────────────────────────────┤
│ 🔍 Search your foods...             │
├─────────────────────────────────────┤
│ Recent                              │
│                                     │
│ Owyn protein shake         180 cal  │
│ In-N-Out burger and fries  785 cal  │
│ Shin ramen with two eggs   620 cal  │
│                                     │
│ Most Used                           │
│                                     │
│ Morning coffee              15 cal  │
│ Greek yogurt with honey    180 cal  │
└─────────────────────────────────────┘
```

### 6. Settings Screen

```
┌─────────────────────────────────────┐
│ ← Settings                          │
├─────────────────────────────────────┤
│ Profile                             │
│ ┌─────────────────────────────────┐ │
│ │ Edit Goals & Targets        →   │ │
│ │ Update Body Stats           →   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ Account                             │
│ ┌─────────────────────────────────┐ │
│ │ Backup Account (Google)     →   │ │
│ │ Subscription              Pro → │ │
│ └─────────────────────────────────┘ │
│                                     │
│ App                                 │
│ ┌─────────────────────────────────┐ │
│ │ Notifications              ON   │ │
│ │ Export Data (CSV)           →   │ │
│ │ Send Feedback               →   │ │
│ └─────────────────────────────────┘ │
│                                     │
│ About                               │
│ ┌─────────────────────────────────┐ │
│ │ Privacy Policy              →   │ │
│ │ Terms of Service            →   │ │
│ │ Version 1.0.0                   │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

### 7. Paywall Screen

Shown after trial expires or when accessing premium features:

```
┌─────────────────────────────────────┐
│                              [X]    │
│                                     │
│         [Otter celebration]         │
│                                     │
│      Unlock Otto Pro 🦦✨           │
│                                     │
│   Track unlimited foods with AI     │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │ ✓ Unlimited food logging        │ │
│ │ ✓ AI-powered nutrition data     │ │
│ │ ✓ Detailed macro tracking       │ │
│ │ ✓ Export your data              │ │
│ │ ✓ Priority support              │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │  BEST VALUE                     │ │
│ │  $79.99/year                    │ │
│ │  (Save 17%)                     │ │
│ └─────────────────────────────────┘ │
│                                     │
│ ┌─────────────────────────────────┐ │
│ │  $7.99/month                    │ │
│ └─────────────────────────────────┘ │
│                                     │
│        [Start Free Trial]           │
│     5 days free, cancel anytime     │
│                                     │
│   Restore Purchase                  │
└─────────────────────────────────────┘
```

---

## AI Integration

### Food Parsing Flow

```
User Input: "2/3 chipotle chicken bowl with most toppings"
                              ↓
                    ┌─────────────────┐
                    │ Gemini 2.5 Flash│
                    │    Lite         │
                    └────────┬────────┘
                              ↓
              Parse into structured query:
              - Restaurant: Chipotle
              - Item: Chicken Bowl
              - Portion: 2/3
              - Modifiers: most toppings
                              ↓
                    ┌─────────────────┐
                    │ Perplexity      │
                    │    Sonar        │
                    └────────┬────────┘
                              ↓
              Search for nutrition data:
              - Chipotle official nutrition
              - Cross-reference databases
              - Return with sources
                              ↓
                    ┌─────────────────┐
                    │ Gemini 2.5 Flash│
                    │    Lite         │
                    └────────┬────────┘
                              ↓
              Final calculation:
              - Adjust for portion (2/3)
              - Account for toppings
              - Generate explanation
              - Confidence score
                              ↓
                    Return to app
```

### Gemini Prompt Template

```
You are Otto, a friendly nutrition assistant. Parse this food entry and estimate its nutritional content.

User input: "{user_input}"

Context from Perplexity search:
{perplexity_results}

Respond in JSON format:
{
  "food_name": "cleaned up food name",
  "calories": number,
  "protein_g": number,
  "carbs_g": number,
  "fat_g": number,
  "confidence_score": 0-100,
  "reasoning": "Brief, friendly explanation of how you calculated this. Write in first person as Otto. Keep it conversational and helpful.",
  "items_breakdown": [
    {"name": "item 1", "calories": number},
    {"name": "item 2", "calories": number}
  ]
}

Guidelines:
- If portion size mentioned, adjust accordingly
- If restaurant specified, use their official nutrition data when available
- Round calories to nearest 5
- Round macros to one decimal place
- Be conservative with estimates when uncertain
- Lower confidence score if data is unclear or estimated
```

### Perplexity Sonar Query Template

```
Search for accurate nutrition information: "{food_description}"

Include:
- Official restaurant nutrition data if applicable
- USDA database values
- Reputable nutrition sources

Return calorie count and macronutrients (protein, carbs, fat) with source URLs.
```

---

## Micro-interactions & Animations

### Essential Animations

1. **Food Entry Processing**
   - Subtle shimmer/pulse on "Thinking..." text
   - Smooth transition to calorie display
   - Brief sparkle (✨) animation on completion

2. **Streak Counter**
   - Flame flicker animation
   - Celebratory burst on milestone (7, 30, 100 days)

3. **Progress Bars**
   - Smooth fill animation
   - Color transition as approaching/exceeding limit

4. **Otter Mascot**
   - Gentle floating/bobbing in onboarding
   - Blink animation (occasional)
   - Reaction animations for achievements

5. **Pull-to-Refresh**
   - Otto diving down animation
   - Splash when releasing

6. **Button Feedback**
   - Soft haptic feedback
   - Subtle scale animation on press

7. **Page Transitions**
   - Smooth slide transitions
   - Shared element transitions where appropriate

### Haptic Feedback Points
- Button presses
- Successful food log
- Swipe to delete
- Streak increment
- Achievement unlock

---

## File Structure

```
otto/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── colors.dart
│   │   │   ├── typography.dart
│   │   │   └── dimensions.dart
│   │   ├── theme/
│   │   │   └── app_theme.dart
│   │   ├── utils/
│   │   │   ├── tdee_calculator.dart
│   │   │   └── date_utils.dart
│   │   └── extensions/
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user.dart
│   │   │   ├── food_log.dart
│   │   │   ├── daily_summary.dart
│   │   │   └── frequent_food.dart
│   │   ├── repositories/
│   │   │   ├── user_repository.dart
│   │   │   ├── food_repository.dart
│   │   │   └── streak_repository.dart
│   │   └── services/
│   │       ├── supabase_service.dart
│   │       ├── gemini_service.dart
│   │       ├── perplexity_service.dart
│   │       └── revenuecat_service.dart
│   │
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── controllers/
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── food_entry_card.dart
│   │   │   │   ├── calorie_input_bar.dart
│   │   │   │   ├── streak_badge.dart
│   │   │   │   └── goals_summary.dart
│   │   │   └── controllers/
│   │   ├── food_detail/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   ├── quick_add/
│   │   ├── settings/
│   │   ├── paywall/
│   │   └── history/
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── otto_mascot.dart
│   │   │   ├── progress_bar.dart
│   │   │   └── loading_shimmer.dart
│   │   └── animations/
│   │
│   └── providers/
│       ├── user_provider.dart
│       ├── food_log_provider.dart
│       └── subscription_provider.dart
│
├── assets/
│   ├── images/
│   │   └── otto/
│   │       ├── otto_waving.png
│   │       ├── otto_floating.png
│   │       └── ...
│   ├── animations/
│   │   └── otto/
│   │       ├── otto_waving.json (Lottie)
│   │       └── ...
│   └── fonts/
│       ├── Nunito/
│       └── SpaceMono/
│
├── test/
├── android/
├── pubspec.yaml
└── README.md
```

---

## Dependencies (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # Backend
  supabase_flutter: ^2.0.0
  
  # Payments
  purchases_flutter: ^6.0.0  # RevenueCat
  
  # HTTP & API
  dio: ^5.0.0
  
  # Local Storage
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  
  # UI Components
  google_fonts: ^6.0.0
  flutter_svg: ^2.0.0
  cached_network_image: ^3.3.0
  
  # Animations
  lottie: ^2.7.0
  rive: ^0.12.0
  flutter_animate: ^4.0.0
  
  # Utilities
  uuid: ^4.0.0
  intl: ^0.18.0
  url_launcher: ^6.0.0
  
  # Feedback
  # UserJot integration via WebView or REST API

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
  build_runner: ^2.4.0
  hive_generator: ^2.0.0
```

---

## TDEE Calculation

```dart
// Mifflin-St Jeor Equation
double calculateBMR(double weightKg, double heightCm, int age, String gender) {
  if (gender == 'male') {
    return (10 * weightKg) + (6.25 * heightCm) - (5 * age) + 5;
  } else {
    return (10 * weightKg) + (6.25 * heightCm) - (5 * age) - 161;
  }
}

double calculateTDEE(double bmr, String activityLevel) {
  final multipliers = {
    'sedentary': 1.2,
    'light': 1.375,
    'moderate': 1.55,
    'active': 1.725,
    'very_active': 1.9,
  };
  return bmr * (multipliers[activityLevel] ?? 1.2);
}

int calculateCalorieTarget(double tdee, String goal) {
  switch (goal) {
    case 'lose':
      return (tdee - 500).round(); // 500 cal deficit
    case 'gain':
      return (tdee + 300).round(); // 300 cal surplus
    default:
      return tdee.round();
  }
}

// Macro targets (can be adjusted)
Map<String, int> calculateMacros(int calories, String goal) {
  // Protein: 0.8-1g per lb body weight, or ~30% of calories
  // For simplicity, using percentage-based:
  
  double proteinPercent, carbPercent, fatPercent;
  
  switch (goal) {
    case 'lose':
      proteinPercent = 0.35; // Higher protein for muscle retention
      fatPercent = 0.30;
      carbPercent = 0.35;
      break;
    case 'gain':
      proteinPercent = 0.25;
      fatPercent = 0.25;
      carbPercent = 0.50; // More carbs for energy
      break;
    default:
      proteinPercent = 0.30;
      fatPercent = 0.30;
      carbPercent = 0.40;
  }
  
  return {
    'protein_g': ((calories * proteinPercent) / 4).round(),
    'carbs_g': ((calories * carbPercent) / 4).round(),
    'fat_g': ((calories * fatPercent) / 9).round(),
  };
}
```

---

## Environment Variables

```
# .env (DO NOT COMMIT)
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
GEMINI_API_KEY=your_gemini_api_key
PERPLEXITY_API_KEY=your_perplexity_api_key
REVENUECAT_API_KEY=your_revenuecat_api_key
USERJOT_PROJECT_ID=your_userjot_project_id
```

---

## MVP Checklist

### Phase 1: Core (MVP)
- [ ] Project setup with Flutter
- [ ] Supabase integration with anonymous auth
- [ ] Onboarding flow (6-7 screens)
- [ ] TDEE calculation
- [ ] Home screen with food list
- [ ] Natural language food input
- [ ] Gemini + Perplexity AI integration
- [ ] Food detail bottom sheet with sources
- [ ] Daily calorie/macro tracking
- [ ] Basic streak tracking

### Phase 2: Monetization
- [ ] RevenueCat integration
- [ ] Trial tracking
- [ ] Paywall screen
- [ ] Subscription management

### Phase 3: Polish
- [ ] Otter illustrations (placeholder → final)
- [ ] Lottie animations
- [ ] Micro-interactions
- [ ] Haptic feedback
- [ ] UserJot feedback integration

### Phase 4: Enhancement
- [ ] Quick add from frequent foods
- [ ] History/calendar view
- [ ] Weekly summary
- [ ] Data export (CSV)
- [ ] Edit/correct food entries

### Future (Post-MVP)
- [ ] Photo food recognition
- [ ] Offline mode with queue
- [ ] iOS version
- [ ] Widgets
- [ ] Apple Health / Google Fit integration

---

## Notes for Development

1. **Start with static UI first** - Build all screens with hardcoded data before integrating APIs
2. **Use placeholder otter images** - Don't block on illustrations, use simple placeholders initially
3. **Test AI integration separately** - Create a test harness for Gemini + Perplexity before integrating into app
4. **Implement error states** - Every API call needs loading, success, and error states
5. **Cache aggressively** - Store AI responses locally to reduce API costs
6. **Rate limit AI calls** - Implement debouncing on input to prevent excessive API usage

---

## Design References

- Amy (attached screenshots) - Notes-style input, source citations, thought process display
- Minimalist calorie trackers - Clean UI inspiration
- Duolingo - Playful mascot integration, streak mechanics
- Notion - Clean typography and spacing
