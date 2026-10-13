import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';
import 'package:hisaab/domain/usecases/split_validator.dart';

void main() {
  group('SplitValidator', () {
    test('validates valid split expense (Rs. 5,000 = 3,000 Cash + 2,000 Bank)', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'cash_acc',
          amountMinor: 300000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 's2',
          transactionId: 't1',
          accountId: 'bank_acc',
          amountMinor: 200000,
          direction: SplitDirection.credit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 500000,
        splits: splits,
      );

      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('validates valid transfer between two accounts', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'acc_from',
          amountMinor: 1000000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 's2',
          transactionId: 't1',
          accountId: 'acc_to',
          amountMinor: 1000000,
          direction: SplitDirection.debit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.transfer,
        totalAmountMinor: 1000000,
        splits: splits,
      );

      expect(result.isValid, isTrue);
    });

    test('fails if splits list is empty', () {
      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 100000,
        splits: [],
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('cannot be empty'));
    });

    test('fails if any split amount is <= 0', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'cash_acc',
          amountMinor: 0,
          direction: SplitDirection.credit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 100000,
        splits: splits,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('greater than zero'));
    });

    test('fails if duplicate accounts are used in splits', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'same_acc',
          amountMinor: 50000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 's2',
          transactionId: 't1',
          accountId: 'same_acc',
          amountMinor: 50000,
          direction: SplitDirection.credit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 100000,
        splits: splits,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('distinct account'));
    });

    test('fails if sum of splits does not equal total transaction amount', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'cash_acc',
          amountMinor: 300000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 's2',
          transactionId: 't1',
          accountId: 'bank_acc',
          amountMinor: 100000, // Sum = 400,000, Total = 500,000
          direction: SplitDirection.credit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.expense,
        totalAmountMinor: 500000,
        splits: splits,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('does not match total amount'));
    });

    test('fails transfer if not exactly two splits', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'acc1',
          amountMinor: 100000,
          direction: SplitDirection.credit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.transfer,
        totalAmountMinor: 100000,
        splits: splits,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('exactly two splits'));
    });

    test('fails transfer if directions are not opposite (e.g. both credit)', () {
      final splits = [
        const TransactionSplit(
          id: 's1',
          transactionId: 't1',
          accountId: 'acc1',
          amountMinor: 50000,
          direction: SplitDirection.credit,
        ),
        const TransactionSplit(
          id: 's2',
          transactionId: 't1',
          accountId: 'acc2',
          amountMinor: 50000,
          direction: SplitDirection.credit,
        ),
      ];

      final result = SplitValidator.validate(
        kind: TransactionKind.transfer,
        totalAmountMinor: 100000,
        splits: splits,
      );

      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('one debit split and one credit split'));
    });
  });
}
