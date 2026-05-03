import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';
import 'package:frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/security_page.dart';

import '../auth/support/auth_widget_test_doubles.dart';
import '../checkout/support/checkout_widget_test_doubles.dart';
import 'support/profile_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  void registerStack(ProfileDatasource ds) {
    Get.put<ProfileController>(ProfileController(datasource: ds));
    Get.put<AuthController>(AuthControllerForWidgetTest());
  }

  testWidgets('email account shows Change Password button', (tester) async {
    registerStack(ProfileCheckoutWidgetDatasource());

    await tester.pumpWidget(const GetMaterialApp(home: SecurityPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Security'), findsOneWidget);
    expect(find.text('Change Password'), findsWidgets);
    expect(find.text('Sidik jari'), findsOneWidget);
  });

  testWidgets('Google account shows social password notice', (tester) async {
    registerStack(ProfileGoogleUserDatasource());

    await tester.pumpWidget(const GetMaterialApp(home: SecurityPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.textContaining('You signed in with Google'), findsOneWidget);
    expect(find.textContaining('Password changes are managed'), findsOneWidget);
  });
}
