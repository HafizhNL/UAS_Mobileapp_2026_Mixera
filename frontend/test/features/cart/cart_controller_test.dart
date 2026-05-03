import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:frontend/features/cart/data/models/cart_item_model.dart';
import 'package:frontend/features/cart/data/models/cart_summary_model.dart';
import 'package:frontend/features/cart/presentation/controllers/cart_controller.dart';

void main() {
  test('exposes cart item, count, and total getters from current cart state', () {
    final controller = CartController(datasource: _FakeCartDatasource());

    controller.cart.value = CartSummaryModel(
      count: 2,
      total: 30000,
      items: const [
        CartItemModel(
          id: 1,
          variantId: 10,
          productName: 'Linen Shirt',
          productSlug: 'linen-shirt',
          size: 'M',
          color: 'White',
          quantity: 2,
          unitPrice: 15000,
          lineTotal: 30000,
        ),
      ],
    );

    expect(controller.itemCount, 2);
    expect(controller.total, 30000);
    expect(controller.items.single.productName, 'Linen Shirt');
  });

  test('fetchCart updates cart state from datasource', () async {
    final datasource = _FakeCartDatasource();
    final controller = CartController(datasource: datasource);

    await controller.fetchCart();

    expect(datasource.getCartCalls, 1);
    expect(controller.isLoading.value, isFalse);
    expect(controller.itemCount, 1);
    expect(controller.total, 12000);
  });
}

class _FakeCartDatasource implements CartDatasource {
  int getCartCalls = 0;

  @override
  Future<CartSummaryModel> getCart() async {
    getCartCalls++;
    return const CartSummaryModel(
      count: 1,
      total: 12000,
      items: [
        CartItemModel(
          id: 2,
          variantId: 20,
          productName: 'Pleated Skirt',
          productSlug: 'pleated-skirt',
          size: 'S',
          color: 'Black',
          quantity: 1,
          unitPrice: 12000,
          lineTotal: 12000,
        ),
      ],
    );
  }

  @override
  Future<CartItemModel> addItem(int variantId, int quantity) {
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart() {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postShippingQuote({
    int? addressId,
    String? destinationPostalCode,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> removeItem(int id) {
    throw UnimplementedError();
  }

  @override
  Future<CartItemModel> updateItem(int id, int quantity) {
    throw UnimplementedError();
  }
}
