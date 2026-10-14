import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/transaction.dart';

class DeleteTransaction {
  const DeleteTransaction({required this.transactionRepository});

  final TransactionRepositoryImpl transactionRepository;

  Future<Result<Transaction>> execute(String id) async {
    try {
      final deleted = await transactionRepository.deleteTransaction(id);
      return Result.success(deleted);
    } on StateError catch (error) {
      return Result.failure(error.message);
    } on Exception catch (error) {
      return Result.failure(error.toString());
    }
  }
}
