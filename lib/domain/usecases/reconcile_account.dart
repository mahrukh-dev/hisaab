import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/repositories/account_repository_impl.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';

class ReconcileAccount {
  const ReconcileAccount({
    required this.accountRepository,
    required this.transactionRepository,
  });

  final AccountRepositoryImpl accountRepository;
  final TransactionRepositoryImpl transactionRepository;

  Future<Result<Transaction>> execute({
    required String accountId,
    required int actualBalanceMinor,
  }) async {
    final currentBalanceMinor = await accountRepository.getBalanceMinor(accountId);
    final differenceMinor = actualBalanceMinor - currentBalanceMinor;

    if (differenceMinor == 0) {
      return Result.failure('Account is already reconciled.');
    }

    final isIncome = differenceMinor > 0;
    final transactionId = 'txn-${DateTime.now().microsecondsSinceEpoch}';
    final direction = isIncome ? SplitDirection.debit : SplitDirection.credit;
    final txn = Transaction(
      id: transactionId,
      kind: isIncome ? TransactionKind.income : TransactionKind.expense,
      amountMinor: differenceMinor.abs(),
      currency: 'PKR',
      note: 'Reconciliation adjustment',
      occurredAt: DateTime.now().toUtc(),
      createdAt: DateTime.now().toUtc(),
      splits: [
        TransactionSplit(
          id: 'split-${DateTime.now().microsecondsSinceEpoch}',
          transactionId: transactionId,
          accountId: accountId,
          amountMinor: differenceMinor.abs(),
          direction: direction,
        ),
      ],
    );

    try {
      final saved = await transactionRepository.saveTransaction(txn);
      return Result.success(saved);
    } on StateError catch (error) {
      return Result.failure(error.message);
    } on Exception catch (error) {
      return Result.failure(error.toString());
    }
  }
}
