import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/profile/presentation/pages/saved_addresses_page.dart';

import '../checkout/support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('loads addresses and shows primary card', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SavedAddressesPage(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Saved Addresses'), findsOneWidget);
    expect(find.text('Manage your Delivery Addresses'), findsOneWidget);
    expect(find.text('Home address'), findsOneWidget);
    expect(find.text('Jane Checkout'), findsOneWidget);
    expect(find.text('Make New Address'), findsOneWidget);
  });

  testWidgets('Make New Address navigates to add route', (tester) async {
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/',
        routes: {
          '/': (_) => const SavedAddressesPage(),
          RouteNames.addNewAddress: (_) => const Scaffold(body: Text('AddAddressStub')),
        },
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Make New Address'));
    await tester.pumpAndSettle();

    expect(find.text('AddAddressStub'), findsOneWidget);
  });
}
