import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/cart/data/models/cart_item_model.dart';
import 'package:frontend/features/cart/presentation/widgets/cart_item_tile.dart';

void main() {
  testWidgets('CartItemTile shows product fields and quantity', (tester) async {
    var lastQty = -1;
    var removeCalls = 0;

    const item = CartItemModel(
      id: 5,
      variantId: 50,
      productName: 'Tile Product',
      productSlug: 'tile-product',
      size: 'L',
      color: 'White',
      primaryImage: 'https://example.com/p.jpg',
      quantity: 2,
      unitPrice: 45000,
      lineTotal: 90000,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartItemTile(
            item: item,
            onRemove: () => removeCalls++,
            onQuantityChanged: (q) => lastQty = q,
          ),
        ),
      ),
    );

    expect(find.text('Tile Product'), findsOneWidget);
    expect(find.text('White'), findsOneWidget);
    expect(find.text('Size : L'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pump();
    expect(lastQty, 3);

    await tester.tap(find.byIcon(Icons.remove_rounded));
    await tester.pump();
    expect(lastQty, 1);
  });
}
