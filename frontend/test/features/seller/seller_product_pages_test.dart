import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/shop/data/models/product_model.dart';
import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_add_product_page.dart';
import 'package:frontend/features/seller/presentation/pages/seller_edit_product_page.dart';

import 'support/seller_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets('SellerAddProductPage shows main sections', (tester) async {
    tester.view.physicalSize = const Size(900, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerAddProductPage()));
    await tester.pumpAndSettle();

    expect(find.text('Produk baru'), findsOneWidget);
    expect(find.text('Informasi Dasar'), findsOneWidget);
    expect(find.text('Varian & Stok', skipOffstage: false), findsOneWidget);
    expect(find.text('Simpan Produk', skipOffstage: false), findsOneWidget);
  });

  testWidgets('SellerAddProductPage validates required name and price', (tester) async {
    tester.view.physicalSize = const Size(900, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerAddProductPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Simpan Produk'));
    await tester.pump();

    expect(find.text('Nama dan harga wajib diisi.'), findsOneWidget);
  });

  testWidgets('SellerEditProductPage loads detail title from fake API',
      (tester) async {
    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    const product = ProductModel(
      id: 1,
      name: 'Local',
      slug: 'local',
      price: 5000,
    );
    await tester.pumpWidget(
      const GetMaterialApp(home: SellerEditProductPage(product: product)),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Edit produk'), findsOneWidget);
    expect(find.text('Widget Produk'), findsWidgets);
  });
}
