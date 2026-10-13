import 'package:freezed_annotation/freezed_annotation.dart';

part 'budget.freezed.dart';
part 'budget.g.dart';

/// Enum representing budget period.
enum BudgetPeriod {
  /// Monthly budget period.
  monthly,
}

/// Domain model representing a category Budget.
@freezed
class Budget with _$Budget {
  /// Creates a [Budget].
  const factory Budget({
    required String id,
    required String categoryId,
    required int amountMinor,
    @Default('PKR') String currency,
    @Default(BudgetPeriod.monthly) BudgetPeriod period,
    @Default(false) bool hasRollover,
  }) = _Budget;

  /// Creates a [Budget] from JSON.
  factory Budget.fromJson(Map<String, dynamic> json) =>
      _$BudgetFromJson(json);

  @override
  // TODO: implement amountMinor
  int get amountMinor => throw UnimplementedError();

  @override
  // TODO: implement categoryId
  String get categoryId => throw UnimplementedError();

  @override
  // TODO: implement currency
  String get currency => throw UnimplementedError();

  @override
  // TODO: implement hasRollover
  bool get hasRollover => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement period
  BudgetPeriod get period => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
