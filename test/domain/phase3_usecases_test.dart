import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/core/result.dart';
import 'package:hisaab/data/db/app_database.dart';
import 'package:hisaab/data/repositories/account_repository_impl.dart';
import 'package:hisaab/data/repositories/transaction_repository_impl.dart';
import 'package:hisaab/domain/models/account.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/usecases/add_expense.dart';
import 'package:hisaab/domain/usecases/add_income.dart';
import 'package:hisaab/domain/usecases/delete_transaction.dart';
import 'package:hisaab/domain/usecases/edit_transaction.dart';
import 'package:hisaab/domain/usecases/reconcile_account.dart';
import 'package:hisaab/domain/usecases/transfer_funds.dart';
import 'package:hisaab/domain/usecases/undo_delete.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AppDatabase db;
  late AccountRepositoryImpl accountRepository;
  late TransactionRepositoryImpl transactionRepository;

  setUp(() async {
    db = await AppDatabase.open(filePath: ':memory:');
    accountRepository = AccountRepositoryImpl(db);
    transactionRepository = TransactionRepositoryImpl(db);

    await accountRepository.saveAccount(
      const Account(
        id: 'cash',
        name: 'Cash',
        type: AccountType.cash,
        currency: 'PKR',
        openingBalanceMinor: 500000,
      ),
    );
    await accountRepository.saveAccount(
      const Account(
        id: 'bank',
        name: 'Meezan',
        type: AccountType.bank,
        currency: 'PKR',
        openingBalanceMinor: 250000,
      ),
    );
  });

  tearDown(() => db.close());

  test('AddExpense accepts a valid split and stores it', () async {
    final useCase = AddExpense(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final result = await useCase.execute(
      amountMinor: 500000,
      currency: 'PKR',
      categoryId: 'food',
      merchant: 'Groceries',
      note: 'Weekend shop',
      occurredAt: DateTime(2026, 10, 14),
      splits: [
        const TransactionSplit(
          id: 'split-1',
          transactionId: 'txn-1',
          accountId: 'cash',
          amountMinor: 300000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 'split-2',
          transactionId: 'txn-1',
          accountId: 'bank',
          amountMinor: 200000,
          direction: SplitDirection.credit,
        ),
      ],
    );

    expect(result, isA<Success<Transaction>>());
    final transactions = await transactionRepository.getTransactions();
    expect(transactions, hasLength(1));
    expect(transactions.first.amountMinor, 500000);
  });

  test('AddExpense rejects a mismatched split total', () async {
    final useCase = AddExpense(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final result = await useCase.execute(
      amountMinor: 500000,
      currency: 'PKR',
      categoryId: 'food',
      merchant: 'Groceries',
      note: 'Weekend shop',
      occurredAt: DateTime(2026, 10, 14),
      splits: [
        const TransactionSplit(
          id: 'split-1',
          transactionId: 'txn-1',
          accountId: 'cash',
          amountMinor: 200000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 'split-2',
          transactionId: 'txn-1',
          accountId: 'bank',
          amountMinor: 100000,
          direction: SplitDirection.credit,
        ),
      ],
    );

    expect(result, isA<Failure<Transaction>>());
    expect((result as Failure<Transaction>).message, contains('does not match'));
  });

  test('TransferFunds validates opposite-direction transfer splits', () async {
    final useCase = TransferFunds(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final result = await useCase.execute(
      fromAccountId: 'bank',
      toAccountId: 'cash',
      amountMinor: 100000,
      occurredAt: DateTime(2026, 10, 15),
      note: 'Cash withdrawal',
    );

    expect(result, isA<Success<Transaction>>());
    final transactions = await transactionRepository.getTransactions();
    expect(transactions, hasLength(1));
    expect(transactions.first.kind, TransactionKind.transfer);
  });

  test('DeleteTransaction soft deletes and UndoDelete restores it', () async {
    final create = AddExpense(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final created = await create.execute(
      amountMinor: 250000,
      currency: 'PKR',
      categoryId: 'food',
      merchant: 'Dinner',
      note: 'Dinner with friends',
      occurredAt: DateTime(2026, 10, 16),
      splits: [
        const TransactionSplit(
          id: 's1',
          transactionId: 'txn-1',
          accountId: 'cash',
          amountMinor: 250000,
          direction: SplitDirection.credit,
        ),
      ],
    );

    expect(created, isA<Success<Transaction>>());

    final deleteUseCase = DeleteTransaction(
      transactionRepository: transactionRepository,
    );
    final deleted = await deleteUseCase.execute(
      (created as Success<Transaction>).value.id,
    );
    expect(deleted, isA<Success<Transaction>>());
    expect((deleted as Success<Transaction>).value.deletedAt, isNotNull);

    final undoUseCase = UndoDelete(
      transactionRepository: transactionRepository,
    );
    final restored = await undoUseCase.execute(
      (created as Success<Transaction>).value.id,
    );
    expect(restored, isA<Success<Transaction>>());
    expect((restored as Success<Transaction>).value.deletedAt, isNull);
  });

  test('EditTransaction rewrites splits atomically', () async {
    final create = AddExpense(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );
    final created = await create.execute(
      amountMinor: 200000,
      currency: 'PKR',
      categoryId: 'food',
      merchant: 'Lunch',
      note: 'Lunch',
      occurredAt: DateTime(2026, 10, 17),
      splits: [
        const TransactionSplit(
          id: 's1',
          transactionId: 'txn-1',
          accountId: 'cash',
          amountMinor: 200000,
          direction: SplitDirection.credit,
        ),
      ],
    );

    final editUseCase = EditTransaction(
      transactionRepository: transactionRepository,
    );
    final edited = await editUseCase.execute(
      transaction: (created as Success<Transaction>).value.copyWith(
        amountMinor: 250000,
        splits: [
          const TransactionSplit(
            id: 's1',
            transactionId: 'txn-1',
            accountId: 'cash',
            amountMinor: 150000,
            direction: SplitDirection.credit,
          ),
          const TransactionSplit(
            id: 's2',
            transactionId: 'txn-1',
            accountId: 'bank',
            amountMinor: 100000,
            direction: SplitDirection.credit,
          ),
        ],
      ),
    );

    expect(edited, isA<Success<Transaction>>());
    expect((edited as Success<Transaction>).value.amountMinor, 250000);
    expect(((edited as Success<Transaction>).value.splits), hasLength(2));
  });

  test('ReconcileAccount creates an adjustment transaction for the difference', () async {
    final useCase = ReconcileAccount(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final result = await useCase.execute(
      accountId: 'cash',
      actualBalanceMinor: 600000,
    );

    expect(result, isA<Success<Transaction>>());
    expect((result as Success<Transaction>).value.kind, TransactionKind.income);
  });

  test('AddIncome stores an income record', () async {
    final useCase = AddIncome(
      accountRepository: accountRepository,
      transactionRepository: transactionRepository,
    );

    final result = await useCase.execute(
      amountMinor: 450000,
      currency: 'PKR',
      accountId: 'cash',
      categoryId: 'salary',
      note: 'Salary deposit',
      occurredAt: DateTime(2026, 10, 18),
    );

    expect(result, isA<Success<Transaction>>());
  });
}
