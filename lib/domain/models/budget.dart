/// Enum representing budget period.
enum BudgetPeriod {
  /// Monthly budget period.
  monthly,
}

/// Domain model representing a category Budget.
class Budget {
  /// Creates a [Budget].
  const Budget({
    required this.id,
    required this.categoryId,
    required this.amountMinor,
    this.currency = 'PKR',
    this.period = BudgetPeriod.monthly,
    this.hasRollover = false,
  });

  /// Creates a [Budget] from JSON.
  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      amountMinor: json['amountMinor'] as int,
      currency: json['currency'] as String? ?? 'PKR',
      period: BudgetPeriod.values.firstWhere(
        (value) => value.name == (json['period'] as String? ?? 'monthly'),
        orElse: () => BudgetPeriod.monthly,
      ),
      hasRollover: json['hasRollover'] as bool? ?? false,
    );
  }

  /// Unique budget id.
  final String id;

  /// Category this budget applies to.
  final String categoryId;

  /// Budget amount in minor units.
  final int amountMinor;

  /// ISO currency code.
  final String currency;

  /// Budget period.
  final BudgetPeriod period;

  /// Whether the budget can roll over.
  final bool hasRollover;

  /// Serializes the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'amountMinor': amountMinor,
      'currency': currency,
      'period': period.name,
      'hasRollover': hasRollover,
    };
  }

  /// Creates a copy of this budget with selected fields replaced.
  Budget copyWith({
    String? id,
    String? categoryId,
    int? amountMinor,
    String? currency,
    BudgetPeriod? period,
    bool? hasRollover,
  }) {
    return Budget(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      amountMinor: amountMinor ?? this.amountMinor,
      currency: currency ?? this.currency,
      period: period ?? this.period,
      hasRollover: hasRollover ?? this.hasRollover,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Budget &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            categoryId == other.categoryId &&
            amountMinor == other.amountMinor &&
            currency == other.currency &&
            period == other.period &&
            hasRollover == other.hasRollover;
  }

  @override
  int get hashCode {
    return Object.hash(id, categoryId, amountMinor, currency, period, hasRollover);
  }
}
