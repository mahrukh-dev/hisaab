import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/domain/usecases/compute_budget_progress.dart';
import 'package:hisaab/features/reports/reports_providers.dart';

void main() {
  group('Phase 5 budget and report calculations', () {
    test('computeBudgetProgress calculates remaining amount and percentage', () {
      const useCase = ComputeBudgetProgress();

      final result = useCase.execute(
        budgetMinor: 150000,
        spentMinor: 84000,
      );

      expect(result.isSuccess, isTrue);
      expect(result.value!.budgetMinor, 150000);
      expect(result.value!.spentMinor, 84000);
      expect(result.value!.remainingMinor, 66000);
      expect(result.value!.percent, closeTo(0.56, 0.0001));
    });

    test('ReportSummary.compute produces net and month-over-month delta', () {
      final summary = ReportSummary.calculate(
        spendingMinor: 320000,
        incomeMinor: 470000,
        previousSpendingMinor: 275000,
      );

      expect(summary.spendingMinor, 320000);
      expect(summary.incomeMinor, 470000);
      expect(summary.netMinor, 150000);
      expect(summary.monthOverMonthDeltaPercent, closeTo(16.36, 0.01));
    });
  });
}
