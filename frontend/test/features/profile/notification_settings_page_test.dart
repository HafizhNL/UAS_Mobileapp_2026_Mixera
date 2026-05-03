import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/notifications_page.dart';

import 'support/profile_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('loads toggles from settings and shows Save Preferences', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileNotifySaveOkDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: NotificationsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Notifications'), findsOneWidget);
    expect(find.text('Order Updates'), findsOneWidget);
    expect(find.text('Save Preferences'), findsOneWidget);
  });

  testWidgets('first switch toggles Order Updates', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileNotifySaveOkDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: NotificationsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final switches = find.byType(Switch);
    expect(switches, findsWidgets);

    await tester.tap(switches.first);
    await tester.pump();

    final sw = tester.widget<Switch>(switches.first);
    expect(sw.value, isFalse);
  });
}
