/// Device-level primary auth slice (T6).
///
/// Host / CI fallback (tanpa build device):
/// `flutter test test/integration_binding/excel_t6_binding_slices_test.dart`
///
/// Device:
/// `flutter test integration_test/auth/primary_auth_flow_test.dart -d <androidId>`

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';

import '../../test/features/auth/support/auth_widget_test_doubles.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final base = Directory.systemTemp.createTempSync('mixera_it_auth_');
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

  testWidgets('LoginPage renders email field and login button', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });

  testWidgets('Login form stays visible after empty submit (validation guard)', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());
    await tester.pumpWidget(const GetMaterialApp(home: LoginPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.tap(find.text('Login').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Email'), findsOneWidget);
  });
}
