/// Device-level seller ops slice (T6).
///
/// Host / CI fallback:
/// `flutter test test/integration_binding/excel_t6_binding_slices_test.dart`
///
/// Device:
/// `flutter test integration_test/seller/seller_ops_critical_test.dart -d <androidId>`

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_shell_page.dart';

import '../../test/features/seller/support/seller_widget_test_doubles.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final base = Directory.systemTemp.createTempSync('mixera_it_seller_');
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

  testWidgets('SellerShellPage renders store name and dashboard totals', (tester) async {
    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerShellPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Toko Widget'), findsWidgets);
    expect(find.text('Total Order'), findsOneWidget);
  });
}
