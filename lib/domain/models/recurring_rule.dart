import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_rule.freezed.dart';
part 'recurring_rule.g.dart';

/// Domain model representing a Recurring Transaction Rule.
@freezed
class RecurringRule with _$RecurringRule {
  /// Creates a [RecurringRule].
  const factory RecurringRule({
    required String id,
    required String templateJson,
    required String rrule,
    required DateTime nextRunAt,
    @Default(true) bool isActive,
  }) = _RecurringRule;

  /// Creates a [RecurringRule] from JSON.
  factory RecurringRule.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleFromJson(json);

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isActive
  bool get isActive => throw UnimplementedError();

  @override
  // TODO: implement nextRunAt
  DateTime get nextRunAt => throw UnimplementedError();

  @override
  // TODO: implement rrule
  String get rrule => throw UnimplementedError();

  @override
  // TODO: implement templateJson
  String get templateJson => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
