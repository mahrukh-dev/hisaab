import 'package:flutter/material.dart';

/// The Reports Screen.
class ReportsScreen extends StatelessWidget {
  /// Creates a [ReportsScreen].
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: const Center(
        child: Text('Financial Reports'),
      ),
    );
  }
}
