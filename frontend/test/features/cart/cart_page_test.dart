import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:frontend/features/cart/presentation/pages/cart_page.dart';

import 'support/cart_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpCart(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('CartPage empty state shows message and count', (tester) async {
    Get.put<CartController>(CartController(datasource: CartWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CartPage(),
      ),
    );
    await pumpCart(tester);

    expect(find.text('My Bag'), findsOneWidget);
    expect(find.text('0 items'), findsOneWidget);
    expect(find.text('Your bag is empty'), findsOneWidget);
    expect(find.text('Continue Shopping'), findsOneWidget);
  });

  testWidgets('CartPage lists item, summary, and checkout', (tester) async {
    Get.put<CartController>(CartController(datasource: CartWithOneItemTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CartPage(),
      ),
    );
    await pumpCart(tester);

    expect(find.text('My Bag'), findsOneWidget);
    expect(find.text('1 items'), findsOneWidget);
    expect(find.text('Cart Test Tee'), findsOneWidget);
    expect(find.text('Products:'), findsOneWidget);
    expect(find.text('Proceed to Checkout'), findsOneWidget);
  });
}
