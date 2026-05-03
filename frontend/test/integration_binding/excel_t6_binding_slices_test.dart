/// Excel No 19 / T6-style checks using [IntegrationTestWidgetsFlutterBinding] on the **host**
/// (no `integration_test/` device build). Run:
/// `flutter test test/integration_binding/excel_t6_binding_slices_test.dart`

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/checkout/presentation/pages/card_tokenize_page.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/mix_match_page.dart';
import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';
import 'package:frontend/features/seller/presentation/pages/seller_shell_page.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/pages/shop_page.dart';

import '../features/auth/support/auth_widget_test_doubles.dart';
import '../features/mix_match/support/mix_match_widget_test_doubles.dart';
import '../features/seller/support/seller_widget_test_doubles.dart';
import '../features/shop/support/shop_widget_test_doubles.dart';
import '../features/wardrobe/support/wardrobe_widget_test_doubles.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final base = Directory.systemTemp.createTempSync('mixera_t6_font_cache_');
    addTearDown(() {
      if (base.existsSync()) {
        base.deleteSync(recursive: true);
      }
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

  testWidgets('LoginPage + AuthController (primary auth slice)', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('ShopPage (shopping conversion slice)', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: ShopPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Widget Test Shirt'), findsOneWidget);
  });

  testWidgets('CardTokenizePage (card payment slice)', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CardTokenizePage(
          args: CardTokenizeArgs(clientKey: 'SB-Mid-client', total: 50000),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '4242424242424242');
    await tester.pump();
    final field = tester.widget<TextFormField>(fields.first);
    expect(field.controller?.text, '4242 4242 4242 4242');
  });

  testWidgets('MixMatchPage (wardrobe → mix slice)', (tester) async {
    final wardrobe = MixMatchSpotlightWardrobeDatasource();
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: wardrobe,
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: MixMatchPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Mix & Match'), findsOneWidget);
    expect(find.text('Start mixing'), findsOneWidget);
  });

  testWidgets('SellerShellPage (seller ops slice)', (tester) async {
    Get.put(SellerController(datasource: SellerWidgetTestDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: SellerShellPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Toko Widget'), findsOneWidget);
    expect(find.text('Total Order'), findsOneWidget);
  });
}
