import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/_address_form.dart';

import '../checkout/support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('label tabs and primary row', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: AddressForm(profileC: Get.find<ProfileController>()),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Work'), findsOneWidget);
    expect(find.text('Set as Primary Address'), findsOneWidget);

    await tester.tap(find.text('Work'));
    await tester.pump();
    expect(Get.find<ProfileController>().selectedAddressLabel.value, 'work');
  });
}
