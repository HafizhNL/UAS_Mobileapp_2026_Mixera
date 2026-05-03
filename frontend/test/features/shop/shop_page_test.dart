import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/pages/shop_page.dart';

import 'support/shop_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpShop(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
  }

  testWidgets('ShopPage shows header, search placeholder, tabs, and product', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ShopPage(),
      ),
    );
    await pumpShop(tester);

    expect(find.text('Shop'), findsOneWidget);
    expect(find.text("Discover Items you'll Love"), findsOneWidget);
    expect(find.text('Search...'), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Tops'), findsOneWidget);
    expect(find.text('Widget Test Shirt'), findsOneWidget);
  });
}
