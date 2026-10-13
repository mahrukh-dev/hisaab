import 'package:flutter/material.dart';

/// The Home Dashboard screen.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hisaab'),
      ),
      body: const Center(
        child: Text('Home Dashboard'),
      ),
    );
  }
}
