import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';

import 'support/auth_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpAuth(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('RegisterPage shows headline and Sign Up', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: RegisterPage(),
      ),
    );
    await pumpAuth(tester);

    expect(find.text('Create an account'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Minimum 8 characters'), findsOneWidget);
    expect(find.text('Include a number'), findsOneWidget);
  });

  testWidgets('Sign Up shows snackbar when required fields empty', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: RegisterPage(),
      ),
    );
    await pumpAuth(tester);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Sign Up'));
    await pumpAuth(tester);

    expect(find.text('Harap isi semua kolom wajib!'), findsOneWidget);
  });
}
