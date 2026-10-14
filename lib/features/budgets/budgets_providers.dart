import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/domain/usecases/compute_budget_progress.dart';

class BudgetEntry {
  const BudgetEntry({
    required this.category,
    required this.limitMinor,
    required this.spentMinor,
    required this.period,
  });

  final String category;
  final int limitMinor;
  final int spentMinor;
  final String period;

  BudgetProgress get progress => const ComputeBudgetProgress().execute(
        budgetMinor: limitMinor,
        spentMinor: spentMinor,
      ).value;
}

class BudgetSummary {
  const BudgetSummary({
    required this.totalLimitMinor,
    required this.totalSpentMinor,
    required this.totalRemainingMinor,
    required this.percent,
  });

  final int totalLimitMinor;
  final int totalSpentMinor;
  final int totalRemainingMinor;
  final double percent;
}

class RecurringEntry {
  const RecurringEntry({
    required this.label,
    required this.schedule,
    required this.amountMinor,
  });

  final String label;
  final String schedule;
  final int amountMinor;
}

final budgetsProvider = Provider<List<BudgetEntry>>((ref) {
  return const [
    BudgetEntry(
      category: 'Food & Dining',
      limitMinor: 50000,
      spentMinor: 32000,
      period: 'This month',
    ),
    BudgetEntry(
      category: 'Transport',
      limitMinor: 20000,
      spentMinor: 14500,
      period: 'This month',
    ),
    BudgetEntry(
      category: 'Utilities',
      limitMinor: 15000,
      spentMinor: 9000,
      period: 'This month',
    ),
  ];
});

final budgetsSummaryProvider = Provider<BudgetSummary>((ref) {
  final entries = ref.watch(budgetsProvider);
  final totalLimitMinor = entries.fold<int>(0, (sum, item) => sum + item.limitMinor);
  final totalSpentMinor = entries.fold<int>(0, (sum, item) => sum + item.spentMinor);
  final progress = const ComputeBudgetProgress().execute(
    budgetMinor: totalLimitMinor,
    spentMinor: totalSpentMinor,
  );

  final validProgress = progress.value;

  return BudgetSummary(
    totalLimitMinor: totalLimitMinor,
    totalSpentMinor: totalSpentMinor,
    totalRemainingMinor: validProgress.remainingMinor,
    percent: validProgress.percent,
  );
});

final recurringProvider = Provider<List<RecurringEntry>>((ref) {
  return const [
    RecurringEntry(
      label: 'Rent',
      schedule: 'Monthly • 1st',
      amountMinor: 75000,
    ),
    RecurringEntry(
      label: 'Internet',
      schedule: 'Monthly • 9th',
      amountMinor: 1800,
    ),
    RecurringEntry(
      label: 'Gym',
      schedule: 'Monthly • 15th',
      amountMinor: 3500,
    ),
  ];
});
