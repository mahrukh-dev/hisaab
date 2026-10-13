// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_split.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionSplit _$TransactionSplitFromJson(Map<String, dynamic> json) =>
    _TransactionSplit(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      accountId: json['accountId'] as String,
      amountMinor: (json['amountMinor'] as num).toInt(),
      direction: $enumDecode(_$SplitDirectionEnumMap, json['direction']),
    );

Map<String, dynamic> _$TransactionSplitToJson(_TransactionSplit instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'accountId': instance.accountId,
      'amountMinor': instance.amountMinor,
      'direction': _$SplitDirectionEnumMap[instance.direction]!,
    };

const _$SplitDirectionEnumMap = {
  SplitDirection.debit: 'debit',
  SplitDirection.credit: 'credit',
};
