// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Budget {
  String get id;
  String get categoryId;
  int get amountMinor;
  String get currency;
  BudgetPeriod get period;
  bool get hasRollover;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetCopyWith<Budget> get copyWith =>
      _$BudgetCopyWithImpl<Budget>(this as Budget, _$identity);

  /// Serializes this Budget to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as Budget;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Budget &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.categoryId, _this.categoryId) ||
                other.categoryId == _this.categoryId) &&
            (identical(other.amountMinor, _this.amountMinor) ||
                other.amountMinor == _this.amountMinor) &&
            (identical(other.currency, _this.currency) ||
                other.currency == _this.currency) &&
            (identical(other.period, _this.period) ||
                other.period == _this.period) &&
            (identical(other.hasRollover, _this.hasRollover) ||
                other.hasRollover == _this.hasRollover));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as Budget;
    return Object.hash(runtimeType, _this.id, _this.categoryId,
        _this.amountMinor, _this.currency, _this.period, _this.hasRollover);
  }

  @override
  String toString() {
    final _this = this as Budget;
    return 'Budget(id: ${_this.id}, categoryId: ${_this.categoryId}, amountMinor: ${_this.amountMinor}, currency: ${_this.currency}, period: ${_this.period}, hasRollover: ${_this.hasRollover})';
  }
}

/// @nodoc
abstract mixin class $BudgetCopyWith<$Res> {
  factory $BudgetCopyWith(Budget value, $Res Function(Budget) _then) =
      _$BudgetCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String categoryId,
      int amountMinor,
      String currency,
      BudgetPeriod period,
      bool hasRollover});
}

/// @nodoc
class _$BudgetCopyWithImpl<$Res> implements $BudgetCopyWith<$Res> {
  _$BudgetCopyWithImpl(this._self, this._then);

  final Budget _self;
  final $Res Function(Budget) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? period = null,
    Object? hasRollover = null,
  }) {
    return _then(Budget(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      hasRollover: null == hasRollover
          ? _self.hasRollover
          : hasRollover // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [Budget].
extension BudgetPatterns on Budget {
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
    TResult Function(_Budget value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
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
    TResult Function(_Budget value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget():
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
    TResult? Function(_Budget value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
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
    TResult Function(String id, String categoryId, int amountMinor,
            String currency, BudgetPeriod period, bool hasRollover)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
        return $default(_that.id, _that.categoryId, _that.amountMinor,
            _that.currency, _that.period, _that.hasRollover);
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
    TResult Function(String id, String categoryId, int amountMinor,
            String currency, BudgetPeriod period, bool hasRollover)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget():
        return $default(_that.id, _that.categoryId, _that.amountMinor,
            _that.currency, _that.period, _that.hasRollover);
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
    TResult? Function(String id, String categoryId, int amountMinor,
            String currency, BudgetPeriod period, bool hasRollover)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Budget() when $default != null:
        return $default(_that.id, _that.categoryId, _that.amountMinor,
            _that.currency, _that.period, _that.hasRollover);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Budget implements Budget {
  const _Budget(
      {required this.id,
      required this.categoryId,
      required this.amountMinor,
      this.currency = 'PKR',
      this.period = BudgetPeriod.monthly,
      this.hasRollover = false});
  factory _Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  final int amountMinor;
  @override
  @JsonKey()
  final String currency;
  @override
  @JsonKey()
  final BudgetPeriod period;
  @override
  @JsonKey()
  final bool hasRollover;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetCopyWith<_Budget> get copyWith =>
      __$BudgetCopyWithImpl<_Budget>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Budget &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.amountMinor, amountMinor) ||
                other.amountMinor == amountMinor) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.period, period) || other.period == period) &&
            (identical(other.hasRollover, hasRollover) ||
                other.hasRollover == hasRollover));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(runtimeType, id, categoryId, amountMinor, currency,
        period, hasRollover);
  }

  @override
  String toString() {
    return 'Budget(id: $id, categoryId: $categoryId, amountMinor: $amountMinor, currency: $currency, period: $period, hasRollover: $hasRollover)';
  }
}

/// @nodoc
abstract mixin class _$BudgetCopyWith<$Res> implements $BudgetCopyWith<$Res> {
  factory _$BudgetCopyWith(_Budget value, $Res Function(_Budget) _then) =
      __$BudgetCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String categoryId,
      int amountMinor,
      String currency,
      BudgetPeriod period,
      bool hasRollover});
}

/// @nodoc
class __$BudgetCopyWithImpl<$Res> implements _$BudgetCopyWith<$Res> {
  __$BudgetCopyWithImpl(this._self, this._then);

  final _Budget _self;
  final $Res Function(_Budget) _then;

  /// Create a copy of Budget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? amountMinor = null,
    Object? currency = null,
    Object? period = null,
    Object? hasRollover = null,
  }) {
    return _then(_Budget(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _self.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      amountMinor: null == amountMinor
          ? _self.amountMinor
          : amountMinor // ignore: cast_nullable_to_non_nullable
              as int,
      currency: null == currency
          ? _self.currency
          : currency // ignore: cast_nullable_to_non_nullable
              as String,
      period: null == period
          ? _self.period
          : period // ignore: cast_nullable_to_non_nullable
              as BudgetPeriod,
      hasRollover: null == hasRollover
          ? _self.hasRollover
          : hasRollover // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
