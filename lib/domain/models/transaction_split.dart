import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_split.freezed.dart';
part 'transaction_split.g.dart';

/// Enum representing split direction (debit adds to account, credit removes from account).
enum SplitDirection {
  /// Debit: adds money to an account (income, incoming transfer).
  debit,

  /// Credit: takes money out of an account (expense, outgoing transfer).
  credit,
}

/// Domain model representing a single ledger line in a transaction.
@freezed
class TransactionSplit with _$TransactionSplit {
  /// Creates a [TransactionSplit].
  const factory TransactionSplit({
    required String id,
    required String transactionId,
    required String accountId,
    required int amountMinor,
    required SplitDirection direction,
  }) = _TransactionSplit;

  /// Creates a [TransactionSplit] from JSON.
  factory TransactionSplit.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitFromJson(json);

  @override
  // TODO: implement accountId
  String get accountId => throw UnimplementedError();

  @override
  // TODO: implement amountMinor
  int get amountMinor => throw UnimplementedError();

  @override
  // TODO: implement direction
  SplitDirection get direction => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement transactionId
  String get transactionId => throw UnimplementedError();
}
