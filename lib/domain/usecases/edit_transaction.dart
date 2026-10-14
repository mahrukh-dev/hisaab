import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/usecases/split_validator.dart';

class EditTransaction {
  const EditTransaction({required this.transactionRepository});

  final TransactionRepositoryImpl transactionRepository;

  Future<Result<Transaction>> execute({required Transaction transaction}) async {
    final validation = SplitValidator.validate(
      kind: transaction.kind,
      totalAmountMinor: transaction.amountMinor,
      splits: transaction.splits,
    );

    if (!validation.isValid) {
      return Result.failure(validation.errorMessage ?? 'Invalid transaction update.');
    }

    try {
      final updated = await transactionRepository.updateTransaction(transaction);
      return Result.success(updated);
    } on StateError catch (error) {
      return Result.failure(error.message);
    } on Exception catch (error) {
      return Result.failure(error.toString());
    }
  }
}
