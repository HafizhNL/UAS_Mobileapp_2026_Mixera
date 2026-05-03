import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_finance_page.dart';

import 'support/seller_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows balance card, payout section, and empty lists', (tester) async {
    tester.view.physicalSize = const Size(400, 3000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: SellerFinancePage(),
        ),
      ),
    );
    await tester.pump();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.text('Saldo Tersedia'), findsOneWidget);
    expect(find.textContaining('Rp 100.000'), findsWidgets);
    expect(find.text('Tarik Saldo'), findsOneWidget);
    expect(find.text('Ajukan Pencairan'), findsOneWidget);
    expect(find.text('Export CSV pendapatan'), findsOneWidget);
    expect(find.text('Penarikan Payout'), findsOneWidget);
    expect(find.text('Riwayat Pendapatan'), findsOneWidget);
    expect(find.text('Cek Ongkir'), findsOneWidget);
    expect(find.text('Hitung Ongkir'), findsOneWidget);
  });
}
