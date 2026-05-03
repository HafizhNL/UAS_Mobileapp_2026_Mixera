import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/data/models/dashboard_model.dart';
import 'package:frontend/features/home/presentation/widgets/on_sale_section.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
  }

  SaleItemModel sampleItem(String id, String name) {
    return SaleItemModel(
      id: id,
      name: name,
      imageUrl: 'https://example.invalid/img.png',
      originalPrice: 200000,
      salePrice: 150000,
      discountPercent: 25,
    );
  }

  testWidgets('OnSaleSection shows headers and sale item name', (tester) async {
    await pumpHome(
      tester,
      OnSaleSection(
        items: [sampleItem('1', 'Jacket A')],
      ),
    );

    expect(find.text('On Sale'), findsOneWidget);
    expect(find.text('Limited time offers!'), findsOneWidget);
    expect(find.text('View all →'), findsOneWidget);
    expect(find.text('Jacket A'), findsOneWidget);
    expect(find.text('-25%'), findsOneWidget);
  });

  testWidgets('OnSaleSection view all and item taps fire callbacks', (tester) async {
    var viewAll = 0;
    SaleItemModel? tapped;
    final item = sampleItem('s1', 'Tee');

    await pumpHome(
      tester,
      OnSaleSection(
        items: [item],
        onViewAll: () => viewAll++,
        onItemTap: (i) => tapped = i,
      ),
    );

    await tester.tap(find.text('View all →'));
    await tester.pump();
    expect(viewAll, 1);

    await tester.ensureVisible(find.text('Tee'));
    await tester.pump();
    await tester.tap(find.text('Tee'));
    await tester.pump();
    expect(tapped?.id, 's1');
  });
}
