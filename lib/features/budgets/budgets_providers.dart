import 'package:flutter_riverpod/flutter_riverpod.dart';

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
