import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';

import 'support/auth_widget_test_doubles.dart';

// Login success uses [AuthControllerForWidgetTest] with [persistLoginTokens] no-op so
// tests do not touch secure storage; production still uses [TokenStorage] + FCM.

void main() {
  setUp(Get.reset);
  tearDown(() {
    if (Get.isRegistered<AuthController>()) {
      Get.delete<AuthController>(force: true);
    }
    Get.reset();
  });

  group('AuthControllerForWidgetTest — OTP & toggles', () {
    test('otpCode joins OTP fields', () {
      final c = AuthControllerForWidgetTest();
      Get.put<AuthController>(c);

      for (var i = 0; i < 4; i++) {
        c.otpControllers[i].text = '${i + 1}';
      }
      expect(c.otpCode, '1234');
    });

    test('resetOtpCode joins reset OTP fields', () {
      final c = AuthControllerForWidgetTest();
      Get.put<AuthController>(c);

      c.resetOtpControllers[0].text = '9';
      c.resetOtpControllers[1].text = '8';
      c.resetOtpControllers[2].text = '7';
      c.resetOtpControllers[3].text = '6';
      expect(c.resetOtpCode, '9876');
    });

    test('clearOtpFields clears OTP controllers', () {
      final c = AuthControllerForWidgetTest();
      Get.put<AuthController>(c);

      c.otpControllers[0].text = 'x';
      c.clearOtpFields();
      expect(c.otpCode, isEmpty);
    });

    test('togglePasswordVisibility flips isPasswordHidden', () {
      final c = AuthControllerForWidgetTest();
      Get.put<AuthController>(c);

      expect(c.isPasswordHidden.value, isTrue);
      c.togglePasswordVisibility();
      expect(c.isPasswordHidden.value, isFalse);
    });
  });

  group('AuthController — validation via BuildContext', () {
    Future<void> pumpShell(
      WidgetTester tester, {
      required AuthController auth,
      required Future<void> Function(BuildContext ctx) run,
    }) async {
      Get.put<AuthController>(auth);
      await tester.pumpWidget(
        GetMaterialApp(
          routes: {
            RouteNames.mainShell: (_) => const Scaffold(
                  body: Center(child: Text('MAIN_SHELL')),
                ),
            RouteNames.sellerShell: (_) => const Scaffold(
                  body: Center(child: Text('SELLER_SHELL')),
                ),
            RouteNames.otp: (_) => const Scaffold(
                  body: Center(child: Text('OTP_PAGE')),
                ),
            RouteNames.resetPassword: (_) => const Scaffold(
                  body: Center(child: Text('RESET_PAGE')),
                ),
            RouteNames.login: (_) => const Scaffold(
                  body: Center(child: Text('LOGIN_PAGE')),
                ),
          },
          home: _AuthContextProbe(onReady: run),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
    }

    testWidgets('login shows snackbar when email or password empty',
        (tester) async {
      final auth = AuthControllerForWidgetTest();
      await pumpShell(tester, auth: auth, run: (ctx) => auth.login(ctx));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Email and password cannot be empty'), findsOneWidget);
    });

    testWidgets('login shows snackbar for invalid email format', (tester) async {
      final auth = AuthControllerForWidgetTest();
      auth.emailController.text = 'bukan-email';
      auth.passwordController.text = 'secret';
      await pumpShell(tester, auth: auth, run: (ctx) => auth.login(ctx));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Format email tidak valid'), findsOneWidget);
    });

    testWidgets('login navigates to main shell when API returns tokens', (tester) async {
      final auth = AuthControllerForWidgetTest(
        datasource: FakeAuthLoginOkDatasource(),
        persistLoginTokens: (_, __) async {},
      );
      auth.emailController.text = 'a@b.com';
      auth.passwordController.text = 'secret';
      await pumpShell(tester, auth: auth, run: (ctx) => auth.login(ctx));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      expect(auth.isLoading.value, isFalse);
      expect(find.text('MAIN_SHELL'), findsOneWidget);
    });

    testWidgets('register shows snackbar when required fields empty',
        (tester) async {
      final auth = AuthControllerForWidgetTest();
      await pumpShell(tester, auth: auth, run: (ctx) => auth.register(ctx));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Harap isi semua kolom wajib!'), findsOneWidget);
    });

    testWidgets('register navigates to OTP route on success', (tester) async {
      final auth = AuthControllerForWidgetTest(
        datasource: FakeAuthRegisterOkDatasource(),
      );
      auth.emailController.text = 'new@example.com';
      auth.usernameController.text = 'user';
      auth.passwordController.text = 'Password1!';
      await pumpShell(tester, auth: auth, run: (ctx) => auth.register(ctx));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('OTP_PAGE'), findsOneWidget);
    });

    testWidgets('sendForgotPasswordCode shows snackbar when email empty',
        (tester) async {
      final auth = AuthControllerForWidgetTest();
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.sendForgotPasswordCode(ctx),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Email wajib diisi'), findsOneWidget);
    });

    testWidgets('sendForgotPasswordCode navigates to reset password',
        (tester) async {
      final auth = AuthControllerForWidgetTest(
        datasource: FakeAuthForgotOkDatasource(),
      );
      auth.forgotEmailController.text = 'user@example.com';
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.sendForgotPasswordCode(ctx),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('RESET_PAGE'), findsOneWidget);
    });

    testWidgets('verifyOtp shows snackbar when code is not four digits',
        (tester) async {
      final auth = AuthControllerForWidgetTest();
      auth.otpControllers[0].text = '1';
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.verifyOtp(ctx, 'user@example.com'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Masukkan 4 digit OTP'), findsOneWidget);
    });

    testWidgets('verifyOtp navigates to login on success', (tester) async {
      final auth = AuthControllerForWidgetTest(
        datasource: FakeAuthOtpVerifyResetOkDatasource(),
      );
      for (var i = 0; i < 4; i++) {
        auth.otpControllers[i].text = '1';
      }
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.verifyOtp(ctx, 'user@example.com'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('LOGIN_PAGE'), findsOneWidget);
    });

    testWidgets('resetPassword shows snackbar when fields empty',
        (tester) async {
      final auth = AuthControllerForWidgetTest();
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.resetPassword(ctx, email: 'user@example.com'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Semua field wajib diisi'), findsOneWidget);
    });

    testWidgets('resetPassword shows snackbar when OTP not four digits',
        (tester) async {
      final auth = AuthControllerForWidgetTest();
      auth.resetOtpControllers[0].text = '1';
      auth.newPasswordController.text = 'a';
      auth.confirmPasswordController.text = 'a';
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.resetPassword(ctx, email: 'user@example.com'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('OTP harus 4 digit'), findsOneWidget);
    });

    testWidgets('resetPassword navigates to login on success', (tester) async {
      final auth = AuthControllerForWidgetTest(
        datasource: FakeAuthOtpVerifyResetOkDatasource(),
      );
      for (var i = 0; i < 4; i++) {
        auth.resetOtpControllers[i].text = '2';
      }
      auth.newPasswordController.text = 'Newpass1!';
      auth.confirmPasswordController.text = 'Newpass1!';
      await pumpShell(
        tester,
        auth: auth,
        run: (ctx) => auth.resetPassword(ctx, email: 'user@example.com'),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('LOGIN_PAGE'), findsOneWidget);
    });
  });
}

/// Pumps once then invokes [onReady] with a [BuildContext] under [ScaffoldMessenger].
class _AuthContextProbe extends StatefulWidget {
  const _AuthContextProbe({required this.onReady});

  final Future<void> Function(BuildContext context) onReady;

  @override
  State<_AuthContextProbe> createState() => _AuthContextProbeState();
}

class _AuthContextProbeState extends State<_AuthContextProbe> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await widget.onReady(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('AUTH_PROBE')),
    );
  }
}
