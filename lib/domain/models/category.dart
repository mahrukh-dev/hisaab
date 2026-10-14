/// Enum representing the kind of category.
enum CategoryKind {
  /// Expense category.
  expense,

  /// Income category.
  income,
}

/// Domain model representing a Category.
class Category {
  /// Creates a [Category].
  const Category({
    required this.id,
    required this.name,
    required this.kind,
    this.parentId,
    this.iconName,
    this.colorValue,
    this.isSystem = false,
  });

  /// Creates a [Category] from JSON.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      kind: CategoryKind.values.firstWhere(
        (value) => value.name == (json['kind'] as String? ?? 'expense'),
        orElse: () => CategoryKind.expense,
      ),
      parentId: json['parentId'] as String?,
      iconName: json['iconName'] as String?,
      colorValue: json['colorValue'] as int?,
      isSystem: json['isSystem'] as bool? ?? false,
    );
  }

  /// Unique category id.
  final String id;

  /// User-visible label.
  final String name;

  /// Whether the category is expense or income.
  final CategoryKind kind;

  /// Parent category id when nested.
  final String? parentId;

  /// Optional icon key.
  final String? iconName;

  /// Optional color value.
  final int? colorValue;

  /// Whether it is a system category.
  final bool isSystem;

  /// Serializes the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'kind': kind.name,
      'parentId': parentId,
      'iconName': iconName,
      'colorValue': colorValue,
      'isSystem': isSystem,
    };
  }

  /// Creates a copy of this category with selected fields replaced.
  Category copyWith({
    String? id,
    String? name,
    CategoryKind? kind,
    String? parentId,
    String? iconName,
    int? colorValue,
    bool? isSystem,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      parentId: parentId ?? this.parentId,
      iconName: iconName ?? this.iconName,
      colorValue: colorValue ?? this.colorValue,
      isSystem: isSystem ?? this.isSystem,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Category &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            kind == other.kind &&
            parentId == other.parentId &&
            iconName == other.iconName &&
            colorValue == other.colorValue &&
            isSystem == other.isSystem;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, kind, parentId, iconName, colorValue, isSystem);
  }
}
