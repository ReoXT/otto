import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/core/router/app_router.dart';
import 'package:otto/features/settings/widgets/settings_section.dart';
import 'package:otto/features/settings/widgets/settings_list_tile.dart';
import 'package:otto/providers/local_storage_provider.dart';

/// Settings screen showing all app settings
///
/// Based on otto-spec.md lines 425-456
/// Sections:
/// - Profile (Edit Goals & Targets, Update Body Stats)
/// - Account (Backup Account, Subscription)
/// - App (Notifications, Export Data, Send Feedback)
/// - About (Privacy Policy, Terms of Service, Version)
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: AppColors.textPrimary,
        ),
        title: Text(
          'Settings',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            SettingsSection(
              title: 'PROFILE',
              children: [
                SettingsListTile(
                  title: 'Edit Goals & Targets',
                  subtitle: 'Adjust your calorie and macro targets',
                  leading: const Icon(
                    Icons.track_changes,
                    color: AppColors.primary,
                  ),
                  onTap: () => _navigateToEditGoals(context),
                ),
                SettingsListTile(
                  title: 'Update Body Stats',
                  subtitle: 'Change weight, height, activity level',
                  leading: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                  onTap: () => _navigateToEditProfile(context),
                ),
              ],
            ),

            // Account Section
            SettingsSection(
              title: 'ACCOUNT',
              children: [
                SettingsListTile(
                  title: 'Backup Account',
                  subtitle: 'Link with Google to sync data',
                  leading: const Icon(
                    Icons.cloud_outlined,
                    color: AppColors.primary,
                  ),
                  onTap: () => _showComingSoon(context, 'Backup Account'),
                ),
                userAsync.when(
                  data: (user) {
                    final isTrialUser = user?.subscriptionStatus == 'trial';
                    return SettingsBadgeTile(
                      title: 'Subscription',
                      subtitle: isTrialUser
                          ? 'Free trial active'
                          : 'Manage your subscription',
                      leading: const Icon(
                        Icons.star_outline,
                        color: AppColors.secondary,
                      ),
                      badgeText: isTrialUser ? 'Trial' : 'Pro',
                      badgeColor: isTrialUser
                          ? AppColors.progressYellow
                          : AppColors.secondary,
                      onTap: () => Navigator.of(context).pushNamed(AppRoutes.paywall),
                    );
                  },
                  loading: () => const SettingsListTile(
                    title: 'Subscription',
                    subtitle: 'Loading...',
                    leading: Icon(
                      Icons.star_outline,
                      color: AppColors.secondary,
                    ),
                  ),
                  error: (error, _) => const SettingsListTile(
                    title: 'Subscription',
                    leading: Icon(
                      Icons.star_outline,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),

            // App Section
            SettingsSection(
              title: 'APP',
              children: [
                userAsync.when(
                  data: (user) => SettingsSwitchTile(
                    title: 'Notifications',
                    subtitle: 'Daily reminders and updates',
                    leading: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primary,
                    ),
                    value: user?.notificationsEnabled ?? true,
                    onChanged: (value) => _toggleNotifications(ref, value),
                  ),
                  loading: () => const SettingsSwitchTile(
                    title: 'Notifications',
                    subtitle: 'Daily reminders and updates',
                    leading: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primary,
                    ),
                    value: true,
                    onChanged: null,
                  ),
                  error: (error, _) => const SettingsSwitchTile(
                    title: 'Notifications',
                    subtitle: 'Daily reminders and updates',
                    leading: Icon(
                      Icons.notifications_outlined,
                      color: AppColors.primary,
                    ),
                    value: true,
                    onChanged: null,
                  ),
                ),
                SettingsListTile(
                  title: 'Export Data',
                  subtitle: 'Download your food logs as CSV',
                  leading: const Icon(
                    Icons.download_outlined,
                    color: AppColors.primary,
                  ),
                  onTap: () => _showComingSoon(context, 'Export Data'),
                ),
                SettingsListTile(
                  title: 'Send Feedback',
                  subtitle: 'Help us improve Otto',
                  leading: const Icon(
                    Icons.feedback_outlined,
                    color: AppColors.primary,
                  ),
                  onTap: () => _showComingSoon(context, 'Feedback'),
                ),
              ],
            ),

            // About Section
            SettingsSection(
              title: 'ABOUT',
              children: [
                SettingsListTile(
                  title: 'Privacy Policy',
                  leading: const Icon(
                    Icons.privacy_tip_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () => _showComingSoon(context, 'Privacy Policy'),
                ),
                SettingsListTile(
                  title: 'Terms of Service',
                  leading: const Icon(
                    Icons.description_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onTap: () => _showComingSoon(context, 'Terms of Service'),
                ),
                const SettingsListTile(
                  title: 'Version',
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                  leading: Icon(
                    Icons.info_outline,
                    color: AppColors.textSecondary,
                  ),
                  showArrow: false,
                ),
              ],
            ),

            const SizedBox(height: AppDimensions.spacingXxl),
          ],
        ),
      ),
    );
  }

  void _navigateToEditGoals(BuildContext context) {
    // TODO: Navigate to edit goals screen
    _showComingSoon(context, 'Edit Goals');
  }

  void _navigateToEditProfile(BuildContext context) {
    // TODO: Navigate to edit profile screen
    _showComingSoon(context, 'Edit Profile');
  }

  Future<void> _toggleNotifications(WidgetRef ref, bool value) async {
    // TODO: Update user notification preferences
    final localStorage = ref.read(localStorageServiceProvider);
    final user = await localStorage.getUser();
    if (user != null) {
      final updatedUser = user.copyWith(notificationsEnabled: value);
      await localStorage.saveUser(updatedUser);
      ref.invalidate(currentUserProvider);
    }
  }

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
