import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/shop/data/models/product_model.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/widgets/product_grid.dart';

import 'support/shop_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('ProductGrid lists product title and price', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));

    const p = ProductModel(
      id: 2,
      name: 'Grid Test Tee',
      slug: 'grid-test-tee',
      price: 99000,
      primaryImage: 'https://example.com/tee.jpg',
    );

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ProductGrid(
              products: const [p],
              onTap: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Grid Test Tee'), findsOneWidget);
    expect(find.textContaining('Rp'), findsWidgets);
  });
}
