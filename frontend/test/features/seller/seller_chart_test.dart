import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_shell_page.dart';

import 'support/seller_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('dashboard shows sales chart header and painted chart', (tester) async {
    tester.view.physicalSize = const Size(900, 3200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerShellPage()));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Grafik Penjualan'), findsOneWidget);
    expect(find.text('8 minggu terakhir'), findsOneWidget);

    expect(
      find.descendant(
        of: find.byType(SellerShellPage),
        matching: find.byType(CustomPaint),
      ),
      findsWidgets,
    );
  });
}
