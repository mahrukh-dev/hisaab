import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

/// Immutable value object representing money as integer minor units.
///
/// Amounts are stored as integers (e.g. PKR 12.50 = 1250 minor units).
@immutable
class Money implements Comparable<Money> {
  /// Creates a [Money] instance with [minorUnits] and [currency].
  const Money(
    this.minorUnits, {
    this.currency = defaultCurrency,
  });

  /// Returns a zero amount for the specified [currency].
  factory Money.zero([String currency = defaultCurrency]) {
    return Money(0, currency: currency);
  }

  /// Parses a string representation of money into a [Money] instance.
  ///
  /// Handles formats like "1,250.50", "1250.5", "-500", "PKR 1200".
  factory Money.parse(
    String input, {
    String currency = defaultCurrency,
    int decimalDigits = 2,
  }) {
    final cleanInput = input.trim().replaceAll(',', '');
    final isNegative = cleanInput.contains('-');
    final regex = RegExp(r'(\d+(?:\.\d+)?)');
    final match = regex.firstMatch(cleanInput);

    if (match == null) {
      throw FormatException('Invalid money format: "$input"');
    }

    final numberStr = match.group(1)!;
    final parts = numberStr.split('.');

    final mainUnits = int.parse(parts[0]);
    var minor = 0;

    if (parts.length > 1) {
      var fractionStr = parts[1];
      if (fractionStr.length > decimalDigits) {
        fractionStr = fractionStr.substring(0, decimalDigits);
      } else {
        fractionStr = fractionStr.padRight(decimalDigits, '0');
      }
      minor = int.parse(fractionStr);
    }

    var totalMinor = (mainUnits * _powerOfTen(decimalDigits)) + minor;
    if (isNegative) {
      totalMinor = -totalMinor;
    }

    return Money(totalMinor, currency: currency);
  }

  /// Default currency code for the application.
  static const String defaultCurrency = 'PKR';

  /// The amount in minor units (e.g. cents, paise).
  final int minorUnits;

  /// The ISO 4217 currency code (e.g., 'PKR', 'USD').
  final String currency;

  static int _powerOfTen(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }

  /// Adds [other] to this money instance.
  Money operator +(Money other) {
    _checkSameCurrency(other);
    return Money(minorUnits + other.minorUnits, currency: currency);
  }

  /// Subtracts [other] from this money instance.
  Money operator -(Money other) {
    _checkSameCurrency(other);
    return Money(minorUnits - other.minorUnits, currency: currency);
  }

  /// Negates the money amount.
  Money operator -() {
    return Money(-minorUnits, currency: currency);
  }

  /// Multiplies the money amount by a scalar factor.
  Money multiplyBy(num factor) {
    return Money((minorUnits * factor).round(), currency: currency);
  }

  /// Allocates the money amount into parts proportional to [ratios].
  ///
  /// Guarantees that the sum of the allocated parts strictly equals
  /// [minorUnits] without losing or creating minor units. Remainder units
  /// are distributed 1 unit at a time to the leading parts.
  List<Money> allocate(List<int> ratios) {
    if (ratios.isEmpty) {
      throw ArgumentError('Ratios list cannot be empty.');
    }
    for (final ratio in ratios) {
      if (ratio < 0) {
        throw ArgumentError('Ratios must be non-negative: $ratio');
      }
    }

    final totalRatio = ratios.reduce((a, b) => a + b);
    if (totalRatio == 0) {
      throw ArgumentError('Sum of ratios must be greater than zero.');
    }

    final results = <int>[];
    var remainder = minorUnits;

    for (var i = 0; i < ratios.length; i++) {
      final part = (minorUnits * ratios[i]) ~/ totalRatio;
      results.add(part);
      remainder -= part;
    }

    // Distribute remainder 1 minor unit at a time to the first parts
    for (var i = 0; i < remainder; i++) {
      results[i % ratios.length] += 1;
    }

    return results.map((units) => Money(units, currency: currency)).toList();
  }

  /// Formats the money instance as a readable currency string.
  String format({
    String? locale,
    bool includeSymbol = true,
    int decimalDigits = 2,
  }) {
    final mainAmount = minorUnits / _powerOfTen(decimalDigits);
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: includeSymbol ? _getSymbol(currency) : '',
      decimalDigits: decimalDigits,
    );
    return formatter.format(mainAmount).trim();
  }

  static String _getSymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'PKR':
        return 'Rs.';
      case 'USD':
        return r'$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      default:
        return '$currency ';
    }
  }

  void _checkSameCurrency(Money other) {
    if (currency != other.currency) {
      throw ArgumentError(
        'Currency mismatch: cannot combine $currency and ${other.currency}',
      );
    }
  }

  /// Less than comparison.
  bool operator <(Money other) {
    _checkSameCurrency(other);
    return minorUnits < other.minorUnits;
  }

  /// Less than or equal comparison.
  bool operator <=(Money other) {
    _checkSameCurrency(other);
    return minorUnits <= other.minorUnits;
  }

  /// Greater than comparison.
  bool operator >(Money other) {
    _checkSameCurrency(other);
    return minorUnits > other.minorUnits;
  }

  /// Greater than or equal comparison.
  bool operator >=(Money other) {
    _checkSameCurrency(other);
    return minorUnits >= other.minorUnits;
  }

  @override
  int compareTo(Money other) {
    _checkSameCurrency(other);
    return minorUnits.compareTo(other.minorUnits);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Money &&
          runtimeType == other.runtimeType &&
          minorUnits == other.minorUnits &&
          currency == other.currency;

  @override
  int get hashCode => minorUnits.hashCode ^ currency.hashCode;

  @override
  String toString() => '$currency $minorUnits minorUnits';
}
