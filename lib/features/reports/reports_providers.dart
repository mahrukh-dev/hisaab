import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportSummary {
  const ReportSummary({
    required this.spendingMinor,
    required this.incomeMinor,
    required this.netMinor,
    required this.monthOverMonthDeltaPercent,
  });

  final int spendingMinor;
  final int incomeMinor;
  final int netMinor;
  final double monthOverMonthDeltaPercent;
}

final reportsProvider = Provider<ReportSummary>((ref) {
  return const ReportSummary(
    spendingMinor: 320000,
    incomeMinor: 470000,
    netMinor: 150000,
    monthOverMonthDeltaPercent: 12.4,
  );
});
