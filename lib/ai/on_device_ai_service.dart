import 'dart:math' as math;

import 'package:hisaab/ai/ai_service.dart';
import 'package:hisaab/core/result.dart';

class OnDeviceAiService implements AiService {
  @override
  Future<Result<AiCategorySuggestion>> categorize({
    required String merchant,
    required String note,
    required List<String> categories,
  }) async {
    final text = '${merchant.trim()} ${note.trim()}'.toLowerCase();

    final categoryMap = {
      'transport': 'Transport',
      'fuel': 'Transport',
      'petrol': 'Transport',
      'gas': 'Transport',
      'travel': 'Transport',
      'food': 'Food',
      'groceries': 'Food',
      'milk': 'Food',
      'restaurant': 'Food',
      'bill': 'Bills',
      'electric': 'Bills',
      'water': 'Bills',
      'internet': 'Bills',
      'rent': 'Bills',
    };

    for (final entry in categoryMap.entries) {
      if (text.contains(entry.key)) {
        final category = categories.contains(entry.value) ? entry.value : entry.value;
        return Result.success(
          AiCategorySuggestion(
            category: category,
            confidence: 0.92,
          ),
        );
      }
    }

    final fallback = categories.isNotEmpty ? categories.first : 'Other';
    return Result.success(
      AiCategorySuggestion(
        category: fallback,
        confidence: 0.45,
      ),
    );
  }

  @override
  Future<Result<AiDraftTransaction>> parseEntry({
    required String userText,
    required List<String> accountNames,
    required List<String> categories,
  }) async {
    final normalized = userText.trim();
    final amountMatch = RegExp(r'(\d+(?:,\d{3})*(?:\.\d+)?)').firstMatch(normalized);
    final rawAmount = amountMatch == null ? 0 : double.tryParse(amountMatch.group(1)!.replaceAll(',', '')) ?? 0;
    final amountMinor = (rawAmount * 100).round();

    if (amountMinor <= 0) {
      return Result.failure('No amount could be parsed from the entry.');
    }

    final lower = normalized.toLowerCase();
    final cashName = accountNames.firstWhere(
      (name) => lower.contains(name.toLowerCase()),
      orElse: () => accountNames.firstOrNull ?? 'Cash',
    );
    final otherName = accountNames
        .where((name) => name.toLowerCase() != cashName.toLowerCase())
        .firstOrNull ??
        'Meezan';

    final firstSplitAmount = lower.contains('cash')
        ? _findAmountBeforeKeyword(normalized, 'cash')
        : (amountMinor / 2).round();
    final remainder = (amountMinor - firstSplitAmount).clamp(0, amountMinor);

    final splits = <AiSplitDraft>[
      AiSplitDraft(
        account: cashName,
        amountMinor: firstSplitAmount,
      ),
      AiSplitDraft(
        account: otherName,
        amountMinor: remainder,
      ),
    ];

    final category = categories.isNotEmpty ? categories.first : 'Transport';
    final merchant = lower.contains('petrol')
        ? 'Petrol'
        : 'Merchant';

    return Result.success(
      AiDraftTransaction(
        kind: 'expense',
        amountMinor: amountMinor,
        currency: 'PKR',
        category: category,
        merchant: merchant,
        occurredAt: DateTime.now(),
        splits: splits,
        confidence: 0.9,
      ),
    );
  }

  @override
  Future<Result<ReceiptExtraction>> extractReceipt({
    required String ocrText,
  }) async {
    final totalMatch = RegExp(r'(?:total|grand total)\D*(\d+(?:,\d{3})*(?:\.\d+)?)')
        .firstMatch(ocrText);
    final value = totalMatch == null ? 0 : double.tryParse(totalMatch.group(1)!.replaceAll(',', '')) ?? 0;

    return Result.success(
      ReceiptExtraction(
        merchant: 'Receipt merchant',
        totalMinor: (value * 100).round(),
        currency: 'PKR',
        items: const [ReceiptLineItem(name: 'Purchase', amountMinor: 0)],
        suggestedCategory: 'Food',
      ),
    );
  }

  @override
  Future<Result<AiInsights>> generateInsights({
    required Map<String, dynamic> monthSummary,
  }) async {
    final totalSpent = monthSummary['total_spent'] as num? ?? 0;
    final totalIncome = monthSummary['total_income'] as num? ?? 0;
    final insight = 'Spent PKR ${totalSpent.toInt()} while earning PKR ${totalIncome.toInt()}.';

    return Result.success(
      AiInsights(
        insights: [insight],
        suggestions: const ['Keep discretionary spending under your weekly cap.'],
      ),
    );
  }

  @override
  Future<Result<String>> answerQuestion({
    required String question,
  }) async {
    final lowerQuestion = question.toLowerCase();
    if (lowerQuestion.contains('spend') || lowerQuestion.contains('budget')) {
      return Result.success('Your spending is concentrated in essentials and groceries this month.');
    }
    return Result.success('I can help summarize your recent spending patterns.');
  }

  int _findAmountBeforeKeyword(String text, String keyword) {
    final pattern = RegExp('(\\d+(?:,\\d{3})*(?:\\.\\d+)?)\\s*${RegExp.escape(keyword)}', caseSensitive: false);
    final match = pattern.firstMatch(text);
    if (match == null) {
      return 0;
    }
    final value = double.tryParse(match.group(1)!.replaceAll(',', '')) ?? 0;
    return (value * 100).round();
  }
}

extension on List<String> {
  String? get firstOrNull => isEmpty ? null : first;
}
