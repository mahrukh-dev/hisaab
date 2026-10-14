import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/repositories/account_repository_impl.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/usecases/split_validator.dart';

class AddExpense {
  const AddExpense({
    required this.accountRepository,
    required this.transactionRepository,
  });

  final AccountRepositoryImpl accountRepository;
  final TransactionRepositoryImpl transactionRepository;

  Future<Result<Transaction>> execute({
    required int amountMinor,
    required String currency,
    required String categoryId,
    String? merchant,
    String? note,
    required DateTime occurredAt,
    required List<TransactionSplit> splits,
  }) async {
    if (amountMinor <= 0) {
      return Result.failure('Expense amount must be greater than zero.');
    }

    final validation = SplitValidator.validate(
      kind: TransactionKind.expense,
      totalAmountMinor: amountMinor,
      splits: splits,
    );

    if (!validation.isValid) {
      return Result.failure(validation.errorMessage ?? 'Invalid expense splits.');
    }

    final transactionId = 'txn-${DateTime.now().microsecondsSinceEpoch}';
    final normalizedSplits = splits
        .map((split) => split.copyWith(transactionId: transactionId))
        .toList();

    final transaction = Transaction(
      id: transactionId,
      kind: TransactionKind.expense,
      amountMinor: amountMinor,
      currency: currency,
      categoryId: categoryId,
      merchant: merchant,
      note: note,
      occurredAt: occurredAt,
      createdAt: DateTime.now().toUtc(),
      splits: normalizedSplits,
    );

    try {
      final saved = await transactionRepository.saveTransaction(transaction);
      return Result.success(saved);
    } on StateError catch (error) {
      return Result.failure(error.message);
    } on Exception catch (error) {
      return Result.failure(error.toString());
    }
  }
}
