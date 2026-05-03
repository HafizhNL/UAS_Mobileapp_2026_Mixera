import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/cart/data/models/cart_item_model.dart';

void main() {
  group('CartItemModel.fromJson', () {
    test('maps API fields including variant and optional primary_image', () {
      final m = CartItemModel.fromJson({
        'id': 10,
        'variant': 55,
        'product_name': 'Jacket',
        'product_slug': 'jacket-x',
        'size': 'M',
        'color': 'Black',
        'primary_image': 'https://example.com/a.png',
        'quantity': 2,
        'unit_price': 100000,
        'line_total': 200000,
      });

      expect(m.id, 10);
      expect(m.variantId, 55);
      expect(m.productName, 'Jacket');
      expect(m.productSlug, 'jacket-x');
      expect(m.size, 'M');
      expect(m.color, 'Black');
      expect(m.primaryImage, 'https://example.com/a.png');
      expect(m.quantity, 2);
      expect(m.unitPrice, 100000);
      expect(m.lineTotal, 200000);
    });

    test('uses empty strings for missing name fields and null image', () {
      final m = CartItemModel.fromJson({
        'id': 1,
        'variant': 2,
        'quantity': 1,
        'unit_price': 5000,
        'line_total': 5000,
      });

      expect(m.productName, '');
      expect(m.productSlug, '');
      expect(m.size, '');
      expect(m.color, '');
      expect(m.primaryImage, isNull);
    });
  });

  group('CartItemModel.copyWith', () {
    test('recomputes line_total when quantity changes', () {
      const base = CartItemModel(
        id: 1,
        variantId: 1,
        productName: 'P',
        productSlug: 'p',
        size: 'S',
        color: 'Red',
        quantity: 2,
        unitPrice: 30000,
        lineTotal: 60000,
      );

      final updated = base.copyWith(quantity: 5);
      expect(updated.quantity, 5);
      expect(updated.lineTotal, 150000);
    });
  });
}
