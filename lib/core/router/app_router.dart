import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hisaab/features/accounts/accounts_screen.dart';
import 'package:hisaab/features/budgets/budgets_screen.dart';
import 'package:hisaab/features/home/home_screen.dart';
import 'package:hisaab/features/main_shell_screen.dart';
import 'package:hisaab/features/reports/reports_screen.dart';
import 'package:hisaab/features/settings/settings_screen.dart';
import 'package:hisaab/features/transactions/add_transaction_screen.dart';
import 'package:hisaab/features/transactions/transactions_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Defines the GoRouter navigation routes for the application.
final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/transactions',
              builder: (context, state) => const TransactionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/budgets',
              builder: (context, state) => const BudgetsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reports',
              builder: (context, state) => const ReportsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/accounts',
      builder: (context, state) => const AccountsScreen(),
    ),
    GoRoute(
      path: '/transactions/add',
      builder: (context, state) => const AddTransactionScreen(),
    ),
  ],
);
