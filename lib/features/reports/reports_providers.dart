import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportSummary {
  const ReportSummary({
    required this.spendingMinor,
    required this.incomeMinor,
    required this.netMinor,
    required this.monthOverMonthDeltaPercent,
  });

  factory ReportSummary.calculate({
    required int spendingMinor,
    required int incomeMinor,
    required int previousSpendingMinor,
  }) {
    final delta = previousSpendingMinor <= 0
        ? 0.0
        : ((spendingMinor - previousSpendingMinor) / previousSpendingMinor) * 100;

    return ReportSummary(
      spendingMinor: spendingMinor,
      incomeMinor: incomeMinor,
      netMinor: incomeMinor - spendingMinor,
      monthOverMonthDeltaPercent: delta,
    );
  }

  final int spendingMinor;
  final int incomeMinor;
  final int netMinor;
  final double monthOverMonthDeltaPercent;
}

final reportsProvider = Provider<ReportSummary>((ref) {
  return ReportSummary.calculate(
    spendingMinor: 320000,
    incomeMinor: 470000,
    previousSpendingMinor: 275000,
  );
});
