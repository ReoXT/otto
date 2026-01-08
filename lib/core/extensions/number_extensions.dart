import 'dart:math';
import 'package:intl/intl.dart';

extension IntExtensions on int {
  String get formatted => NumberFormat.decimalPattern().format(this);

  String get asCalories => '${NumberFormat.decimalPattern().format(this)} cal';
}

extension DoubleExtensions on double {
  double roundTo(int places) {
    final factor = pow(10, places).toDouble();
    return (this * factor).round() / factor;
  }

  String get asGrams {
    // Show one decimal if needed
    if (this == roundTo(0)) {
      return '${toInt()}g';
    }
    return '${toStringAsFixed(1)}g';
  }
}
