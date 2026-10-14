import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hisaab/ai/ai_service.dart';
import 'package:hisaab/core/result.dart';

class CloudAiService implements AiService {
  CloudAiService({
    http.Client? client,
    this.baseUrl = 'https://example.invalid',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  @override
  Future<Result<AiCategorySuggestion>> categorize({
    required String merchant,
    required String note,
    required List<String> categories,
  }) async {
    final payload = await _postJson(
      'categorize',
      {
        'merchant': merchant,
        'note': note,
        'categories': categories,
      },
    );

    if (payload.isFailure) {
      return Result.failure(payload.messageOrNull ?? 'AI categorization failed.');
    }

    final data = payload.value as Map<String, dynamic>;
    final category = (data['category'] as String?) ?? categories.firstOrNull ?? 'Other';
    final confidence = (data['confidence'] as num?)?.toDouble() ?? 0.7;

    return Result.success(
      AiCategorySuggestion(
        category: category,
        confidence: confidence,
      ),
    );
  }

  @override
  Future<Result<AiDraftTransaction>> parseEntry({
    required String userText,
    required List<String> accountNames,
    required List<String> categories,
  }) async {
    final payload = await _postJson(
      'parse-entry',
      {
        'user_text': userText,
        'accounts': accountNames,
        'categories': categories,
      },
    );

    if (payload.isFailure) {
      return Result.failure(payload.messageOrNull ?? 'AI parsing failed.');
    }

    final data = payload.value as Map<String, dynamic>;
    final splits = (data['splits'] as List<dynamic>? ?? const [])
        .map(
          (item) => AiSplitDraft(
            account: (item as Map<String, dynamic>)['account'] as String? ?? 'Cash',
            amountMinor: (item['amount_minor'] as num?)?.toInt() ?? 0,
          ),
        )
        .toList();

    return Result.success(
      AiDraftTransaction(
        kind: (data['kind'] as String?) ?? 'expense',
        amountMinor: (data['amount_minor'] as num?)?.toInt() ?? 0,
        currency: (data['currency'] as String?) ?? 'PKR',
        category: (data['category'] as String?) ?? categories.firstOrNull ?? 'Other',
        merchant: (data['merchant'] as String?) ?? 'Merchant',
        occurredAt: DateTime.tryParse((data['occurred_at'] as String?) ?? '') ?? DateTime.now(),
        splits: splits,
        confidence: (data['confidence'] as num?)?.toDouble() ?? 0.8,
        needsClarification: data['needs_clarification'] as String?,
      ),
    );
  }

  @override
  Future<Result<ReceiptExtraction>> extractReceipt({
    required String ocrText,
  }) async {
    final payload = await _postJson('receipt-scan', {'ocr_text': ocrText});
    if (payload.isFailure) {
      return Result.failure(payload.messageOrNull ?? 'Receipt parsing failed.');
    }

    final data = payload.value as Map<String, dynamic>;
    return Result.success(
      ReceiptExtraction(
        merchant: (data['merchant'] as String?) ?? 'Merchant',
        totalMinor: (data['total_minor'] as num?)?.toInt() ?? 0,
        currency: (data['currency'] as String?) ?? 'PKR',
        items: const [],
        occurredAt: DateTime.tryParse((data['occurred_at'] as String?) ?? '') ?? DateTime.now(),
        taxMinor: (data['tax_minor'] as num?)?.toInt(),
        suggestedCategory: data['suggested_category'] as String?,
      ),
    );
  }

  @override
  Future<Result<AiInsights>> generateInsights({
    required Map<String, dynamic> monthSummary,
  }) async {
    final payload = await _postJson('insights', monthSummary);
    if (payload.isFailure) {
      return Result.failure(payload.messageOrNull ?? 'Insight generation failed.');
    }

    final data = payload.value as Map<String, dynamic>;
    return Result.success(
      AiInsights(
        insights: (data['insights'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
        suggestions: (data['suggestions'] as List<dynamic>? ?? const []).map((e) => e.toString()).toList(),
      ),
    );
  }

  @override
  Future<Result<String>> answerQuestion({
    required String question,
  }) async {
    final payload = await _postJson('answer-question', {'question': question});
    if (payload.isFailure) {
      return Result.failure(payload.messageOrNull ?? 'Question answering failed.');
    }

    final data = payload.value as Map<String, dynamic>;
    final answer = data['answer'] as String? ?? 'No answer available.';
    return Result.success(answer);
  }

  Future<Result<Map<String, dynamic>>> _postJson(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse(baseUrl).resolve('/$endpoint');

    try {
      final response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode != 200) {
        return Result.failure('AI request failed: ${response.statusCode}');
      }

      final parsed = jsonDecode(response.body);
      if (parsed is! Map<String, dynamic>) {
        return Result.failure('Malformed AI response.');
      }

      return Result.success(parsed);
    } catch (_) {
      return Result.failure('AI service is unavailable.');
    }
  }
}

extension on List<String> {
  String? get firstOrNull => isEmpty ? null : first;
}
