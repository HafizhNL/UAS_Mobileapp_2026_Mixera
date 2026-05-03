import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';

import 'support/auth_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpAuth(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('LoginPage shows email, password, login, and forgot link', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(),
      ),
    );
    await pumpAuth(tester);

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.text('Remember Me'), findsOneWidget);
  });

  testWidgets('Login shows snackbar when fields are empty', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(),
      ),
    );
    await pumpAuth(tester);

    await tester.tap(find.text('Login'));
    await pumpAuth(tester);

    expect(find.text('Email and password cannot be empty'), findsOneWidget);
  });

  testWidgets('Login shows snackbar for invalid email format', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(),
      ),
    );
    await pumpAuth(tester);

    await tester.enterText(find.byType(TextFormField).first, 'not-an-email');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret');
    await tester.tap(find.text('Login'));
    await pumpAuth(tester);

    expect(find.text('Format email tidak valid'), findsOneWidget);
  });

  testWidgets('Password visibility toggle changes obscure text', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());

    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(),
      ),
    );
    await pumpAuth(tester);

    final visibilityButtons = find.byType(IconButton);
    expect(visibilityButtons, findsOneWidget);
    await tester.tap(visibilityButtons);
    await pumpAuth(tester);

    await tester.tap(visibilityButtons);
    await pumpAuth(tester);
  });
}
