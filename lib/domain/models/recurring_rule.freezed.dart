// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringRule {
  String get id;
  String get templateJson;
  String get rrule;
  DateTime get nextRunAt;
  bool get isActive;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecurringRuleCopyWith<RecurringRule> get copyWith =>
      _$RecurringRuleCopyWithImpl<RecurringRule>(
          this as RecurringRule, _$identity);

  /// Serializes this RecurringRule to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    final _this = this as RecurringRule;
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecurringRule &&
            (identical(other.id, _this.id) || other.id == _this.id) &&
            (identical(other.templateJson, _this.templateJson) ||
                other.templateJson == _this.templateJson) &&
            (identical(other.rrule, _this.rrule) ||
                other.rrule == _this.rrule) &&
            (identical(other.nextRunAt, _this.nextRunAt) ||
                other.nextRunAt == _this.nextRunAt) &&
            (identical(other.isActive, _this.isActive) ||
                other.isActive == _this.isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    final _this = this as RecurringRule;
    return Object.hash(runtimeType, _this.id, _this.templateJson, _this.rrule,
        _this.nextRunAt, _this.isActive);
  }

  @override
  String toString() {
    final _this = this as RecurringRule;
    return 'RecurringRule(id: ${_this.id}, templateJson: ${_this.templateJson}, rrule: ${_this.rrule}, nextRunAt: ${_this.nextRunAt}, isActive: ${_this.isActive})';
  }
}

/// @nodoc
abstract mixin class $RecurringRuleCopyWith<$Res> {
  factory $RecurringRuleCopyWith(
          RecurringRule value, $Res Function(RecurringRule) _then) =
      _$RecurringRuleCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String templateJson,
      String rrule,
      DateTime nextRunAt,
      bool isActive});
}

/// @nodoc
class _$RecurringRuleCopyWithImpl<$Res>
    implements $RecurringRuleCopyWith<$Res> {
  _$RecurringRuleCopyWithImpl(this._self, this._then);

  final RecurringRule _self;
  final $Res Function(RecurringRule) _then;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? templateJson = null,
    Object? rrule = null,
    Object? nextRunAt = null,
    Object? isActive = null,
  }) {
    return _then(RecurringRule(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      templateJson: null == templateJson
          ? _self.templateJson
          : templateJson // ignore: cast_nullable_to_non_nullable
              as String,
      rrule: null == rrule
          ? _self.rrule
          : rrule // ignore: cast_nullable_to_non_nullable
              as String,
      nextRunAt: null == nextRunAt
          ? _self.nextRunAt
          : nextRunAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecurringRule].
extension RecurringRulePatterns on RecurringRule {
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
    TResult Function(_RecurringRule value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
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
    TResult Function(_RecurringRule value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule():
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
    TResult? Function(_RecurringRule value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
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
    TResult Function(String id, String templateJson, String rrule,
            DateTime nextRunAt, bool isActive)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
        return $default(_that.id, _that.templateJson, _that.rrule,
            _that.nextRunAt, _that.isActive);
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
    TResult Function(String id, String templateJson, String rrule,
            DateTime nextRunAt, bool isActive)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule():
        return $default(_that.id, _that.templateJson, _that.rrule,
            _that.nextRunAt, _that.isActive);
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
    TResult? Function(String id, String templateJson, String rrule,
            DateTime nextRunAt, bool isActive)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecurringRule() when $default != null:
        return $default(_that.id, _that.templateJson, _that.rrule,
            _that.nextRunAt, _that.isActive);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecurringRule implements RecurringRule {
  const _RecurringRule(
      {required this.id,
      required this.templateJson,
      required this.rrule,
      required this.nextRunAt,
      this.isActive = true});
  factory _RecurringRule.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleFromJson(json);

  @override
  final String id;
  @override
  final String templateJson;
  @override
  final String rrule;
  @override
  final DateTime nextRunAt;
  @override
  @JsonKey()
  final bool isActive;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecurringRuleCopyWith<_RecurringRule> get copyWith =>
      __$RecurringRuleCopyWithImpl<_RecurringRule>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecurringRuleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecurringRule &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.templateJson, templateJson) ||
                other.templateJson == templateJson) &&
            (identical(other.rrule, rrule) || other.rrule == rrule) &&
            (identical(other.nextRunAt, nextRunAt) ||
                other.nextRunAt == nextRunAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode {
    return Object.hash(
        runtimeType, id, templateJson, rrule, nextRunAt, isActive);
  }

  @override
  String toString() {
    return 'RecurringRule(id: $id, templateJson: $templateJson, rrule: $rrule, nextRunAt: $nextRunAt, isActive: $isActive)';
  }
}

/// @nodoc
abstract mixin class _$RecurringRuleCopyWith<$Res>
    implements $RecurringRuleCopyWith<$Res> {
  factory _$RecurringRuleCopyWith(
          _RecurringRule value, $Res Function(_RecurringRule) _then) =
      __$RecurringRuleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String templateJson,
      String rrule,
      DateTime nextRunAt,
      bool isActive});
}

/// @nodoc
class __$RecurringRuleCopyWithImpl<$Res>
    implements _$RecurringRuleCopyWith<$Res> {
  __$RecurringRuleCopyWithImpl(this._self, this._then);

  final _RecurringRule _self;
  final $Res Function(_RecurringRule) _then;

  /// Create a copy of RecurringRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? templateJson = null,
    Object? rrule = null,
    Object? nextRunAt = null,
    Object? isActive = null,
  }) {
    return _then(_RecurringRule(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      templateJson: null == templateJson
          ? _self.templateJson
          : templateJson // ignore: cast_nullable_to_non_nullable
              as String,
      rrule: null == rrule
          ? _self.rrule
          : rrule // ignore: cast_nullable_to_non_nullable
              as String,
      nextRunAt: null == nextRunAt
          ? _self.nextRunAt
          : nextRunAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _self.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
