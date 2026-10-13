// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Budget _$BudgetFromJson(Map<String, dynamic> json) => _Budget(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      currency: json['currency'] as String? ?? 'PKR',
      period: $enumDecodeNullable(_$BudgetPeriodEnumMap, json['period']) ??
          BudgetPeriod.monthly,
      hasRollover: json['hasRollover'] as bool? ?? false,
    );

Map<String, dynamic> _$BudgetToJson(_Budget instance) => <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'amountMinor': instance.amountMinor,
      'currency': instance.currency,
      'period': _$BudgetPeriodEnumMap[instance.period]!,
      'hasRollover': instance.hasRollover,
    };

const _$BudgetPeriodEnumMap = {
  BudgetPeriod.monthly: 'monthly',
};
