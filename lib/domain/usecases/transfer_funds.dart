import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/repositories/account_repository_impl.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/usecases/split_validator.dart';

class TransferFunds {
  const TransferFunds({
    required this.accountRepository,
    required this.transactionRepository,
  });

  final AccountRepositoryImpl accountRepository;
  final TransactionRepositoryImpl transactionRepository;

  Future<Result<Transaction>> execute({
    required String fromAccountId,
    required String toAccountId,
    required int amountMinor,
    required DateTime occurredAt,
    String? note,
  }) async {
    if (fromAccountId == toAccountId) {
      return Result.failure('Transfer source and destination must be different.');
    }

    if (amountMinor <= 0) {
      return Result.failure('Transfer amount must be greater than zero.');
    }

    final transactionId = 'txn-${DateTime.now().microsecondsSinceEpoch}';
    final splits = [
      TransactionSplit(
        id: 'split-${DateTime.now().microsecondsSinceEpoch}',
        transactionId: transactionId,
        accountId: fromAccountId,
        amountMinor: amountMinor,
        direction: SplitDirection.credit,
      ),
      TransactionSplit(
        id: 'split-${DateTime.now().microsecondsSinceEpoch + 1}',
        transactionId: transactionId,
        accountId: toAccountId,
        amountMinor: amountMinor,
        direction: SplitDirection.debit,
      ),
    ];

    final validation = SplitValidator.validate(
      kind: TransactionKind.transfer,
      totalAmountMinor: amountMinor,
      splits: splits,
    );
    if (!validation.isValid) {
      return Result.failure(validation.errorMessage ?? 'Invalid transfer.');
    }

    final transaction = Transaction(
      id: transactionId,
      kind: TransactionKind.transfer,
      amountMinor: amountMinor,
      currency: 'PKR',
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
