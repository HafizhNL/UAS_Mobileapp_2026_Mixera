/// Device-level shopping catalog slice (T6).
///
/// Host / CI fallback:
/// `flutter test test/integration_binding/excel_t6_binding_slices_test.dart`
///
/// Device:
/// `flutter test integration_test/commerce/shopping_conversion_test.dart -d <androidId>`

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/pages/shop_page.dart';

import '../../test/features/shop/support/shop_widget_test_doubles.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final base = Directory.systemTemp.createTempSync('mixera_it_shop_');
    addTearDown(() {
      if (base.existsSync()) base.deleteSync(recursive: true);
    });
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getApplicationSupportDirectory':
        case 'getTemporaryDirectory':
        case 'getApplicationDocumentsDirectory':
          return base.path;
        default:
          return null;
      }
    });
  });

  tearDown(Get.reset);

  testWidgets('ShopPage renders catalog with sample product', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: ShopPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Widget Test Shirt'), findsOneWidget);
  });

  testWidgets('ShopPage catalog product count is stable', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: ShopPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Widget Test Shirt'), findsOneWidget);
  });
}
