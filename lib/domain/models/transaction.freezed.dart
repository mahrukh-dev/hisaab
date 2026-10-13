// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {
  String get id;
  TransactionKind get kind;
  int get amountMinor;
  DateTime get occurredAt;
  DateTime get createdAt;
  String get currency;
  String? get categoryId;
  String? get merchant;
  String? get note;
  DateTime? get deletedAt;
  TransactionSource get source;
  List<TransactionSplit> get splits;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<Transaction> get copyWith =>
      _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Transaction;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Transaction &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.kind, _this.kind) || other.kind == _this.kind) &&
            (identical(other.amountMinor, _this.amountMinor) ||
                other.amountMinor == _this.amountMinor) &&
            (identical(other.occurredAt, _this.occurredAt) ||
                other.occurredAt == _this.occurredAt) &&
            (identical(other.createdAt, _this.createdAt) ||
                other.createdAt == _this.createdAt) &&
            (identical(other.currency, _this.currency) ||
                other.currency == _this.currency) &&
            (identical(other.categoryId, _this.categoryId) ||
                other.categoryId == _this.categoryId) &&
            (identical(other.merchant, _this.merchant) ||
                other.merchant == _this.merchant) &&
            (identical(other.note, _this.note) || other.note == _this.note) &&
            (identical(other.deletedAt, _this.deletedAt) ||
                other.deletedAt == _this.deletedAt) &&
            (identical(other.source, _this.source) ||
                other.source == _this.source) &&
            const DeepCollectionEquality().equals(other.splits, _this.splits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Transaction;
    return Object.hash(
        runtimeType,
        _this.id,
        _this.kind,
        _this.amountMinor,
        _this.occurredAt,
        _this.createdAt,
        _this.currency,
        _this.categoryId,
        _this.merchant,
        _this.note,
        _this.deletedAt,
        _this.source,
        const DeepCollectionEquality().hash(_this.splits));
  }

  @override
  String toString() {
    final _this = this as Transaction;
    return 'Transaction(id: ${_this.id}, kind: ${_this.kind}, amountMinor: ${_this.amountMinor}, occurredAt: ${_this.occurredAt}, createdAt: ${_this.createdAt}, currency: ${_this.currency}, categoryId: ${_this.categoryId}, merchant: ${_this.merchant}, note: ${_this.note}, deletedAt: ${_this.deletedAt}, source: ${_this.source}, splits: ${_this.splits})';
  }
}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
          Transaction value, $Res Function(Transaction) _then) =
      _$TransactionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      TransactionKind kind,
      int amountMinor,
      DateTime occurredAt,
      DateTime createdAt,
      String currency,
      String? categoryId,
      String? merchant,
      String? note,
      DateTime? deletedAt,
      TransactionSource source,
      List<TransactionSplit> splits});
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res> implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? amountMinor = null,
    Object? occurredAt = null,
    Object? createdAt = null,
    Object? currency = null,
    Object? categoryId = freezed,
    Object? merchant = freezed,
    Object? note = freezed,
    Object? deletedAt = freezed,
    Object? source = null,
    Object? splits = null,
  }) {
    return _then(Transaction(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TransactionKind,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
      splits: null == splits
          ? _self.splits
          : splits // ignore: cast_nullable_to_non_nullable
              as List<TransactionSplit>,
    ));
  }
}

/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_Transaction value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_Transaction value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_Transaction value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            TransactionKind kind,
            int amountMinor,
            DateTime occurredAt,
            DateTime createdAt,
            String currency,
            String? categoryId,
            String? merchant,
            String? note,
            DateTime? deletedAt,
            TransactionSource source,
            List<TransactionSplit> splits)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(
            _that.id,
            _that.kind,
            _that.amountMinor,
            _that.occurredAt,
            _that.createdAt,
            _that.currency,
            _that.categoryId,
            _that.merchant,
            _that.note,
            _that.deletedAt,
            _that.source,
            _that.splits);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            TransactionKind kind,
            int amountMinor,
            DateTime occurredAt,
            DateTime createdAt,
            String currency,
            String? categoryId,
            String? merchant,
            String? note,
            DateTime? deletedAt,
            TransactionSource source,
            List<TransactionSplit> splits)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction():
        return $default(
            _that.id,
            _that.kind,
            _that.amountMinor,
            _that.occurredAt,
            _that.createdAt,
            _that.currency,
            _that.categoryId,
            _that.merchant,
            _that.note,
            _that.deletedAt,
            _that.source,
            _that.splits);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            TransactionKind kind,
            int amountMinor,
            DateTime occurredAt,
            DateTime createdAt,
            String currency,
            String? categoryId,
            String? merchant,
            String? note,
            DateTime? deletedAt,
            TransactionSource source,
            List<TransactionSplit> splits)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(
            _that.id,
            _that.kind,
            _that.amountMinor,
            _that.occurredAt,
            _that.createdAt,
            _that.currency,
            _that.categoryId,
            _that.merchant,
            _that.note,
            _that.deletedAt,
            _that.source,
            _that.splits);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Transaction implements Transaction {
  const _Transaction(
      {required this.id,
      required this.kind,
      required this.amountMinor,
      required this.occurredAt,
      required this.createdAt,
      this.currency = 'PKR',
      this.categoryId,
      this.merchant,
      this.note,
      this.deletedAt,
      this.source = TransactionSource.manual,
      List<TransactionSplit> splits = const []})
      : _splits = splits;
  factory _Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  @override
  final String id;
  @override
  final TransactionKind kind;
  @override
  final int amountMinor;
  @override
  final DateTime occurredAt;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final String currency;
  @override
  final String? categoryId;
  @override
  final String? merchant;
  @override
  final String? note;
  @override
  final DateTime? deletedAt;
  @override
  @JsonKey()
  final TransactionSource source;
  final List<TransactionSplit> _splits;
  @override
  @JsonKey()
  List<TransactionSplit> get splits {
    if (_splits is EqualUnmodifiableListView) return _splits;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_splits);
  }

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionCopyWith<_Transaction> get copyWith =>
      __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Transaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.kind, kind) || other.kind == kind) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.occurredAt, occurredAt) ||
                other.occurredAt == occurredAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.merchant, merchant) ||
                other.merchant == merchant) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(other.splits, _splits));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
        runtimeType,
        id,
        kind,
        amountMinor,
        occurredAt,
        createdAt,
        currency,
        categoryId,
        merchant,
        note,
        deletedAt,
        source,
        const DeepCollectionEquality().hash(_splits));
  }

  @override
  String toString() {
    return 'Transaction(id: $id, kind: $kind, amountMinor: $amountMinor, occurredAt: $occurredAt, createdAt: $createdAt, currency: $currency, categoryId: $categoryId, merchant: $merchant, note: $note, deletedAt: $deletedAt, source: $source, splits: $splits)';
  }
}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(
          _Transaction value, $Res Function(_Transaction) _then) =
      __$TransactionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      TransactionKind kind,
      int amountMinor,
      DateTime occurredAt,
      DateTime createdAt,
      String currency,
      String? categoryId,
      String? merchant,
      String? note,
      DateTime? deletedAt,
      TransactionSource source,
      List<TransactionSplit> splits});
}

/// @nodoc
class __$TransactionCopyWithImpl<$Res> implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? kind = null,
    Object? amountMinor = null,
    Object? occurredAt = null,
    Object? createdAt = null,
    Object? currency = null,
    Object? categoryId = freezed,
    Object? merchant = freezed,
    Object? note = freezed,
    Object? deletedAt = freezed,
    Object? source = null,
    Object? splits = null,
  }) {
    return _then(_Transaction(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      kind: null == kind
          ? _self.kind
          : kind // ignore: cast_nullable_to_non_nullable
              as TransactionKind,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      occurredAt: null == occurredAt
          ? _self.occurredAt
          : occurredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: freezed == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
      merchant: freezed == merchant
          ? _self.merchant
          : merchant // ignore: cast_nullable_to_non_nullable
              as String?,
      note: freezed == note
          ? _self.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _self.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as TransactionSource,
      splits: null == splits
          ? _self._splits
          : splits // ignore: cast_nullable_to_non_nullable
              as List<TransactionSplit>,
    ));
  }
}

// dart format on
