import 'package:hisaab/domain/models/transaction.dart';
import 'package:hisaab/domain/models/transaction_split.dart';

/// Validation result holding success status and an optional error message.
class SplitValidationResult {
  const SplitValidationResult._({required this.isValid, this.errorMessage});

  /// Factory for a valid result.
  factory SplitValidationResult.valid() =>
      const SplitValidationResult._(isValid: true);

  /// Factory for an invalid result with an error message.
  factory SplitValidationResult.invalid(String message) =>
      SplitValidationResult._(isValid: false, errorMessage: message);

  /// Whether the validation passed.
  final bool isValid;

  /// Error message explaining why validation failed, if applicable.
  final String? errorMessage;
}

/// Utility class validating transaction split integrity rules.
abstract class SplitValidator {
  /// Validates a list of [splits] against transaction parameters.
  static SplitValidationResult validate({
    required TransactionKind kind,
    required int totalAmountMinor,
    required List<TransactionSplit> splits,
  }) {
    if (splits.isEmpty) {
      return SplitValidationResult.invalid('Splits list cannot be empty.');
    }

    if (totalAmountMinor <= 0) {
      return SplitValidationResult.invalid(
        'Total transaction amount must be positive.',
      );
    }

    // Check every split amount > 0
    for (final split in splits) {
      if (split.amountMinor <= 0) {
        return SplitValidationResult.invalid(
          'Split amount must be greater than zero.',
        );
      }
    }

    // Check account IDs are distinct
    final accountIds = splits.map((s) => s.accountId).toSet();
    if (accountIds.length != splits.length) {
      return SplitValidationResult.invalid(
        'Each split must use a distinct account.',
      );
    }

    // Check amounts match total transaction amount
    if (kind == TransactionKind.transfer) {
      if (splits.length != 2) {
        return SplitValidationResult.invalid(
          'Transfer transactions must have exactly two splits.',
        );
      }

      final hasDebit = splits.any((s) => s.direction == SplitDirection.debit);
      final hasCredit = splits.any((s) => s.direction == SplitDirection.credit);

      if (!hasDebit || !hasCredit) {
        return SplitValidationResult.invalid(
          'Transfer transactions must have one debit split and one credit split.',
        );
      }

      for (final split in splits) {
        if (split.amountMinor != totalAmountMinor) {
          return SplitValidationResult.invalid(
            'Transfer split amount (${split.amountMinor}) does not match total '
            'amount ($totalAmountMinor).',
          );
        }
      }
    } else {
      final sumSplits = splits.fold<int>(0, (sum, s) => sum + s.amountMinor);
      if (sumSplits != totalAmountMinor) {
        return SplitValidationResult.invalid(
          'Sum of split amounts ($sumSplits) does not match total amount '
          '($totalAmountMinor).',
        );
      }
    }

    return SplitValidationResult.valid();
  }
}
