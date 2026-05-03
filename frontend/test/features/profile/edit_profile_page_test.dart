import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/edit_profile_page.dart';

import 'support/profile_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows username from profile and Save Changes', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileSaveOkDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: EditProfilePage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
    expect(find.text('checkout_tester'), findsOneWidget);
  });

  testWidgets('Save Changes pops after successful update', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileSaveOkDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const EditProfilePage(),
                  ),
                );
              },
              child: const Text('OpenEdit'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('OpenEdit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'new_username');
    final saveBtn = find.text('Save Changes', skipOffstage: false);
    await tester.ensureVisible(saveBtn);
    await tester.pumpAndSettle();
    await tester.tap(saveBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('OpenEdit'), findsOneWidget);
    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
