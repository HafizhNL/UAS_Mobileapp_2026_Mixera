import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_order_detail_page.dart';

import 'support/seller_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('loads order and shows buyer and line item', (tester) async {
    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(
      const GetMaterialApp(home: SellerOrderDetailPage(orderId: 42)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Order #42'), findsOneWidget);
    expect(find.text('PROCESSING'), findsOneWidget);
    expect(find.text('Pembeli Tes'), findsOneWidget);
    expect(find.text('Kaos Widget'), findsOneWidget);
    expect(find.textContaining('Size: M'), findsOneWidget);
  });
}
