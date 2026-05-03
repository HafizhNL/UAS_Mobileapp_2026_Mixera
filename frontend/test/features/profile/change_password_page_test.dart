import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/change_password_page.dart';

import 'support/profile_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('password rules react to new password input', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileChangePasswordOkDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: ChangePasswordPage()));
    await tester.pump();

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(3));

    await tester.enterText(fields.at(1), 'Aa1!aaaa');
    await tester.pump();

    expect(find.byIcon(Icons.check_rounded), findsWidgets);
  });

  testWidgets('Save Changes pops on success', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileChangePasswordOkDatasource()));
    final c = Get.find<ProfileController>();
    c.currentPasswordController.text = 'oldpass';
    c.newPasswordController.text = 'Aa1!aaaa';
    c.confirmNewPasswordController.text = 'Aa1!aaaa';

    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const ChangePasswordPage(),
                  ),
                );
              },
              child: const Text('OpenChangePw'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('OpenChangePw'));
    await tester.pumpAndSettle();

    final saveBtn = find.text('Save Changes', skipOffstage: false);
    await tester.ensureVisible(saveBtn);
    await tester.pumpAndSettle();
    await tester.tap(saveBtn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('OpenChangePw'), findsOneWidget);
    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
