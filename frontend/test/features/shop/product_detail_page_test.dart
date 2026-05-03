import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/cart/presentation/controllers/cart_controller.dart';
import 'package:frontend/features/shop/data/datasources/shop_remote_datasource.dart';
import 'package:frontend/features/shop/data/models/category_model.dart';
import 'package:frontend/features/shop/data/models/product_detail_model.dart';
import 'package:frontend/features/shop/data/models/product_model.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';
import 'package:frontend/features/shop/presentation/pages/product_detail_page.dart';

import '../cart/support/cart_widget_test_doubles.dart';
import 'support/shop_widget_test_doubles.dart';

class _ShopDetailMissingDatasource implements ShopDatasource {
  @override
  Future<List<CategoryModel>> getCategories() async => const [];

  @override
  Future<List<ProductModel>> getProducts({String? search, String? category}) async => const [];

  @override
  Future<ProductDetailModel> getProductDetail(String slug) async {
    throw Exception('missing');
  }

  @override
  Future<List<ProductModel>> getWishlist() async => const [];

  @override
  Future<bool> toggleWishlist(int productId) async => false;
}

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpDetail(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> scrollActionsIntoView(WidgetTester tester) async {
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('ProductDetailPage loads product, size, and actions', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));
    Get.put<CartController>(CartController(datasource: CartWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ProductDetailPage(slug: 'widget-test-shirt'),
      ),
    );
    await pumpDetail(tester);

    expect(find.text('Widget Test Shirt'), findsWidgets);
    expect(find.text('Product details'), findsOneWidget);
    expect(find.text('Ukuran:'), findsOneWidget);
    expect(find.text('M'), findsOneWidget);

    await scrollActionsIntoView(tester);
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Virtual try-on'), findsOneWidget);
    expect(find.text('Chat Penjual'), findsOneWidget);
  });

  testWidgets('ProductDetailPage shows empty state when detail fails', (tester) async {
    Get.put<ShopController>(ShopController(datasource: _ShopDetailMissingDatasource()));
    Get.put<CartController>(CartController(datasource: CartWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ProductDetailPage(slug: 'unknown'),
      ),
    );
    await pumpDetail(tester);

    expect(find.text('Product not found'), findsOneWidget);
    expect(find.text('Go back'), findsOneWidget);
  });

  testWidgets('Keranjang tap shows success snackbar', (tester) async {
    Get.put<ShopController>(ShopController(datasource: ShopWidgetTestDatasource()));
    Get.put<CartController>(CartController(datasource: CartWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ProductDetailPage(slug: 'widget-test-shirt'),
      ),
    );
    await pumpDetail(tester);
    await scrollActionsIntoView(tester);

    await tester.ensureVisible(find.text('Keranjang'));
    await tester.tap(find.text('Keranjang'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Produk berhasil ditambahkan!'), findsOneWidget);
  });
}
