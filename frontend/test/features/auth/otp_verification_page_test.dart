import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/otp_verification_page.dart';

import 'support/auth_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows OTP title and email', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest(datasource: FakeAuthOtpVerifyResetOkDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: OtpVerificationPage(email: 'otp@test.com'),
      ),
    );
    await tester.pump();

    expect(find.text('Enter OTP Code'), findsOneWidget);
    expect(find.byType(RichText), findsWidgets);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Verify'), findsOneWidget);
  });

  testWidgets('Verify with code navigates to login', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest(datasource: FakeAuthOtpVerifyResetOkDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/otp',
        routes: {
          '/otp': (_) => const OtpVerificationPage(email: 'ok@test.com'),
          RouteNames.login: (_) => const Scaffold(body: Text('LoginAfterOtp')),
        },
      ),
    );
    await tester.pump();

    final otpFields = find.byType(TextFormField);
    await tester.enterText(otpFields.at(0), '9');
    await tester.enterText(otpFields.at(1), '8');
    await tester.enterText(otpFields.at(2), '7');
    await tester.enterText(otpFields.at(3), '6');

    final verify = find.widgetWithText(ElevatedButton, 'Verify');
    await tester.ensureVisible(verify);
    await tester.pumpAndSettle();
    await tester.tap(verify);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('LoginAfterOtp'), findsOneWidget);
    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
