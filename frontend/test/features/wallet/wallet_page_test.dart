import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:frontend/features/wallet/data/models/wallet_model.dart';
import 'package:frontend/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:frontend/features/wallet/presentation/controllers/wallet_controller.dart';
import 'package:frontend/features/wallet/presentation/pages/wallet_page.dart';

import '../checkout/support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows balance, empty cards, empty transactions', (tester) async {
    Get.put<WalletController>(
      WalletController(
        walletDatasource: CheckoutWalletWidgetDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: WalletPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Wallet'), findsOneWidget);
    expect(find.text('Current Balance'), findsOneWidget);
    expect(find.textContaining('500.000'), findsOneWidget);
    expect(find.text('No saved cards yet. Tap Add Money to add one.'), findsOneWidget);
    expect(find.text('No transactions yet.'), findsOneWidget);
  });

  testWidgets('shows transaction row when history non-empty', (tester) async {
    Get.put<WalletController>(
      WalletController(
        walletDatasource: _WalletWithOneTxDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: WalletPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Top Up'), findsOneWidget);
    expect(find.textContaining('+'), findsWidgets);
  });

  testWidgets('Add Money navigates to route', (tester) async {
    Get.put<WalletController>(
      WalletController(
        walletDatasource: CheckoutWalletWidgetDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
      ),
    );
    await tester.pumpWidget(
      GetMaterialApp(
        routes: {
          '/': (_) => const WalletPage(),
          RouteNames.addMoney: (_) => const Scaffold(body: Text('AddMoneyStub')),
        },
        initialRoute: '/',
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Add Money'));
    await tester.pumpAndSettle();

    expect(find.text('AddMoneyStub'), findsOneWidget);
  });
}

class _WalletWithOneTxDatasource implements WalletDatasource {
  @override
  Future<WalletModel> getWallet() async => WalletModel(
        balance: 100000,
        updatedAt: DateTime.utc(2026, 5, 2),
      );

  @override
  Future<List<WalletTransactionModel>> getTransactions() async => [
        WalletTransactionModel(
          id: 1,
          type: 'top_up',
          amount: 50000,
          description: 'Top Up',
          createdAt: _txAt,
        ),
      ];
}

final _txAt = DateTime(2026, 5, 2);
