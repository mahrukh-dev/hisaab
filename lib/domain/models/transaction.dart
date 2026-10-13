import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hisaab/domain/models/transaction_split.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

/// Enum representing transaction kinds.
enum TransactionKind {
  /// Expense transaction.
  expense,

  /// Income transaction.
  income,

  /// Transfer between accounts.
  transfer,
}

/// Enum representing the origin/source of a transaction.
enum TransactionSource {
  /// Manually entered by user.
  manual,

  /// Generated via AI natural language entry.
  ai,

  /// Automatically generated from a recurring rule.
  recurring,

  /// Created via receipt scan OCR.
  receipt,
}

/// Domain model representing a financial transaction.
@freezed
class Transaction with _$Transaction {
  /// Creates a [Transaction].
  const factory Transaction({
    required String id,
    required TransactionKind kind,
    required int amountMinor,
    required DateTime occurredAt,
    required DateTime createdAt,
    @Default('PKR') String currency,
    String? categoryId,
    String? merchant,
    String? note,
    DateTime? deletedAt,
    @Default(TransactionSource.manual) TransactionSource source,
    @Default([]) List<TransactionSplit> splits,
  }) = _Transaction;

  /// Creates a [Transaction] from JSON.
  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  @override
  // TODO: implement amountMinor
  int get amountMinor => throw UnimplementedError();

  @override
  // TODO: implement categoryId
  String? get categoryId => throw UnimplementedError();

  @override
  // TODO: implement createdAt
  DateTime get createdAt => throw UnimplementedError();

  @override
  // TODO: implement currency
  String get currency => throw UnimplementedError();

  @override
  // TODO: implement deletedAt
  DateTime? get deletedAt => throw UnimplementedError();

  @override
  // TODO: implement id
  String get id => throw UnimplementedError();

  @override
  // TODO: implement kind
  TransactionKind get kind => throw UnimplementedError();

  @override
  // TODO: implement merchant
  String? get merchant => throw UnimplementedError();

  @override
  // TODO: implement note
  String? get note => throw UnimplementedError();

  @override
  // TODO: implement occurredAt
  DateTime get occurredAt => throw UnimplementedError();

  @override
  // TODO: implement source
  TransactionSource get source => throw UnimplementedError();

  @override
  // TODO: implement splits
  List<TransactionSplit> get splits => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
