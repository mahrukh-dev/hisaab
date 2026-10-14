import 'package:hisaab/core/result.dart';

abstract class AiService {
  Future<Result<AiCategorySuggestion>> categorize({
    required String merchant,
    required String note,
    required List<String> categories,
  });

  Future<Result<AiDraftTransaction>> parseEntry({
    required String userText,
    required List<String> accountNames,
    required List<String> categories,
  });

  Future<Result<ReceiptExtraction>> extractReceipt({
    required String ocrText,
  });

  Future<Result<AiInsights>> generateInsights({
    required Map<String, dynamic> monthSummary,
  });

  Future<Result<String>> answerQuestion({
    required String question,
  });
}

class AiCategorySuggestion {
  const AiCategorySuggestion({
    required this.category,
    required this.confidence,
  });

  final String category;
  final double confidence;
}

class AiSplitDraft {
  const AiSplitDraft({
    required this.account,
    required this.amountMinor,
  });

  final String account;
  final int amountMinor;
}

class AiDraftTransaction {
  const AiDraftTransaction({
    required this.kind,
    required this.amountMinor,
    required this.currency,
    required this.category,
    required this.merchant,
    required this.occurredAt,
    required this.splits,
    required this.confidence,
    this.needsClarification,
  });

  final String kind;
  final int amountMinor;
  final String currency;
  final String category;
  final String merchant;
  final DateTime occurredAt;
  final List<AiSplitDraft> splits;
  final double confidence;
  final String? needsClarification;
}

class ReceiptExtraction {
  const ReceiptExtraction({
    required this.merchant,
    required this.totalMinor,
    required this.currency,
    required this.items,
    this.occurredAt,
    this.taxMinor,
    this.suggestedCategory,
  });

  final String merchant;
  final int totalMinor;
  final String currency;
  final DateTime? occurredAt;
  final int? taxMinor;
  final String? suggestedCategory;
  final List<ReceiptLineItem> items;
}

class ReceiptLineItem {
  const ReceiptLineItem({
    required this.name,
    required this.amountMinor,
  });

  final String name;
  final int amountMinor;
}

class AiInsights {
  const AiInsights({
    required this.insights,
    required this.suggestions,
  });

  final List<String> insights;
  final List<String> suggestions;
}
