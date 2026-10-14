import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hisaab/features/home/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(homeDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisaab'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SummaryCard(
            label: 'Net worth',
            value: 'PKR ${dashboard.netWorthMinor}',
            accent: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SummaryCard(
                  label: 'This month',
                  value: 'PKR 320K',
                  accent: Colors.deepOrange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SummaryCard(
                  label: 'Budget left',
                  value: 'PKR 120K',
                  accent: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Accounts',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () => context.go('/accounts'),
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...dashboard.accounts.map(
            (account) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(
                    account.type == 'Cash'
                        ? Icons.account_balance_wallet
                        : account.type == 'Bank'
                            ? Icons.account_balance
                            : Icons.wallet,
                  ),
                ),
                title: Text(account.name),
                subtitle: Text(account.type),
                trailing: Text(
                  'PKR ${account.balanceMinor}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Recent transactions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...dashboard.recentTransactions.map(
            (item) => ListTile(
              leading: CircleAvatar(
                backgroundColor: item.isExpense
                    ? Colors.red.withOpacity(0.12)
                    : Colors.green.withOpacity(0.12),
                child: Icon(
                  item.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                  color: item.isExpense ? Colors.red : Colors.green,
                ),
              ),
              title: Text(item.title),
              subtitle: Text(item.subtitle),
              trailing: Text(
                '${item.isExpense ? '-' : '+'} PKR ${item.amountMinor}',
                style: TextStyle(
                  color: item.isExpense ? Colors.red : Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: accent.withOpacity(0.08),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
