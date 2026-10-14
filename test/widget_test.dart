import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/main.dart';

void main() {
  testWidgets('App renders the home dashboard on startup', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HisaabApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hisaab'), findsOneWidget);
    expect(find.text('Net worth'), findsOneWidget);
  });
}
