/// Domain model representing a Recurring Transaction Rule.
class RecurringRule {
  /// Creates a [RecurringRule].
  const RecurringRule({
    required this.id,
    required this.templateJson,
    required this.rrule,
    required this.nextRunAt,
    this.isActive = true,
  });

  /// Creates a [RecurringRule] from JSON.
  factory RecurringRule.fromJson(Map<String, dynamic> json) {
    return RecurringRule(
      id: json['id'] as String,
      templateJson: json['templateJson'] as String,
      rrule: json['rrule'] as String,
      nextRunAt: DateTime.parse(json['nextRunAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Stable rule id.
  final String id;

  /// Serialized template for the recurring transaction.
  final String templateJson;

  /// RRULE expression.
  final String rrule;

  /// Next scheduled run time.
  final DateTime nextRunAt;

  /// Whether the rule is active.
  final bool isActive;

  /// Serializes the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'templateJson': templateJson,
      'rrule': rrule,
      'nextRunAt': nextRunAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  /// Creates a copy of this rule with selected fields replaced.
  RecurringRule copyWith({
    String? id,
    String? templateJson,
    String? rrule,
    DateTime? nextRunAt,
    bool? isActive,
  }) {
    return RecurringRule(
      id: id ?? this.id,
      templateJson: templateJson ?? this.templateJson,
      rrule: rrule ?? this.rrule,
      nextRunAt: nextRunAt ?? this.nextRunAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RecurringRule &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            templateJson == other.templateJson &&
            rrule == other.rrule &&
            nextRunAt == other.nextRunAt &&
            isActive == other.isActive;
  }

  @override
  int get hashCode {
    return Object.hash(id, templateJson, rrule, nextRunAt, isActive);
  }
}
