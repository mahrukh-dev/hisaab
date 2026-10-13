// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_split.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionSplit {
  String get id;
  String get transactionId;
  String get accountId;
  int get amountMinor;
  SplitDirection get direction;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionSplitCopyWith<TransactionSplit> get copyWith =>
      _$TransactionSplitCopyWithImpl<TransactionSplit>(
          this as TransactionSplit, _$identity);

  /// Serializes this TransactionSplit to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as TransactionSplit;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionSplit &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.transactionId, _this.transactionId) ||
                other.transactionId == _this.transactionId) &&
            (identical(other.accountId, _this.accountId) ||
                other.accountId == _this.accountId) &&
            (identical(other.amountMinor, _this.amountMinor) ||
                other.amountMinor == _this.amountMinor) &&
            (identical(other.direction, _this.direction) ||
                other.direction == _this.direction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as TransactionSplit;
    return Object.hash(runtimeType, _this.id, _this.transactionId,
        _this.accountId, _this.amountMinor, _this.direction);
  }

  @override
  String toString() {
    final _this = this as TransactionSplit;
    return 'TransactionSplit(id: ${_this.id}, transactionId: ${_this.transactionId}, accountId: ${_this.accountId}, amountMinor: ${_this.amountMinor}, direction: ${_this.direction})';
  }
}

/// @nodoc
abstract mixin class $TransactionSplitCopyWith<$Res> {
  factory $TransactionSplitCopyWith(
          TransactionSplit value, $Res Function(TransactionSplit) _then) =
      _$TransactionSplitCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String accountId,
      int amountMinor,
      SplitDirection direction});
}

/// @nodoc
class _$TransactionSplitCopyWithImpl<$Res>
    implements $TransactionSplitCopyWith<$Res> {
  _$TransactionSplitCopyWithImpl(this._self, this._then);

  final TransactionSplit _self;
  final $Res Function(TransactionSplit) _then;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? accountId = null,
    Object? amountMinor = null,
    Object? direction = null,
  }) {
    return _then(TransactionSplit(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _self.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      direction: null == direction
          ? _self.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as SplitDirection,
    ));
  }
}

/// Adds pattern-matching-related methods to [TransactionSplit].
extension TransactionSplitPatterns on TransactionSplit {
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
    TResult Function(_TransactionSplit value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionSplit() when $default != null:
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
    TResult Function(_TransactionSplit value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplit():
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
    TResult? Function(_TransactionSplit value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplit() when $default != null:
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
    TResult Function(String id, String transactionId, String accountId,
            int amountMinor, SplitDirection direction)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionSplit() when $default != null:
        return $default(_that.id, _that.transactionId, _that.accountId,
            _that.amountMinor, _that.direction);
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
    TResult Function(String id, String transactionId, String accountId,
            int amountMinor, SplitDirection direction)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplit():
        return $default(_that.id, _that.transactionId, _that.accountId,
            _that.amountMinor, _that.direction);
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
    TResult? Function(String id, String transactionId, String accountId,
            int amountMinor, SplitDirection direction)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplit() when $default != null:
        return $default(_that.id, _that.transactionId, _that.accountId,
            _that.amountMinor, _that.direction);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionSplit implements TransactionSplit {
  const _TransactionSplit(
      {required this.id,
      required this.transactionId,
      required this.accountId,
      required this.amountMinor,
      required this.direction});
  factory _TransactionSplit.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitFromJson(json);

  @override
  final String id;
  @override
  final String transactionId;
  @override
  final String accountId;
  @override
  final int amountMinor;
  @override
  final SplitDirection direction;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionSplitCopyWith<_TransactionSplit> get copyWith =>
      __$TransactionSplitCopyWithImpl<_TransactionSplit>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionSplitToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionSplit &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.direction, direction) ||
                other.direction == direction));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
        runtimeType, id, transactionId, accountId, amountMinor, direction);
  }

  @override
  String toString() {
    return 'TransactionSplit(id: $id, transactionId: $transactionId, accountId: $accountId, amountMinor: $amountMinor, direction: $direction)';
  }
}

/// @nodoc
abstract mixin class _$TransactionSplitCopyWith<$Res>
    implements $TransactionSplitCopyWith<$Res> {
  factory _$TransactionSplitCopyWith(
          _TransactionSplit value, $Res Function(_TransactionSplit) _then) =
      __$TransactionSplitCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String transactionId,
      String accountId,
      int amountMinor,
      SplitDirection direction});
}

/// @nodoc
class __$TransactionSplitCopyWithImpl<$Res>
    implements _$TransactionSplitCopyWith<$Res> {
  __$TransactionSplitCopyWithImpl(this._self, this._then);

  final _TransactionSplit _self;
  final $Res Function(_TransactionSplit) _then;

  /// Create a copy of TransactionSplit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? accountId = null,
    Object? amountMinor = null,
    Object? direction = null,
  }) {
    return _then(_TransactionSplit(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      transactionId: null == transactionId
          ? _self.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as String,
      accountId: null == accountId
          ? _self.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      direction: null == direction
          ? _self.direction
          : direction // ignore: cast_nullable_to_non_nullable
              as SplitDirection,
    ));
  }
}

// dart format on
