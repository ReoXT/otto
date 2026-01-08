import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otto/core/constants/colors.dart';
import 'package:otto/core/constants/dimensions.dart';
import 'package:otto/core/constants/typography.dart';

/// Number input field with label and unit suffix
/// Used in onboarding for age, height, and weight inputs (otto-spec.md lines 244-256)
class NumberInputField extends StatefulWidget {
  /// Label text displayed above the field
  final String label;

  /// Optional unit suffix displayed inside the field (e.g., "kg", "cm", "years")
  final String? unit;

  /// Current value
  final double? value;

  /// Minimum allowed value
  final double min;

  /// Maximum allowed value
  final double max;

  /// Callback when value changes
  final Function(double) onChanged;

  /// Whether to allow decimal values
  final bool allowDecimals;

  const NumberInputField({
    super.key,
    required this.label,
    this.unit,
    this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.allowDecimals = false,
  });

  @override
  State<NumberInputField> createState() => _NumberInputFieldState();
}

class _NumberInputFieldState extends State<NumberInputField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? _formatValue(widget.value!) : '',
    );
  }

  @override
  void didUpdateWidget(NumberInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      _controller.text = widget.value != null ? _formatValue(widget.value!) : '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatValue(double value) {
    return widget.allowDecimals ? value.toString() : value.toInt().toString();
  }

  void _handleTextChanged(String text) {
    if (text.isEmpty) {
      setState(() {
        _errorText = null;
      });
      return;
    }

    final parsedValue = double.tryParse(text);
    if (parsedValue == null) {
      setState(() {
        _errorText = 'Please enter a valid number';
      });
      return;
    }

    if (parsedValue < widget.min || parsedValue > widget.max) {
      setState(() {
        _errorText = 'Value must be between ${_formatValue(widget.min)} and ${_formatValue(widget.max)}';
      });
      return;
    }

    setState(() {
      _errorText = null;
    });
    widget.onChanged(parsedValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label,
          style: AppTypography.label.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: AppDimensions.sm),

        // Input field
        TextField(
          controller: _controller,
          keyboardType: TextInputType.numberWithOptions(
            decimal: widget.allowDecimals,
          ),
          inputFormatters: [
            if (widget.allowDecimals)
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            else
              FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: _handleTextChanged,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            suffixText: widget.unit,
            suffixStyle: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            errorText: _errorText,
            hintText: 'Enter ${widget.label.toLowerCase()}',
          ),
        ),
      ],
    );
  }
}
