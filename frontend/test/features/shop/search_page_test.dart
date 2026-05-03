import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/pages/search_page.dart';

import 'support/shop_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('SearchPage shows popular searches; submit shows results', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SearchPage(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Popular Searches'), findsOneWidget);
    expect(find.text('Midi skirt'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'shirt');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Widget Test Shirt'), findsOneWidget);
  });
}
