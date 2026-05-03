import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/add_new_address_page.dart';

import 'support/profile_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows Add New Address and form labels', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileCreateAddressOkDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: AddNewAddressPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Add New Address'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Make New Address'), findsOneWidget);
  });

  testWidgets('filled form saves and pops', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileCreateAddressOkDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const AddNewAddressPage()),
                );
              },
              child: const Text('OpenAdd'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('OpenAdd'));
    await tester.pumpAndSettle();

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'New User');
    await tester.enterText(fields.at(1), '081111222333');
    await tester.enterText(fields.at(2), 'Jl. Baru 5');
    await tester.enterText(fields.at(3), 'Bandung');
    await tester.enterText(fields.at(4), 'Jabar');
    await tester.enterText(fields.at(5), '40111');

    final btn = find.text('Make New Address', skipOffstage: false);
    await tester.ensureVisible(btn);
    await tester.pumpAndSettle();
    await tester.tap(btn);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('OpenAdd'), findsOneWidget);
    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
