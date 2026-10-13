// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Transaction _$TransactionFromJson(Map<String, dynamic> json) => _Transaction(
      id: json['id'] as String,
      kind: $enumDecode(_$TransactionKindEnumMap, json['kind']),
      amountMinor: (json['amountMinor'] as num).toInt(),
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      currency: json['currency'] as String? ?? 'PKR',
      categoryId: json['categoryId'] as String?,
      merchant: json['merchant'] as String?,
      note: json['note'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      source: $enumDecodeNullable(_$TransactionSourceEnumMap, json['source']) ??
          TransactionSource.manual,
      splits: (json['splits'] as List<dynamic>?)
              ?.map((e) => TransactionSplit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TransactionToJson(_Transaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kind': _$TransactionKindEnumMap[instance.kind]!,
      'amountMinor': instance.amountMinor,
      'occurredAt': instance.occurredAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'currency': instance.currency,
      'categoryId': instance.categoryId,
      'merchant': instance.merchant,
      'note': instance.note,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'source': _$TransactionSourceEnumMap[instance.source]!,
      'splits': instance.splits,
    };

const _$TransactionKindEnumMap = {
  TransactionKind.expense: 'expense',
  TransactionKind.income: 'income',
  TransactionKind.transfer: 'transfer',
};

const _$TransactionSourceEnumMap = {
  TransactionSource.manual: 'manual',
  TransactionSource.ai: 'ai',
  TransactionSource.recurring: 'recurring',
  TransactionSource.receipt: 'receipt',
};
