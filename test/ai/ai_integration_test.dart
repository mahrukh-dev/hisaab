import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/ai/on_device_ai_service.dart';
import 'package:hisaab/ai/redactor.dart';

void main() {
  group('AI integration layer', () {
    test('redactor strips sensitive contact and account details', () {
      const input = 'Call 0300-1234567 for Ali Khan card 4242 4242 4242 4242';

      final redacted = Redactor.redact(input);

      expect(redacted, isNot(contains('0300')));
      expect(redacted, isNot(contains('4242')));
      expect(redacted, contains('Contact'));
    });

    test('on-device AI recognizes fuel expenses and drafts a split', () async {
      final ai = OnDeviceAiService();

      final categoryResult = await ai.categorize(
        merchant: 'Petrol pump',
        note: 'Fuel for car',
        categories: const ['Transport', 'Food', 'Bills'],
      );

      expect(categoryResult.isSuccess, isTrue);
      expect(categoryResult.value.category, 'Transport');

      final draftResult = await ai.parseEntry(
        userText: '1200 petrol, 800 cash rest Meezan',
        accountNames: const ['Cash', 'Meezan'],
        categories: const ['Transport'],
      );

      expect(draftResult.isSuccess, isTrue);
      expect(draftResult.value.kind, 'expense');
      expect(draftResult.value.amountMinor, 120000);
      expect(draftResult.value.splits, hasLength(2));
      expect(draftResult.value.splits.first.amountMinor, 80000);
    });
  });
}
