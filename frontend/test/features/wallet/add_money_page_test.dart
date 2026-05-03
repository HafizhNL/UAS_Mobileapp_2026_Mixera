import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:frontend/features/wallet/presentation/pages/add_money_page.dart';

import '../checkout/support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets('shows headline, amount field, and card payment method', (tester) async {
    Get.put<WalletController>(
      WalletController(
        walletDatasource: CheckoutWalletWidgetDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: AddMoneyPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Add Money'), findsOneWidget);
    expect(find.text('How much would you like to add?'), findsOneWidget);
    expect(find.text('Metode pembayaran'), findsOneWidget);
    expect(
      find.text('Kartu debit / kredit (termasuk tersimpan)'),
      findsOneWidget,
    );
  });

  testWidgets('card top-up validates minimum amount before payment flow', (tester) async {
    Get.put<WalletController>(
      WalletController(
        walletDatasource: CheckoutWalletWidgetDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: AddMoneyPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.enterText(find.byType(TextFormField), '5000');
    await tester.pump();

    await tester.tap(
      find.widgetWithText(
        ElevatedButton,
        'Kartu debit / kredit (termasuk tersimpan)',
      ),
    );
    await tester.pump();

    expect(find.text('Minimum top-up is Rp 10.000'), findsOneWidget);
  });
}
