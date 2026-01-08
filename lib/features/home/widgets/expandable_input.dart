import 'package:flutter/material.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Expandable input widget for food logging
///
/// Based on otto-spec.md lines 326-335
/// Features:
/// - Animates input field expanding upward when focused
/// - Auto-focus text field when expanded
/// - Show send button when expanded
/// - Press enter or send button to submit
/// - Collapse after submission
/// - Handle keyboard appearance smoothly
class ExpandableInput extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;
  final VoidCallback? onVoicePressed;
  final VoidCallback? onQuickAddPressed;
  final int caloriesLeft;
  final bool initiallyExpanded;

  const ExpandableInput({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.onVoicePressed,
    this.onQuickAddPressed,
    required this.caloriesLeft,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableInput> createState() => _ExpandableInputState();
}

class _ExpandableInputState extends State<ExpandableInput>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;
  late FocusNode _focusNode;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus && !_isExpanded) {
      _expand();
    }
  }

  void _expand() {
    setState(() => _isExpanded = true);
    _animationController.forward();
    _focusNode.requestFocus();
  }

  void _collapse() {
    _focusNode.unfocus();
    _animationController.reverse().then((_) {
      setState(() => _isExpanded = false);
    });
  }

  void _handleSubmit() {
    if (widget.controller.text.trim().isEmpty) return;

    widget.onSubmit();
    _collapse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.textSecondary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ]
            : null,
      ),
      child: SafeArea(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Expanded text area
                if (_heightAnimation.value > 0)
                  SizeTransition(
                    sizeFactor: _heightAnimation,
                    axisAlignment: -1,
                    child: FadeTransition(
                      opacity: _opacityAnimation,
                      child: _buildExpandedInput(),
                    ),
                  ),

                // Compact bar (always visible)
                _buildCompactBar(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build the expanded text input area
  Widget _buildExpandedInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacingM,
        AppDimensions.spacingM,
        AppDimensions.spacingM,
        AppDimensions.spacingS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'What did you eat?',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: _collapse,
                color: AppColors.textSecondary,
                iconSize: 20,
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacingS),
          // Text input field
          TextField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLines: 3,
            minLines: 1,
            textInputAction: TextInputAction.send,
            onSubmitted: (_) => _handleSubmit(),
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: 'e.g., "chipotle chicken bowl with guac"',
              hintStyle: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.all(AppDimensions.spacingM),
            ),
          ),
          const SizedBox(height: AppDimensions.spacingM),
          // Submit button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.controller.text.trim().isNotEmpty
                  ? _handleSubmit
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppDimensions.spacingM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, size: 20),
                  const SizedBox(width: AppDimensions.spacingS),
                  Text(
                    'Log Food',
                    style: AppTypography.button,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build the compact bottom bar (always visible)
  Widget _buildCompactBar() {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Row(
        children: [
          // Calories remaining
          Expanded(
            child: GestureDetector(
              onTap: _expand,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                decoration: BoxDecoration(
                  color: _isExpanded
                      ? Colors.transparent
                      : AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Row(
                  children: [
                    Text(
                      '🔥',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Text(
                      '${widget.caloriesLeft} left',
                      style: AppTypography.headlineSmall.copyWith(
                        color: _getCaloriesColor(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Action buttons
          if (!_isExpanded) ...[
            // Voice input button
            if (widget.onVoicePressed != null)
              IconButton(
                icon: const Icon(Icons.mic_outlined),
                onPressed: widget.onVoicePressed,
                color: AppColors.primary,
              ),
            // Quick add button
            if (widget.onQuickAddPressed != null)
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: widget.onQuickAddPressed,
                color: AppColors.primary,
              ),
            // Keyboard/expand button
            IconButton(
              icon: const Icon(Icons.keyboard),
              onPressed: _expand,
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }

  /// Get color for calories remaining text
  Color _getCaloriesColor() {
    if (widget.caloriesLeft < 0) {
      return AppColors.error;
    } else if (widget.caloriesLeft < 200) {
      return AppColors.progressYellow;
    }
    return AppColors.primary;
  }
}
