import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:frontend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:frontend/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:frontend/features/checkout/presentation/widgets/payment_method_selector.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';
import 'package:frontend/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:frontend/features/wallet/data/models/wallet_model.dart';

import '../cart/support/cart_widget_test_doubles.dart';
import 'support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  void registerCheckoutStack({
    CartDatasource? cartDatasource,
    WalletDatasource? walletDatasource,
  }) {
    final cartDs = cartDatasource ?? CartCheckoutTestDatasource();
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));
    Get.put<CartController>(CartController(datasource: cartDs));
    Get.put<CheckoutController>(
      CheckoutController(
        checkoutDatasource: CheckoutSuccessDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
        cartDatasource: cartDs,
        walletDatasource: walletDatasource ?? CheckoutWalletWidgetDatasource(),
      ),
    );
  }

  Future<void> pumpSelector(WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: PaymentMethodSelector(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('wallet selected shows balance and no insufficient warning', (tester) async {
    registerCheckoutStack();
    await pumpSelector(tester);

    expect(find.text('Wallet'), findsOneWidget);
    expect(find.textContaining('Balance:'), findsOneWidget);
    expect(find.textContaining('500.000'), findsOneWidget);
    expect(find.textContaining('Insufficient'), findsNothing);
  });

  testWidgets('tapping card then wallet updates selection', (tester) async {
    registerCheckoutStack();
    await pumpSelector(tester);

    await tester.tap(find.text('Credit / Debit Card'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(Get.find<CheckoutController>().selectedPaymentMethod.value, 'card');

    await tester.tap(find.text('Wallet'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(Get.find<CheckoutController>().selectedPaymentMethod.value, 'wallet');
    expect(find.textContaining('Balance:'), findsOneWidget);
  });

  testWidgets('shows insufficient when wallet below cart total', (tester) async {
    registerCheckoutStack(
      walletDatasource: _LowBalanceWalletDatasource(),
    );
    await pumpSelector(tester);

    expect(find.textContaining('Insufficient'), findsOneWidget);
  });
}

/// Wallet below one-line cart total from [CartCheckoutTestDatasource] (99.000).
class _LowBalanceWalletDatasource extends CheckoutWalletWidgetDatasource {
  @override
  Future<WalletModel> getWallet() async => WalletModel(
        balance: 50000,
        updatedAt: DateTime.utc(2026, 5, 1),
      );
}
