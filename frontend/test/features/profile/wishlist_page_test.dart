import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/profile/presentation/pages/wishlist_page.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';

import '../shop/support/shop_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> settle(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('empty wishlist shows copy', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: WishlistPage()));
    await settle(tester);

    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('Wishlist kamu masih kosong'), findsOneWidget);
  });

  testWidgets('non-empty wishlist shows product name', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWishlistOneItemDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: WishlistPage()));
    await settle(tester);

    expect(find.text('Wish Tee'), findsOneWidget);
    expect(find.text('Tops'), findsOneWidget);
  });

  testWidgets('tapping heart clears list after toggle', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWishlistToggleClearsDatasource()));

    await tester.pumpWidget(const GetMaterialApp(home: WishlistPage()));
    await settle(tester);

    expect(find.text('Wish Tee'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Wishlist kamu masih kosong'), findsOneWidget);
  });

  testWidgets('tapping tile opens product detail route', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWishlistOneItemDatasource()));

    await tester.pumpWidget(
      GetMaterialApp(
        routes: {
          '/': (_) => const WishlistPage(),
          RouteNames.productDetail: (_) => const Scaffold(body: Text('ProductDetailStub')),
        },
        initialRoute: '/',
      ),
    );
    await settle(tester);

    await tester.tap(find.text('Wish Tee'));
    await tester.pumpAndSettle();

    expect(find.text('ProductDetailStub'), findsOneWidget);
  });
}
