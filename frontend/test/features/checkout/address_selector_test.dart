import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:frontend/features/checkout/presentation/widgets/address_selector.dart';
import 'package:frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';

import '../cart/support/cart_widget_test_doubles.dart';
import 'support/checkout_widget_test_doubles.dart';

/// Same as [ProfileCheckoutWidgetDatasource] but no saved addresses.
class ProfileNoAddressesDatasource extends ProfileCheckoutWidgetDatasource {
  @override
  Future<List<AddressModel>> getAddresses() async => [];
}

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  void registerAddressStack(ProfileDatasource profileDatasource) {
    final cartDs = CartCheckoutTestDatasource();
    Get.put<ProfileController>(ProfileController(datasource: profileDatasource));
    Get.put<CheckoutController>(
      CheckoutController(
        checkoutDatasource: CheckoutSuccessDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
        cartDatasource: cartDs,
        walletDatasource: CheckoutWalletWidgetDatasource(),
      ),
    );
  }

  Future<void> pumpSelector(WidgetTester tester, ProfileDatasource profileDs) async {
    registerAddressStack(profileDs);
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: AddressSelector(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('renders primary address recipient and street', (tester) async {
    await pumpSelector(tester, ProfileCheckoutWidgetDatasource());

    expect(find.text('Home address'), findsOneWidget);
    expect(find.text('Jane Checkout'), findsOneWidget);
    expect(find.textContaining('Jl. Contoh'), findsOneWidget);
  });

  testWidgets('empty addresses shows profile hint', (tester) async {
    await pumpSelector(tester, ProfileNoAddressesDatasource());

    expect(find.text('No saved addresses. Add one in Profile.'), findsOneWidget);
  });
}
