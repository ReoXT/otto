import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';
import 'package:otto/features/paywall/widgets/plan_card.dart';
import 'package:otto/features/paywall/widgets/feature_list_item.dart';

/// Paywall screen for Otto Pro subscription
///
/// Based on otto-spec.md lines 459-496
/// Features:
/// - Otto celebration illustration
/// - Feature list with checkmarks
/// - Yearly plan (highlighted as best value)
/// - Monthly plan
/// - Start free trial CTA
/// - Restore purchase option
class PaywallScreen extends StatefulWidget {
  final bool isDismissible;

  const PaywallScreen({
    super.key,
    this.isDismissible = true,
  });

  /// Show the paywall screen
  static Future<void> show(
    BuildContext context, {
    bool isDismissible = true,
  }) {
    return Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PaywallScreen(isDismissible: isDismissible),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  // Selected plan: 'yearly' or 'monthly'
  String _selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content (scrollable)
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingL,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppDimensions.spacingXxl),

                    // Otto celebration illustration placeholder
                    _buildIllustration(),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // Headline
                    Text(
                      'Unlock Otto Pro 🦦✨',
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimensions.spacingM),

                    // Subtitle
                    Text(
                      'Track unlimited foods with AI',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // Feature list
                    _buildFeatureList(),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // Plan cards
                    _buildPlanCards(),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // Start Free Trial button
                    _buildStartTrialButton(),

                    const SizedBox(height: AppDimensions.spacingM),

                    // Trial terms
                    Text(
                      '5 days free, cancel anytime',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppDimensions.spacingXl),

                    // Restore Purchase link
                    _buildRestorePurchaseButton(),

                    const SizedBox(height: AppDimensions.spacingXl),
                  ],
                ),
              ),
            ),

            // Close button (top right)
            if (widget.isDismissible) _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  /// Build Otto celebration illustration
  Widget _buildIllustration() {
    // TODO: Replace with actual Otto celebration illustration
    // For now, use a placeholder
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Center(
        child: Text(
          '🦦',
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }

  /// Build feature list with checkmarks
  Widget _buildFeatureList() {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: const Column(
        children: [
          FeatureListItem(text: 'Unlimited food logging'),
          SizedBox(height: AppDimensions.spacingM),
          FeatureListItem(text: 'AI-powered nutrition data'),
          SizedBox(height: AppDimensions.spacingM),
          FeatureListItem(text: 'Detailed macro tracking'),
          SizedBox(height: AppDimensions.spacingM),
          FeatureListItem(text: 'Export your data'),
          SizedBox(height: AppDimensions.spacingM),
          FeatureListItem(text: 'Priority support'),
        ],
      ),
    );
  }

  /// Build plan selection cards
  Widget _buildPlanCards() {
    return Column(
      children: [
        // Yearly plan (best value)
        PlanCard(
          title: 'Yearly',
          price: '\$79.99/year',
          badge: 'BEST VALUE',
          savings: 'Save 17%',
          isSelected: _selectedPlan == 'yearly',
          onTap: () {
            setState(() {
              _selectedPlan = 'yearly';
            });
          },
        ),

        const SizedBox(height: AppDimensions.spacingM),

        // Monthly plan
        PlanCard(
          title: 'Monthly',
          price: '\$7.99/month',
          isSelected: _selectedPlan == 'monthly',
          onTap: () {
            setState(() {
              _selectedPlan = 'monthly';
            });
          },
        ),
      ],
    );
  }

  /// Build Start Free Trial button
  Widget _buildStartTrialButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _handleStartTrial,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacingL,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          ),
          elevation: 0,
        ),
        child: Text(
          'Start Free Trial',
          style: AppTypography.button.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  /// Build Restore Purchase button
  Widget _buildRestorePurchaseButton() {
    return TextButton(
      onPressed: _handleRestorePurchase,
      child: Text(
        'Restore Purchase',
        style: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  /// Build close button
  Widget _buildCloseButton() {
    return Positioned(
      top: AppDimensions.spacingM,
      right: AppDimensions.spacingM,
      child: IconButton(
        onPressed: () => Navigator.of(context).pop(),
        icon: Icon(
          Icons.close,
          color: AppColors.textSecondary,
          size: 28,
        ),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  /// Handle start trial button press
  Future<void> _handleStartTrial() async {
    // TODO: Integrate with RevenueCat to start subscription
    // Example:
    // final purchases = RevenueCat.purchases;
    // if (_selectedPlan == 'yearly') {
    //   await purchases.purchasePackage(yearlyPackage);
    // } else {
    //   await purchases.purchasePackage(monthlyPackage);
    // }

    // For now, just show a snackbar
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Starting trial with $_selectedPlan plan...',
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Close paywall after successful purchase
    // Navigator.of(context).pop();
  }

  /// Handle restore purchase button press
  Future<void> _handleRestorePurchase() async {
    // TODO: Integrate with RevenueCat to restore purchases
    // Example:
    // final purchases = RevenueCat.purchases;
    // await purchases.restorePurchases();

    // For now, just show a snackbar
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Restoring purchases...',
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
