import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/data/models/food_log.dart';

/// Sources display widget showing where nutrition data came from
///
/// Based on otto-spec.md lines 353-354, 369
/// Features:
/// - "Found {n} sources" header
/// - Row of source logos/icons (first 3-5)
/// - Expandable to show full list with names and links
/// - Links open in browser
class SourcesDisplay extends StatefulWidget {
  final List<FoodSource> sources;

  const SourcesDisplay({
    super.key,
    required this.sources,
  });

  @override
  State<SourcesDisplay> createState() => _SourcesDisplayState();
}

class _SourcesDisplayState extends State<SourcesDisplay> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.sources.isEmpty) {
      return _buildNoSources();
    }

    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with count
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Found ${widget.sources.length} ${widget.sources.length == 1 ? 'source' : 'sources'}',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (widget.sources.length > 3)
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _isExpanded ? 'Show less' : 'View all',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingM),

          // Source list
          _isExpanded
              ? _buildExpandedSources()
              : _buildCompactSources(),
        ],
      ),
    );
  }

  /// Build compact view showing first 3-5 sources as icons/chips
  Widget _buildCompactSources() {
    final displaySources = widget.sources.take(5).toList();

    return Wrap(
      spacing: AppDimensions.spacingS,
      runSpacing: AppDimensions.spacingS,
      children: displaySources.map((source) {
        return _SourceChip(source: source);
      }).toList(),
    );
  }

  /// Build expanded view showing all sources with details
  Widget _buildExpandedSources() {
    return Column(
      children: widget.sources.asMap().entries.map((entry) {
        final index = entry.key;
        final source = entry.value;
        return _SourceListItem(
          source: source,
          index: index,
        );
      }).toList(),
    );
  }

  /// Build message when no sources available
  Widget _buildNoSources() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.textSecondary,
            size: 20,
          ),
          const SizedBox(width: AppDimensions.spacingS),
          Expanded(
            child: Text(
              'No sources found for this entry',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Individual source chip (compact view)
class _SourceChip extends StatelessWidget {
  final FoodSource source;

  const _SourceChip({required this.source});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(source.url),
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingM,
          vertical: AppDimensions.spacingS,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          border: Border.all(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon or logo
            if (source.logoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  source.logoUrl!,
                  width: 16,
                  height: 16,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildDefaultIcon();
                  },
                ),
              )
            else
              _buildDefaultIcon(),
            const SizedBox(width: AppDimensions.spacingS),
            // Source name
            Text(
              _truncateName(source.name, 20),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultIcon() {
    return Icon(
      Icons.link,
      size: 16,
      color: AppColors.primary,
    );
  }

  String _truncateName(String name, int maxLength) {
    if (name.length <= maxLength) return name;
    return '${name.substring(0, maxLength)}...';
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Individual source list item (expanded view)
class _SourceListItem extends StatelessWidget {
  final FoodSource source;
  final int index;

  const _SourceListItem({
    required this.source,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _launchUrl(source.url),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.spacingM,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.textSecondary.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            // Number badge
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: AppTypography.label.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingM),
            // Logo/icon
            if (source.logoUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  source.logoUrl!,
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.link,
                      size: 20,
                      color: AppColors.primary,
                    );
                  },
                ),
              )
            else
              Icon(
                Icons.link,
                size: 20,
                color: AppColors.primary,
              ),
            const SizedBox(width: AppDimensions.spacingM),
            // Source name
            Expanded(
              child: Text(
                source.name,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // External link icon
            Icon(
              Icons.open_in_new,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            duration: 200.ms,
            delay: Duration(milliseconds: index * 50),
          )
          .slideX(
            begin: 0.1,
            end: 0,
            duration: 200.ms,
            delay: Duration(milliseconds: index * 50),
          ),
    );
  }

  Future<void> _launchUrl(String? url) async {
    if (url == null) return;

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
