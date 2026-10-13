import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';
part 'account.g.dart';

/// Enum representing the types of accounts.
enum AccountType {
  /// Bank account (e.g. Meezan, HBL).
  bank,

  /// Cash in hand.
  cash,

  /// Mobile wallet (e.g. JazzCash, Easypaisa).
  wallet,

  /// Credit card account.
  creditCard,
}

/// Domain model representing an Account.
@freezed
class Account with _$Account {
  /// Creates an [Account].
  const factory Account({
    required String id,
    required String name,
    required AccountType type,
    @Default('PKR') String currency,
    @Default(0) int openingBalanceMinor,
    int? colorValue,
    String? iconName,
    @Default(false) bool isArchived,
  }) = _Account;

  /// Creates an [Account] from JSON.
  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  @override
  // TODO: implement colorValue
  int? get colorValue => throw UnimplementedError();

  @override
  // TODO: implement currency
  String get currency => throw UnimplementedError();

  @override
  // TODO: implement iconName
  String? get iconName => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement isArchived
  bool get isArchived => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement openingBalanceMinor
  int get openingBalanceMinor => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement type
  AccountType get type => throw UnimplementedError();
}
