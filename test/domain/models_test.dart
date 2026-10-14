import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/domain/models/account.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/usecases/split_validator.dart';

void main() {
  group('Domain models', () {
    test('Account JSON round trip works', () {
      const account = Account(
        id: 'cash',
        name: 'Cash',
        type: AccountType.cash,
        currency: 'PKR',
        openingBalanceMinor: 250000,
      );

      final json = account.toJson();
      final roundTrip = Account.fromJson(json);

      expect(json['name'], 'Cash');
      expect(roundTrip, equals(account));
    });

    test('Transaction JSON round trip works', () {
      final now = DateTime(2026, 10, 14);
      final transaction = Transaction(
        id: 'txn-1',
        kind: TransactionKind.expense,
        amountMinor: 150000,
        occurredAt: now,
        createdAt: now,
        currency: 'PKR',
        categoryId: 'food',
        merchant: 'Groceries',
        note: 'Weekly shop',
        source: TransactionSource.manual,
        splits: const [],
      );

      final json = transaction.toJson();
      final roundTrip = Transaction.fromJson(json);

      expect(json['merchant'], 'Groceries');
      expect(roundTrip, equals(transaction));
    });
  });

  group('SplitValidator', () {
    test('accepts a valid expense split', () {
      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 250000,
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
      );

      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('rejects split totals that do not match', () {
      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 250000,
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
            amountMinor: 90000,
            direction: SplitDirection.credit,
          ),
        ],
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('does not match'));
    });
  });
}
