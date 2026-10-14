import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/data/db/app_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppDatabase', () {
    test('creates the schema and seeds default categories', () async {
      final database = await AppDatabase.open(filePath: ':memory:');
      addTearDown(database.close);

      final categories = await database.getCategories();
      expect(categories, isNotEmpty);
      expect(categories.any((row) => row['id'] == 'food'), isTrue);
      expect(categories.any((row) => row['id'] == 'salary'), isTrue);
    });

    test('stores and reads account and transaction rows', () async {
      final database = await AppDatabase.open(filePath: ':memory:');
      addTearDown(database.close);

      await database.insertAccount(
        id: 'cash',
        name: 'Cash',
        type: 'cash',
        openingBalanceMinor: 500000,
      );

      await database.insertTransaction(
        id: 'txn-1',
        kind: 'expense',
        amountMinor: 150000,
        occurredAt: DateTime(2026, 10, 14, 9, 30),
        createdAt: DateTime(2026, 10, 14, 9, 31),
        currency: 'PKR',
        categoryId: 'food',
        merchant: 'Groceries',
        note: 'Weekly shop',
        source: 'manual',
        splits: const [
          {'id': 'split-1', 'account_id': 'cash', 'amount_minor': 150000, 'direction': 'credit'},
        ],
      );

      final accounts = await database.getAccounts();
      final transactions = await database.getTransactions();
      final totals = await database.monthlyTotalsByCategory(
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 31),
      );

      expect(accounts.length, 1);
      expect(transactions.length, 1);
      expect(totals.first['category_id'], 'food');
      expect(totals.first['total_amount'], 150000);
    });
  });
}
