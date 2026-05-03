import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/cart/presentation/widgets/checkout_button.dart';

void main() {
  testWidgets('calls onPressed when not loading', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CheckoutButton(onPressed: () => taps++),
        ),
      ),
    );

    await tester.tap(find.text('Proceed to Checkout'));

    expect(taps, 1);
  });

  testWidgets('shows progress indicator and disables tap while loading', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CheckoutButton(
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Proceed to Checkout'), findsNothing);
    expect(taps, 0);
  });
}
