import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountSummary {
  const AccountSummary({
    required this.id,
    required this.name,
    required this.type,
    required this.balanceMinor,
  });

  final String id;
  final String name;
  final String type;
  final int balanceMinor;
}

class RecentTransactionSummary {
  const RecentTransactionSummary({
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

class HomeDashboardData {
  const HomeDashboardData({
    required this.netWorthMinor,
    required this.accounts,
    required this.recentTransactions,
  });

  final int netWorthMinor;
  final List<AccountSummary> accounts;
  final List<RecentTransactionSummary> recentTransactions;
}

final homeDashboardProvider = Provider<HomeDashboardData>((ref) {
  return const HomeDashboardData(
    netWorthMinor: 1825000,
    accounts: [
      AccountSummary(
        id: 'cash',
        name: 'Cash',
        type: 'Cash',
        balanceMinor: 650000,
      ),
      AccountSummary(
        id: 'bank',
        name: 'Meezan',
        type: 'Bank',
        balanceMinor: 975000,
      ),
      AccountSummary(
        id: 'wallet',
        name: 'Easypaisa',
        type: 'Wallet',
        balanceMinor: 200000,
      ),
    ],
    recentTransactions: [
      RecentTransactionSummary(
        title: 'Groceries',
        subtitle: 'Today • Food & Dining',
        amountMinor: 26000,
        isExpense: true,
      ),
      RecentTransactionSummary(
        title: 'Salary',
        subtitle: 'Yesterday • Salary',
        amountMinor: 120000,
        isExpense: false,
      ),
      RecentTransactionSummary(
        title: 'Fuel',
        subtitle: 'Tue • Transport',
        amountMinor: 5000,
        isExpense: true,
      ),
    ],
  );
});
