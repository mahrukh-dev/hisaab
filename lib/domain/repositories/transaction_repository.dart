import 'package:hisaab/domain/models/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions({
    DateTime? from,
    DateTime? to,
    String? accountId,
    String? categoryId,
    String? text,
  });

  Future<Transaction?> getTransactionById(String id);

  Future<Transaction> saveTransaction(Transaction transaction);

  Future<Transaction> updateTransaction(Transaction transaction);

  Future<Transaction> deleteTransaction(String id);

  Future<Transaction> undoDelete(String id);
}
