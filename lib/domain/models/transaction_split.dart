/// Enum representing split direction (debit adds to account, credit removes from account).
enum SplitDirection {
  /// Debit: adds money to an account (income, incoming transfer).
  debit,

  /// Credit: takes money out of an account (expense, outgoing transfer).
  credit,
}

/// Domain model representing a single ledger line in a transaction.
class TransactionSplit {
  /// Creates a [TransactionSplit].
  const TransactionSplit({
    required this.id,
    required this.transactionId,
    required this.accountId,
    required this.amountMinor,
    required this.direction,
  });

  /// Creates a [TransactionSplit] from JSON.
  factory TransactionSplit.fromJson(Map<String, dynamic> json) {
    return TransactionSplit(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      accountId: json['accountId'] as String,
      amountMinor: json['amountMinor'] as int,
      direction: SplitDirection.values.firstWhere(
        (value) => value.name == (json['direction'] as String? ?? 'credit'),
        orElse: () => SplitDirection.credit,
      ),
    );
  }

  /// Stable split id.
  final String id;

  /// Parent transaction id.
  final String transactionId;

  /// Account touched by the split.
  final String accountId;

  /// Split amount in minor units.
  final int amountMinor;

  /// Whether this adds or removes funds from the account.
  final SplitDirection direction;

  /// Serializes the instance to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'accountId': accountId,
      'amountMinor': amountMinor,
      'direction': direction.name,
    };
  }

  /// Creates a copy of this split with selected fields replaced.
  TransactionSplit copyWith({
    String? id,
    String? transactionId,
    String? accountId,
    int? amountMinor,
    SplitDirection? direction,
  }) {
    return TransactionSplit(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      accountId: accountId ?? this.accountId,
      amountMinor: amountMinor ?? this.amountMinor,
      direction: direction ?? this.direction,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TransactionSplit &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            transactionId == other.transactionId &&
            accountId == other.accountId &&
            amountMinor == other.amountMinor &&
            direction == other.direction;
  }

  @override
  int get hashCode {
    return Object.hash(id, transactionId, accountId, amountMinor, direction);
  }
}
