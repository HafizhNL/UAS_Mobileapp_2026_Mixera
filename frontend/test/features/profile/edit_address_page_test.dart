import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/edit_address_page.dart';

import 'support/profile_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  const addr = AddressModel(
    id: 100,
    label: 'home',
    recipientName: 'Jane Checkout',
    phoneNumber: '081234567890',
    streetAddress: 'Jl. Contoh 1',
    city: 'Jakarta',
    state: 'DKI',
    postalCode: '12345',
    isPrimary: true,
  );

  testWidgets('shows Edit Address and prefilled Save', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileUpdateAddressOkDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: EditAddressPage(address: addr),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Edit Address'), findsOneWidget);
    expect(find.text('Jane Checkout'), findsOneWidget);
    expect(find.text('Save Address'), findsOneWidget);
  });

  testWidgets('Save Address pops on success', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileUpdateAddressOkDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const EditAddressPage(address: addr),
                  ),
                );
              },
              child: const Text('OpenEditAddr'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('OpenEditAddr'));
    await tester.pumpAndSettle();

    final save = find.text('Save Address', skipOffstage: false);
    await tester.ensureVisible(save);
    await tester.pumpAndSettle();
    await tester.tap(save);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('OpenEditAddr'), findsOneWidget);
    Get.closeAllSnackbars();
    await tester.pumpAndSettle();
  });
}
