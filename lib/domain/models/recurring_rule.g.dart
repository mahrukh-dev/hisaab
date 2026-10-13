// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringRule _$RecurringRuleFromJson(Map<String, dynamic> json) =>
    _RecurringRule(
      id: json['id'] as String,
      templateJson: json['templateJson'] as String,
      rrule: json['rrule'] as String,
      nextRunAt: DateTime.parse(json['nextRunAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$RecurringRuleToJson(_RecurringRule instance) =>
    <String, dynamic>{
      'id': instance.id,
      'templateJson': instance.templateJson,
      'rrule': instance.rrule,
      'nextRunAt': instance.nextRunAt.toIso8601String(),
      'isActive': instance.isActive,
    };
