import 'package:flutter/material.dart';

/// The Budgets Screen.
class BudgetsScreen extends StatelessWidget {
  /// Creates a [BudgetsScreen].
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets'),
      ),
      body: const Center(
        child: Text('Budgets Overview'),
      ),
    );
  }
}
