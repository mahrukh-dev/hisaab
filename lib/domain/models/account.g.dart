// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Account _$AccountFromJson(Map<String, dynamic> json) => _Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$AccountTypeEnumMap, json['type']),
      currency: json['currency'] as String? ?? 'PKR',
      openingBalanceMinor: (json['openingBalanceMinor'] as num?)?.toInt() ?? 0,
      colorValue: (json['colorValue'] as num?)?.toInt(),
      iconName: json['iconName'] as String?,
      isArchived: json['isArchived'] as bool? ?? false,
    );

Map<String, dynamic> _$AccountToJson(_Account instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$AccountTypeEnumMap[instance.type]!,
      'currency': instance.currency,
      'openingBalanceMinor': instance.openingBalanceMinor,
      'colorValue': instance.colorValue,
      'iconName': instance.iconName,
      'isArchived': instance.isArchived,
    };

const _$AccountTypeEnumMap = {
  AccountType.bank: 'bank',
  AccountType.cash: 'cash',
  AccountType.wallet: 'wallet',
  AccountType.creditCard: 'creditCard',
};
