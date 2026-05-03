import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/app/routes/app_router.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:frontend/features/auth/presentation/pages/login_page.dart';
import 'package:frontend/features/auth/presentation/pages/register_page.dart';

import '../../features/auth/support/auth_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('login route builds LoginPage', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());
    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) {
            final route = AppRouter.onGenerateRoute(
              const RouteSettings(name: RouteNames.login),
            ) as MaterialPageRoute<void>;
            return route.builder(context);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('register route builds RegisterPage', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());
    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) {
            final route = AppRouter.onGenerateRoute(
              const RouteSettings(name: RouteNames.register),
            ) as MaterialPageRoute<void>;
            return route.builder(context);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
  });

  testWidgets('forgot password route builds ForgotPasswordPage', (tester) async {
    Get.put<AuthController>(AuthControllerForWidgetTest());
    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) {
            final route = AppRouter.onGenerateRoute(
              const RouteSettings(name: RouteNames.forgotPassword),
            ) as MaterialPageRoute<void>;
            return route.builder(context);
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ForgotPasswordPage), findsOneWidget);
  });
}
