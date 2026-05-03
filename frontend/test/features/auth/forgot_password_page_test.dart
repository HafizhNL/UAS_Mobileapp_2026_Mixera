import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/forgot_password_page.dart';

import 'support/auth_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpAuth(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('ForgotPasswordPage shows title and email field', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ForgotPasswordPage(),
      ),
    );
    await pumpAuth(tester);

    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Send Reset Code'), findsOneWidget);
    expect(find.text('Back to Log in'), findsOneWidget);
  });

  testWidgets('Send Reset Code shows snackbar when email empty', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ForgotPasswordPage(),
      ),
    );
    await pumpAuth(tester);

    await tester.tap(find.text('Send Reset Code'));
    await pumpAuth(tester);

    expect(find.text('Email wajib diisi'), findsOneWidget);
  });

  testWidgets('Send Reset Code shows snackbar for invalid email', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ForgotPasswordPage(),
      ),
    );
    await pumpAuth(tester);

    await tester.enterText(find.byType(TextFormField), 'bad');
    await tester.tap(find.text('Send Reset Code'));
    await pumpAuth(tester);

    expect(find.text('Format email tidak valid'), findsOneWidget);
  });
}
