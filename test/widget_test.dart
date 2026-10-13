import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/main.dart';

void main() {
  testWidgets('App renders Home Dashboard on startup', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: HisaabApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hisaab'), findsOneWidget);
    expect(find.text('Home Dashboard'), findsOneWidget);
  });
}
