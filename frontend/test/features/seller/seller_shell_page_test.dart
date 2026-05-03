import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_shell_page.dart';

import 'support/seller_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows store title and dashboard stats from fake seller API',
      (tester) async {
    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerShellPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Toko Widget'), findsOneWidget);
    expect(find.text('Total Order'), findsOneWidget);
    expect(find.text('3'), findsWidgets);
    expect(find.text('Estimasi Saldo'), findsOneWidget);
    expect(find.textContaining('Rp'), findsWidgets);
    expect(find.text('Mode pembeli'), findsOneWidget);
  });

  testWidgets('Produk tab shows empty catalog copy', (tester) async {
    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerShellPage()));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Produk'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Belum ada produk.'), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
  });
}
