import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/cart/data/models/cart_item_model.dart';
import 'package:frontend/features/cart/data/models/cart_summary_model.dart';

void main() {
  test('CartSummaryModel.fromJson maps items, total, and count', () {
    final model = CartSummaryModel.fromJson({
      'count': 1,
      'total': 12000,
      'items': [
        {
          'id': 2,
          'variant': 20,
          'product_name': 'Pleated Skirt',
          'product_slug': 'pleated-skirt',
          'size': 'S',
          'color': 'Black',
          'quantity': 1,
          'unit_price': 12000,
          'line_total': 12000,
        },
      ],
    });

    expect(model.count, 1);
    expect(model.total, 12000);
    expect(model.items, hasLength(1));
    expect(model.items.single, isA<CartItemModel>());
    expect(model.items.single.productName, 'Pleated Skirt');
    expect(model.items.single.variantId, 20);
    expect(model.items.single.lineTotal, 12000);
  });

  test('CartSummaryModel.fromJson tolerates missing items and numeric defaults', () {
    final model = CartSummaryModel.fromJson({'total': 0});

    expect(model.items, isEmpty);
    expect(model.count, 0);
    expect(model.total, 0);
  });
}
