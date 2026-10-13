import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

/// Enum representing the kind of category.
enum CategoryKind {
  /// Expense category.
  expense,

  /// Income category.
  income,
}

/// Domain model representing a Category.
@freezed
class Category with _$Category {
  /// Creates a [Category].
  const factory Category({
    required String id,
    required String name,
    required CategoryKind kind,
    String? parentId,
    String? iconName,
    int? colorValue,
    @Default(false) bool isSystem,
  }) = _Category;

  /// Creates a [Category] from JSON.
  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  @override
  // TODO: implement colorValue
  int? get colorValue => throw UnimplementedError();

  @override
  // TODO: implement iconName
  String? get iconName => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isSystem
  bool get isSystem => throw UnimplementedError();

  @override
  // TODO: implement kind
  CategoryKind get kind => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement parentId
  String? get parentId => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
