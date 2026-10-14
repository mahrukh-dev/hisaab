import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/repositories/account_repository_impl.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/usecases/split_validator.dart';

class AddIncome {
  const AddIncome({
    required this.accountRepository,
    required this.transactionRepository,
  });

  final AccountRepositoryImpl accountRepository;
  final TransactionRepositoryImpl transactionRepository;

  Future<Result<Transaction>> execute({
    required int amountMinor,
    required String currency,
    required String accountId,
    required String categoryId,
    String? note,
    required DateTime occurredAt,
  }) async {
    if (amountMinor <= 0) {
      return Result.failure('Income amount must be greater than zero.');
    }

    final transactionId = 'txn-${DateTime.now().microsecondsSinceEpoch}';
    final splits = [
      TransactionSplit(
        id: 'split-${DateTime.now().microsecondsSinceEpoch}',
        transactionId: transactionId,
        accountId: accountId,
        amountMinor: amountMinor,
        direction: SplitDirection.debit,
      ),
    ];

    final validation = SplitValidator.validate(
      kind: TransactionKind.income,
      totalAmountMinor: amountMinor,
      splits: splits,
    );
    if (!validation.isValid) {
      return Result.failure(validation.errorMessage ?? 'Invalid income entry.');
    }

    final transaction = Transaction(
      id: transactionId,
      kind: TransactionKind.income,
      amountMinor: amountMinor,
      currency: currency,
      categoryId: categoryId,
      note: note,
      occurredAt: occurredAt,
      createdAt: DateTime.now().toUtc(),
      splits: splits,
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
