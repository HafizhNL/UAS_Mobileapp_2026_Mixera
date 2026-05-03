import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/profile_page.dart';

import '../checkout/support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows welcome and profile headline after load', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: ProfilePage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Profile'), findsOneWidget);
    expect(find.textContaining('Welcome back, checkout_tester'), findsOneWidget);
  });
}
