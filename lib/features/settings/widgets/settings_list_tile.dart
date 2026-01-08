import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Settings list tile widget with consistent styling
///
/// Based on otto-spec.md lines 425-456
/// Features:
/// - Title and optional subtitle
/// - Optional leading widget (icon)
/// - Optional trailing widget or arrow
/// - Tap handling
/// - Consistent styling across all settings items
class SettingsListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showArrow;

  const SettingsListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingM,
        ),
        child: Row(
          children: [
            // Leading widget (icon)
            if (leading != null) ...[
              leading!,
              const SizedBox(width: AppDimensions.spacingM),
            ],
            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimensions.spacingXs),
                    Text(
                      subtitle!,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Trailing widget or arrow
            if (trailing != null)
              trailing!
            else if (onTap != null && showArrow)
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
          ],
        ),
      ),
    );
  }
}

/// Settings switch tile with toggle
class SettingsSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const SettingsSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      showArrow: false,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
        activeThumbColor: AppColors.primary,
      ),
      onTap: onChanged != null ? () => onChanged!(!value) : null,
    );
  }
}

/// Settings tile with badge (like "Pro")
class SettingsBadgeTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final String badgeText;
  final Color? badgeColor;
  final VoidCallback? onTap;

  const SettingsBadgeTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.badgeText,
    this.badgeColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXs,
        ),
        decoration: BoxDecoration(
          color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Text(
          badgeText,
          style: AppTypography.label.copyWith(
            color: badgeColor ?? AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

/// Settings tile with value displayed
class SettingsValueTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final String value;
  final VoidCallback? onTap;

  const SettingsValueTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: AppDimensions.spacingS),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ],
      ),
      showArrow: false,
    );
  }
}
