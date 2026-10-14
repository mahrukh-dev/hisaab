import 'package:flutter/material.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accounts = [
      _AccountTile(
        name: 'Cash',
        type: 'Cash',
        balance: 650000,
        color: Colors.green,
      ),
      _AccountTile(
        name: 'Meezan',
        type: 'Bank',
        balance: 975000,
        color: Colors.blue,
      ),
      _AccountTile(
        name: 'Easypaisa',
        type: 'Wallet',
        balance: 200000,
        color: Colors.orange,
      ),
      _AccountTile(
        name: 'Credit Card',
        type: 'Card',
        balance: -35000,
        color: Colors.purple,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final account = accounts[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: account.color.withOpacity(0.12),
                child: Icon(
                  account.type == 'Cash'
                      ? Icons.account_balance_wallet
                      : account.type == 'Bank'
                          ? Icons.account_balance
                          : account.type == 'Wallet'
                              ? Icons.wallet
                              : Icons.credit_card,
                  color: account.color,
                ),
              ),
              title: Text(account.name),
              subtitle: Text(account.type),
              trailing: Text(
                '${account.balance >= 0 ? '+ ' : '- '}PKR ${account.balance.abs()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: account.balance >= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemCount: accounts.length,
      ),
    );
  }
}

class _AccountTile {
  const _AccountTile({
    required this.name,
    required this.type,
    required this.balance,
    required this.color,
  });

  final String name;
  final String type;
  final int balance;
  final Color color;
}
