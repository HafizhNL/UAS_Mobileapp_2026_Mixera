import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/widgets/category_tabs.dart';

import 'support/shop_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('CategoryTabs lists All plus categories from controller', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: CategoryTabs(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Tops'), findsOneWidget);

    await tester.tap(find.text('Tops'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(Get.find<ShopController>().selectedCategorySlug.value, 'top');
  });
}
