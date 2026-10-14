import 'package:flutter/material.dart';
import 'package:hisaab/ai/on_device_ai_service.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final TextEditingController _controller = TextEditingController(
    text: '1200 petrol, 800 cash rest Meezan',
  );
  final _ai = OnDeviceAiService();
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _parseEntry() async {
    final text = _controller.text.trim();
    if (text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    final result = await _ai.parseEntry(
      userText: text,
      accountNames: const ['Cash', 'Meezan'],
      categories: const ['Transport', 'Food', 'Bills'],
    );

    if (!mounted) {
      return;
    }

    setState(() => _isLoading = false);

    if (!result.isSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.messageOrNull ?? 'Unable to parse entry.')),
      );
      return;
    }

    final draft = result.value;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI draft transaction'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kind: ${draft.kind}'),
              const SizedBox(height: 8),
              Text('Amount: PKR ${(draft.amountMinor / 100).toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Category: ${draft.category}'),
              const SizedBox(height: 8),
              Text('Merchant: ${draft.merchant}'),
              const SizedBox(height: 12),
              const Text('Splits:'),
              ...draft.splits.map(
                (split) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '- ${split.account}: PKR ${(split.amountMinor / 100).toStringAsFixed(2)}',
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI assistant'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick add from natural language',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              minLines: 3,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Example: 1200 petrol, 800 cash rest Meezan',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _ExampleChip(label: '1200 petrol, 800 cash rest Meezan'),
                _ExampleChip(label: '850 food and rest Meezan'),
                _ExampleChip(label: 'rent due this month'),
              ],
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _isLoading ? null : _parseEntry,
              icon: _isLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.auto_awesome),
              label: Text(_isLoading ? 'Parsing…' : 'Parse entry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExampleChip extends StatelessWidget {
  const _ExampleChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        final screen = context.findAncestorStateOfType<_AiAssistantScreenState>();
        screen?._controller.text = label;
      },
    );
  }
}
