import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/checkout/presentation/pages/card_tokenize_page.dart';

void main() {
  Future<void> pumpPage(
    WidgetTester tester, {
    String clientKey = '',
    int total = 100000,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: CardTokenizePage(
          args: CardTokenizeArgs(clientKey: clientKey, total: total),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder cardNumberField() => find.byType(TextFormField).at(0);

  testWidgets('formats card number with spaces every four digits', (tester) async {
    await pumpPage(tester);

    await tester.enterText(cardNumberField(), '4242424242424242');
    await tester.pump();

    final field = tester.widget<TextFormField>(cardNumberField());
    expect(field.controller?.text, '4242 4242 4242 4242');
  });

  testWidgets('shows Midtrans client key error when key is empty after valid form', (tester) async {
    await pumpPage(tester, clientKey: '   ');

    await tester.enterText(cardNumberField(), '4242424242424242');
    await tester.enterText(find.byType(TextFormField).at(1), '12');
    await tester.enterText(find.byType(TextFormField).at(2), '2030');
    await tester.enterText(find.byType(TextFormField).at(3), '123');
    await tester.pump();

    await tester.tap(find.text('Tokenize Card'));
    await tester.pump();
    await tester.pump();

    expect(find.textContaining('Midtrans client key'), findsOneWidget);
  });

  testWidgets('close icon pops route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const CardTokenizePage(
                      args: CardTokenizeArgs(clientKey: 'x', total: 1),
                    ),
                  ),
                );
              },
              child: const Text('OpenTokenize'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('OpenTokenize'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();

    expect(find.text('OpenTokenize'), findsOneWidget);
    expect(find.text('Card Details'), findsNothing);
  });
}
