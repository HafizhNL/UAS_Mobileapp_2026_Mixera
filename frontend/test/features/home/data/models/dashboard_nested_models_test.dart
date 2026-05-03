import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/data/models/dashboard_model.dart';
import 'package:frontend/features/home/data/models/quick_action_model.dart';

void main() {
  group('QuickActionModel.fromJson', () {
    test('parses route when present', () {
      final m = QuickActionModel.fromJson({
        'id': 'shop',
        'label': 'Shop',
        'icon_name': 'store',
        'route': '/shop',
      });
      expect(m.id, 'shop');
      expect(m.label, 'Shop');
      expect(m.iconName, 'store');
      expect(m.route, '/shop');
    });

    test('allows null route', () {
      final m = QuickActionModel.fromJson({
        'id': 'x',
        'label': 'X',
        'icon_name': 'help',
        'route': null,
      });
      expect(m.route, isNull);
    });
  });

  group('WardrobeItemModel.fromJson', () {
    test('maps id, image_url, name', () {
      final m = WardrobeItemModel.fromJson({
        'id': 'w1',
        'image_url': 'https://cdn/w.png',
        'name': 'Coat',
      });
      expect(m.id, 'w1');
      expect(m.imageUrl, 'https://cdn/w.png');
      expect(m.name, 'Coat');
    });
  });

  group('SaleItemModel.fromJson', () {
    test('parses numeric prices and discount', () {
      final m = SaleItemModel.fromJson({
        'id': 's1',
        'name': 'Sale tee',
        'image_url': 'https://cdn/t.png',
        'original_price': 100000.0,
        'sale_price': 75000,
        'discount_percent': 25,
      });
      expect(m.originalPrice, 100000.0);
      expect(m.salePrice, 75000.0);
      expect(m.discountPercent, 25);
    });
  });

  group('RecommendedItemModel.fromJson', () {
    test('parses brand and price', () {
      final m = RecommendedItemModel.fromJson({
        'id': 'r1',
        'name': 'Dress',
        'brand': 'Mixera',
        'image_url': 'https://cdn/d.png',
        'price': 199000.5,
      });
      expect(m.brand, 'Mixera');
      expect(m.price, 199000.5);
    });
  });
}
