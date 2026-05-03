import 'package:frontend/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:frontend/features/cart/data/models/cart_item_model.dart';
import 'package:frontend/features/cart/data/models/cart_summary_model.dart';

/// Minimal [CartDatasource] for widget tests (no HTTP).
class CartWidgetTestDatasource implements CartDatasource {
  @override
  Future<CartSummaryModel> getCart() async => const CartSummaryModel(
        items: [],
        total: 0,
        count: 0,
      );

  @override
  Future<CartItemModel> addItem(int variantId, int quantity) async => CartItemModel(
        id: 1,
        variantId: variantId,
        productName: 'Test',
        productSlug: 'test',
        size: 'M',
        color: '',
        quantity: quantity,
        unitPrice: 0,
        lineTotal: 0,
      );

  @override
  Future<CartItemModel> updateItem(int id, int quantity) async => throw UnimplementedError();

  @override
  Future<void> removeItem(int id) async => throw UnimplementedError();

  @override
  Future<void> clearCart() async => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> postShippingQuote({
    int? addressId,
    String? destinationPostalCode,
  }) async =>
      throw UnimplementedError();
}

/// Mutable cart with one line for [CartPage] / tile interaction tests.
class CartWithOneItemTestDatasource implements CartDatasource {
  final List<CartItemModel> _items = [
    const CartItemModel(
      id: 1,
      variantId: 10,
      productName: 'Cart Test Tee',
      productSlug: 'cart-test-tee',
      size: 'M',
      color: 'Black',
      primaryImage: 'https://example.com/cart-tee.jpg',
      quantity: 1,
      unitPrice: 99000,
      lineTotal: 99000,
    ),
  ];

  CartSummaryModel _summary() {
    final count = _items.fold<int>(0, (a, b) => a + b.quantity);
    final total = _items.fold<int>(0, (a, b) => a + b.lineTotal);
    return CartSummaryModel(items: List.from(_items), total: total, count: count);
  }

  @override
  Future<CartSummaryModel> getCart() async => _summary();

  @override
  Future<CartItemModel> addItem(int variantId, int quantity) async => throw UnimplementedError();

  @override
  Future<CartItemModel> updateItem(int id, int quantity) async {
    final i = _items.indexWhere((e) => e.id == id);
    if (i == -1) throw StateError('unknown item');
    final c = _items[i];
    final next = CartItemModel(
      id: c.id,
      variantId: c.variantId,
      productName: c.productName,
      productSlug: c.productSlug,
      size: c.size,
      color: c.color,
      primaryImage: c.primaryImage,
      quantity: quantity,
      unitPrice: c.unitPrice,
      lineTotal: c.unitPrice * quantity,
    );
    _items[i] = next;
    return next;
  }

  @override
  Future<void> removeItem(int id) async {
    _items.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> clearCart() async {
    _items.clear();
  }

  @override
  Future<Map<String, dynamic>> postShippingQuote({
    int? addressId,
    String? destinationPostalCode,
  }) async =>
      throw UnimplementedError();
}

/// Cart + shipping quote for [CheckoutController.fetchShippingQuotePreview] in widget tests.
class CartCheckoutTestDatasource extends CartWithOneItemTestDatasource {
  @override
  Future<Map<String, dynamic>> postShippingQuote({
    int? addressId,
    String? destinationPostalCode,
  }) async =>
      {
        'note': 'Test quote',
        'estimated_weight_grams': 500,
        'quotes': [
          {
            'courier': 'JNE',
            'service': 'REG',
            'price': 15000,
            'duration': '2-3 hari',
          },
        ],
      };
}
