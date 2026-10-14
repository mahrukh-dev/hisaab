import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<_TransactionEntry> _allTransactions = const [
    _TransactionEntry(
      title: 'Groceries',
      subtitle: 'Food & Dining • 12 Oct',
      amountMinor: 26000,
      isExpense: true,
    ),
    _TransactionEntry(
      title: 'Salary',
      subtitle: 'Salary • 10 Oct',
      amountMinor: 120000,
      isExpense: false,
    ),
    _TransactionEntry(
      title: 'Fuel',
      subtitle: 'Transport • 8 Oct',
      amountMinor: 5000,
      isExpense: true,
    ),
    _TransactionEntry(
      title: 'Transfer',
      subtitle: 'Cash to Meezan • 6 Oct',
      amountMinor: 25000,
      isExpense: false,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final transactions = query.isEmpty
        ? _allTransactions
        : _allTransactions.where((entry) {
            final title = entry.title.toLowerCase();
            final subtitle = entry.subtitle.toLowerCase();
            return title.contains(query) || subtitle.contains(query);
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transactions/add'),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search transactions',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (query.isEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent activity',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = transactions[index];
                  return ListTile(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionEntry {
  const _TransactionEntry({
    required this.title,
    required this.subtitle,
    required this.amountMinor,
    required this.isExpense,
  });

  final String title;
  final String subtitle;
  final int amountMinor;
  final bool isExpense;
}
