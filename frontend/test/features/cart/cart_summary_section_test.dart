import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/cart/presentation/widgets/cart_summary_section.dart';

void main() {
  testWidgets('CartSummarySection shows lines and computed total', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CartSummarySection(subtotal: 100000),
        ),
      ),
    );

    expect(find.text('Products:'), findsOneWidget);
    expect(find.text('Delivery'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.textContaining('Rp'), findsWidgets);
  });
}
