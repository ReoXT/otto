import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Settings section widget grouping related settings
///
/// Based on otto-spec.md lines 425-456
/// Features:
/// - Section header text
/// - Card containing children list tiles
/// - Dividers between items
class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          const EdgeInsets.only(
            top: AppDimensions.spacingL,
            left: AppDimensions.spacingM,
            right: AppDimensions.spacingM,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.spacingS,
              bottom: AppDimensions.spacingS,
            ),
            child: Text(
              title,
              style: AppTypography.label.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          // Card with children
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: _buildChildrenWithDividers(),
            ),
          ),
        ],
      ),
    );
  }

  /// Build children with dividers between them
  List<Widget> _buildChildrenWithDividers() {
    if (children.isEmpty) return [];

    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);

      // Add divider if not the last item
      if (i < children.length - 1) {
        result.add(
          Divider(
            height: 1,
            indent: AppDimensions.spacingM,
            endIndent: AppDimensions.spacingM,
            color: AppColors.textSecondary.withValues(alpha: 0.1),
          ),
        );
      }
    }

    return result;
  }
}

/// Simple settings group without card styling
class SettingsGroup extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const SettingsGroup({
    super.key,
    this.title,
    required this.children,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin ??
          const EdgeInsets.only(
            top: AppDimensions.spacingM,
            left: AppDimensions.spacingM,
            right: AppDimensions.spacingM,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional title
          if (title != null) ...[
            Padding(
              padding: const EdgeInsets.only(
                left: AppDimensions.spacingS,
                bottom: AppDimensions.spacingS,
              ),
              child: Text(
                title!,
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
          // Children
          ...children,
        ],
      ),
    );
  }
}
