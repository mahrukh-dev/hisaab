import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hisaab/features/budgets/budgets_providers.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgets = ref.watch(budgetsProvider);
    final recurring = ref.watch(recurringProvider);
    final summary = ref.watch(budgetsSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Monthly budget status',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Spent: PKR ${summary.totalSpentMinor} / PKR ${summary.totalLimitMinor}',
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: summary.percent,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Category limits',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...budgets.map(
            (budget) {
              final progress = (budget.spentMinor / budget.limitMinor)
                  .clamp(0.0, 1.0)
                  .toDouble();

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(budget.category),
                          Text(
                            'PKR ${budget.spentMinor} / ${budget.limitMinor}',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            'Recurring',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...recurring.map(
            (entry) => Card(
              child: ListTile(
                title: Text(entry.label),
                subtitle: Text(entry.schedule),
                trailing: Text('PKR ${entry.amountMinor}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
