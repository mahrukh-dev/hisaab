import 'package:flutter/material.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _kind = 'Expense';
  final _amountController = TextEditingController(text: '2500');

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final amount = int.tryParse(_amountController.text) ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add transaction'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Expense', label: Text('Expense')),
              ButtonSegment(value: 'Income', label: Text('Income')),
              ButtonSegment(value: 'Transfer', label: Text('Transfer')),
            ],
            selected: {_kind},
            onSelectionChanged: (selection) {
              setState(() => _kind = selection.first);
            },
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Amount',
              prefixText: 'PKR ',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            children: const [
              ChoiceChip(label: Text('Food'), selected: true),
              ChoiceChip(label: Text('Transport'), selected: false),
              ChoiceChip(label: Text('Salary'), selected: false),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Split payment'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  _splitRow('Cash', 1500),
                  const Divider(),
                  _splitRow('Bank', 1000),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining to allocate'),
                      Text(
                        '${amount - 2500} PKR',
                        style: TextStyle(
                          color: amount == 2500 ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Note',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: amount > 0 ? () {} : null,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save transaction'),
          ),
        ],
      ),
    );
  }

  Widget _splitRow(String account, int value) {
    return Row(
      children: [
        Expanded(child: Text(account)),
        SizedBox(
          width: 120,
          child: TextFormField(
            initialValue: value.toString(),
            textAlign: TextAlign.end,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              isDense: true,
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}
