import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:frontend/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:frontend/features/checkout/presentation/pages/checkout_page.dart';
import 'package:frontend/features/checkout/presentation/pages/purchase_complete_page.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';

import '../cart/support/cart_widget_test_doubles.dart';
import 'support/checkout_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  void registerStack() {
    final cartDs = CartCheckoutTestDatasource();
    Get.put<ProfileController>(ProfileController(datasource: ProfileCheckoutWidgetDatasource()));
    Get.put<CartController>(CartController(datasource: cartDs));
    Get.put<CheckoutController>(
      CheckoutController(
        checkoutDatasource: CheckoutSuccessDatasource(),
        cardPaymentDatasource: CheckoutCardWidgetDatasource(),
        cartDatasource: cartDs,
        walletDatasource: CheckoutWalletWidgetDatasource(),
      ),
    );
  }

  Future<void> pumpCheckout(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('CheckoutPage shows bag, address, payment, and confirm', (tester) async {
    registerStack();

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CheckoutPage(),
      ),
    );
    await pumpCheckout(tester);

    expect(find.text('Checkout'), findsOneWidget);
    expect(find.text('Items in your bag'), findsOneWidget);
    expect(find.text('Cart Test Tee'), findsOneWidget);
    expect(find.text('Shipping Address'), findsOneWidget);
    expect(find.text('Home address'), findsOneWidget);
    expect(find.text('Jane Checkout'), findsOneWidget);
    expect(find.text('Payment Method'), findsOneWidget);
    expect(find.text('Wallet'), findsOneWidget);
    // Below the fold in default test viewport; must not skip offstage.
    expect(find.text('Confirm & Pay', skipOffstage: false), findsOneWidget);
  });

  testWidgets('Cek ongkir shows courier section', (tester) async {
    registerStack();

    await tester.pumpWidget(
      const GetMaterialApp(
        home: CheckoutPage(),
      ),
    );
    await pumpCheckout(tester);

    await tester.tap(find.text('Cek ongkir & pilihan kurir'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Ekspedisi'), findsOneWidget);
    expect(find.textContaining('JNE'), findsOneWidget);
  });

  testWidgets('Wallet Confirm & Pay navigates to purchase complete', (tester) async {
    registerStack();

    await tester.pumpWidget(
      GetMaterialApp(
        routes: {
          '/': (_) => const CheckoutPage(),
          RouteNames.purchaseComplete: (_) => const PurchaseCompletePage(),
        },
        initialRoute: '/',
      ),
    );
    await pumpCheckout(tester);

    final confirm = find.text('Confirm & Pay', skipOffstage: false);
    await tester.ensureVisible(confirm);
    await tester.pumpAndSettle();
    await tester.tap(confirm);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Order Placed!'), findsOneWidget);
    expect(find.textContaining('Order #501'), findsOneWidget);
  });
}
