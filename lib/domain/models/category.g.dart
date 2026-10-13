// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: $enumDecode(_$CategoryKindEnumMap, json['kind']),
      parentId: json['parentId'] as String?,
      iconName: json['iconName'] as String?,
      colorValue: (json['colorValue'] as num?)?.toInt(),
      isSystem: json['isSystem'] as bool? ?? false,
    );

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'kind': _$CategoryKindEnumMap[instance.kind]!,
      'parentId': instance.parentId,
      'iconName': instance.iconName,
      'colorValue': instance.colorValue,
      'isSystem': instance.isSystem,
    };

const _$CategoryKindEnumMap = {
  CategoryKind.expense: 'expense',
  CategoryKind.income: 'income',
};
