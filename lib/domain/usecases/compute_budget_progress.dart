import 'package:hisaab/core/result.dart';

class BudgetProgress {
  const BudgetProgress({
    required this.budgetMinor,
    required this.spentMinor,
    required this.remainingMinor,
    required this.percent,
  });

  final int budgetMinor;
  final int spentMinor;
  final int remainingMinor;
  final double percent;
}

class ComputeBudgetProgress {
  const ComputeBudgetProgress();

  Result<BudgetProgress> execute({
    required int budgetMinor,
    required int spentMinor,
  }) {
    if (budgetMinor <= 0) {
      return Result.failure('Budget must be greater than zero.');
    }

    final remaining = budgetMinor - spentMinor;
    final percent = (spentMinor / budgetMinor).clamp(0.0, 1.0);

    return Result.success(
      BudgetProgress(
        budgetMinor: budgetMinor,
        spentMinor: spentMinor,
        remainingMinor: remaining,
        percent: percent,
      ),
    );
  }
}
