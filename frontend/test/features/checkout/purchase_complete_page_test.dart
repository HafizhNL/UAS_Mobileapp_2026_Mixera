import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/checkout/data/models/order_model.dart';
import 'package:frontend/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:frontend/features/checkout/presentation/pages/purchase_complete_page.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';

import '../cart/support/cart_widget_test_doubles.dart';
import 'support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  void registerCheckoutForPurchaseComplete() {
    final cartDs = CartCheckoutTestDatasource();
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));
    Get.put<CheckoutController>(
      CheckoutController(
        checkoutDatasource: CheckoutSuccessDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
        cartDatasource: cartDs,
        walletDatasource: CheckoutWalletWidgetDatasource(),
      ),
    );
  }

  testWidgets('shows order id, total, and Processing when lastOrder is set', (tester) async {
    registerCheckoutForPurchaseComplete();
    Get.find<CheckoutController>().lastOrder.value = const OrderModel(
      id: 777,
      status: 'processing',
      subtotal: 50000,
      deliveryFee: 15000,
      discountTotal: 0,
      total: 65000,
      paymentMethod: 'wallet',
      paymentStatus: 'paid',
      createdAt: '2026-05-02',
      items: [],
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: PurchaseCompletePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Order Placed!'), findsOneWidget);
    expect(find.textContaining('Order #777'), findsOneWidget);
    expect(find.textContaining('65.000'), findsOneWidget);
    expect(find.text('Processing'), findsOneWidget);
  });

  testWidgets('shows fallback copy when lastOrder is null', (tester) async {
    registerCheckoutForPurchaseComplete();

    await tester.pumpWidget(
      const GetMaterialApp(
        home: PurchaseCompletePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Your order is confirmed.'), findsOneWidget);
    expect(find.textContaining('Order #'), findsNothing);
  });

  testWidgets('View My Orders clears stack to orders route', (tester) async {
    registerCheckoutForPurchaseComplete();
    Get.find<CheckoutController>().lastOrder.value = const OrderModel(
      id: 1,
      status: 'processing',
      subtotal: 1000,
      deliveryFee: 0,
      discountTotal: 0,
      total: 1000,
      paymentMethod: 'wallet',
      paymentStatus: 'paid',
      createdAt: '2026-05-02',
      items: [],
    );

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: RouteNames.purchaseComplete,
        routes: {
          RouteNames.purchaseComplete: (_) => const PurchaseCompletePage(),
          RouteNames.orders: (_) => const Scaffold(body: Text('OrdersRouteStub')),
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('View My Orders'));
    await tester.pumpAndSettle();

    expect(find.text('OrdersRouteStub'), findsOneWidget);
  });

  testWidgets('Back to Home clears stack to main shell route', (tester) async {
    registerCheckoutForPurchaseComplete();

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: RouteNames.purchaseComplete,
        routes: {
          RouteNames.purchaseComplete: (_) => const PurchaseCompletePage(),
          RouteNames.mainShell: (_) => const Scaffold(body: Text('MainShellStub')),
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Back to Home'));
    await tester.pumpAndSettle();

    expect(find.text('MainShellStub'), findsOneWidget);
  });
}
