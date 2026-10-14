import 'package:hisaab/domain/models/transaction_split.dart';

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
class Transaction {
  /// Creates a [Transaction].
  const Transaction({
    required this.id,
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
    this.splits = const [],
  });

  /// Creates a [Transaction] from JSON.
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      kind: TransactionKind.values.firstWhere(
        (value) => value.name == (json['kind'] as String? ?? 'expense'),
        orElse: () => TransactionKind.expense,
      ),
      amountMinor: json['amountMinor'] as int,
      occurredAt: DateTime.parse(json['occurredAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      currency: json['currency'] as String? ?? 'PKR',
      categoryId: json['categoryId'] as String?,
      merchant: json['merchant'] as String?,
      note: json['note'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      source: TransactionSource.values.firstWhere(
        (value) => value.name == (json['source'] as String? ?? 'manual'),
        orElse: () => TransactionSource.manual,
      ),
      splits: (json['splits'] as List<dynamic>? ?? const [])
          .map((split) => TransactionSplit.fromJson(split as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Stable transaction id.
  final String id;

  /// Expense, income, or transfer.
  final TransactionKind kind;

  /// Total transaction amount in minor units.
  final int amountMinor;

  /// When the transaction occurred.
  final DateTime occurredAt;

  /// When it was created.
  final DateTime createdAt;

  /// ISO currency code.
  final String currency;

  /// Optional category id.
  final String? categoryId;

  /// Merchant or payee name.
  final String? merchant;

  /// Optional note.
  final String? note;

  /// Soft delete timestamp when archived.
  final DateTime? deletedAt;

  /// Source of the entry.
  final TransactionSource source;

  /// Ledger splits attached to the transaction.
  final List<TransactionSplit> splits;

  /// Serializes the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kind': kind.name,
      'amountMinor': amountMinor,
      'occurredAt': occurredAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'currency': currency,
      'categoryId': categoryId,
      'merchant': merchant,
      'note': note,
      'deletedAt': deletedAt?.toIso8601String(),
      'source': source.name,
      'splits': splits.map((split) => split.toJson()).toList(),
    };
  }

  /// Creates a copy of this transaction with selected fields replaced.
  Transaction copyWith({
    String? id,
    TransactionKind? kind,
    int? amountMinor,
    DateTime? occurredAt,
    DateTime? createdAt,
    String? currency,
    String? categoryId,
    String? merchant,
    String? note,
    DateTime? deletedAt,
    TransactionSource? source,
    List<TransactionSplit>? splits,
  }) {
    return Transaction(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      amountMinor: amountMinor ?? this.amountMinor,
      occurredAt: occurredAt ?? this.occurredAt,
      createdAt: createdAt ?? this.createdAt,
      currency: currency ?? this.currency,
      categoryId: categoryId ?? this.categoryId,
      merchant: merchant ?? this.merchant,
      note: note ?? this.note,
      deletedAt: deletedAt ?? this.deletedAt,
      source: source ?? this.source,
      splits: splits ?? this.splits,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Transaction &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            kind == other.kind &&
            amountMinor == other.amountMinor &&
            occurredAt == other.occurredAt &&
            createdAt == other.createdAt &&
            currency == other.currency &&
            categoryId == other.categoryId &&
            merchant == other.merchant &&
            note == other.note &&
            deletedAt == other.deletedAt &&
            source == other.source &&
            splits.length == other.splits.length &&
            List.generate(
              splits.length,
              (index) => splits[index] == other.splits[index],
            ).every((value) => value);
  }

  @override
  int get hashCode {
    return Object.hash(
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
      Object.hashAll(splits),
    );
  }
}
