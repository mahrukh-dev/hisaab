import 'package:hisaab/data/db/app_database.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Transaction>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? accountId,
    String? categoryId,
    String? text,
  }) async {
    final rows = await _db.getTransactions(
      from: from,
      to: to,
      accountId: accountId,
      categoryId: categoryId,
      text: text,
    );

    final transactions = <Transaction>[];
    for (final row in rows) {
      final id = row['id'] as String;
      final splits = await _db.getTransactionSplits(id);
      transactions.add(_fromRow(row, splits));
    }
    return transactions;
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    final row = await _db.getTransactionByIdRaw(id);
    if (row == null) {
      return null;
    }
    final splits = await _db.getTransactionSplits(id);
    return _fromRow(row, splits);
  }

  @override
  Future<Transaction> saveTransaction(Transaction transaction) async {
    await _db.upsertTransaction(
      id: transaction.id,
      kind: transaction.kind.name,
      amountMinor: transaction.amountMinor,
      currency: transaction.currency,
      categoryId: transaction.categoryId,
      merchant: transaction.merchant,
      note: transaction.note,
      occurredAt: transaction.occurredAt,
      createdAt: transaction.createdAt,
      source: transaction.source.name,
      splits: transaction.splits
          .map(
            (split) => {
              'id': split.id,
              'account_id': split.accountId,
              'amount_minor': split.amountMinor,
              'direction': split.direction.name,
            },
          )
          .toList(),
    );

    final stored = await getTransactionById(transaction.id);
    if (stored == null) {
      throw StateError('Transaction ${transaction.id} could not be saved.');
    }
    return stored;
  }

  @override
  Future<Transaction> updateTransaction(Transaction transaction) async {
    await _db.deleteTransactionSplits(transaction.id);
    return saveTransaction(transaction);
  }

  @override
  Future<Transaction> deleteTransaction(String id) async {
    await _db.softDeleteTransaction(id);
    final transaction = await getTransactionById(id);
    if (transaction == null) {
      throw StateError('Transaction $id not found.');
    }
    return transaction.copyWith(deletedAt: DateTime.now().toUtc());
  }

  @override
  Future<Transaction> undoDelete(String id) async {
    await _db.restoreTransaction(id);
    final transaction = await getTransactionById(id);
    if (transaction == null) {
      throw StateError('Transaction $id not found.');
    }
    return transaction.copyWith(deletedAt: null);
  }

  Transaction _fromRow(Map<String, Object?> row, List<Map<String, Object?>> splits) {
    return Transaction(
      id: row['id'] as String,
      kind: TransactionKind.values.firstWhere(
        (value) => value.name == (row['kind'] as String? ?? 'expense'),
        orElse: () => TransactionKind.expense,
      ),
      amountMinor: (row['amount_minor'] as int?) ?? 0,
      occurredAt: DateTime.parse(row['occurred_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
      currency: row['currency'] as String? ?? 'PKR',
      categoryId: row['category_id'] as String?,
      merchant: row['merchant'] as String?,
      note: row['note'] as String?,
      deletedAt: row['deleted_at'] == null
          ? null
          : DateTime.parse(row['deleted_at'] as String),
      source: TransactionSource.values.firstWhere(
        (value) => value.name == (row['source'] as String? ?? 'manual'),
        orElse: () => TransactionSource.manual,
      ),
      splits: splits
          .map(
            (split) => TransactionSplit(
              id: split['id'] as String,
              transactionId: row['id'] as String,
              accountId: split['account_id'] as String,
              amountMinor: (split['amount_minor'] as int?) ?? 0,
              direction: SplitDirection.values.firstWhere(
                (direction) =>
                    direction.name == (split['direction'] as String? ?? 'credit'),
                orElse: () => SplitDirection.credit,
              ),
            ),
          )
          .toList(),
    );
  }
}
