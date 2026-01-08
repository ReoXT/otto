import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/features/home/widgets/streak_badge.dart';

/// Custom AppBar for Home Screen
///
/// Based on otto-spec.md lines 309-313 (Header Bar)
/// Layout:
/// - Left: Small Otto otter icon (tappable → profile)
/// - Center: "Today" button (tappable → date picker)
/// - Right: Streak badge + Settings icon
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback when Otto icon is tapped (navigate to profile)
  final VoidCallback? onOttoIconTap;

  /// Callback when "Today" button is tapped (show date picker)
  final VoidCallback? onTodayTap;

  /// Callback when settings icon is tapped
  final VoidCallback? onSettingsTap;

  /// Current streak count to display
  final int streakCount;

  const HomeAppBar({
    super.key,
    this.onOttoIconTap,
    this.onTodayTap,
    this.onSettingsTap,
    this.streakCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          // Left: Otto icon
          GestureDetector(
            onTap: onOttoIconTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.water_drop,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ),

          const Spacer(),

          // Center: "Today" pill button
          GestureDetector(
            onTap: onTodayTap,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.md,
                vertical: AppDimensions.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Today',
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.xs),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Right: Streak badge + Settings icon
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreakBadge(streakCount: streakCount),
              const SizedBox(width: AppDimensions.sm),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: onSettingsTap,
                color: AppColors.textPrimary,
                iconSize: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
