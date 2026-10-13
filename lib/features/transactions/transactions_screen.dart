import 'package:flutter/material.dart';

/// The Transactions Screen.
class TransactionsScreen extends StatelessWidget {
  /// Creates a [TransactionsScreen].
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: const Center(
        child: Text('Transactions List'),
      ),
    );
  }
}
