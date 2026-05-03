import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/reset_password_page.dart';

import 'support/auth_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows Reset Password and requirement rows', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest(datasource: FakeAuthOtpVerifyResetOkDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ResetPasswordPage(email: 'user@test.com'),
      ),
    );
    await tester.pump();

    expect(find.text('Reset Password'), findsWidgets);
    expect(find.text('Minimum 8 characters'), findsOneWidget);
  });

  testWidgets('successful reset navigates to login route', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest(datasource: FakeAuthOtpVerifyResetOkDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => const ResetPasswordPage(email: 'user@test.com'),
          RouteNames.login: (_) => const Scaffold(body: Text('LoginAfterReset')),
        },
      ),
    );
    await tester.pump();

    final fields = find.byType(TextFormField);
    for (var i = 0; i < 4; i++) {
      await tester.enterText(fields.at(i), '${i + 1}');
    }
    await tester.enterText(fields.at(4), 'Aa1!aaaa');
    await tester.enterText(fields.at(5), 'Aa1!aaaa');

    final resetBtn = find.widgetWithText(ElevatedButton, 'Reset Password');
    await tester.ensureVisible(resetBtn);
    await tester.pumpAndSettle();
    await tester.tap(resetBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('LoginAfterReset'), findsOneWidget);
    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
