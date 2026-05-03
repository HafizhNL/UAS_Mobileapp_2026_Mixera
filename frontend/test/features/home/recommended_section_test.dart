import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/data/models/dashboard_model.dart';
import 'package:frontend/features/home/presentation/widgets/recommended_section.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(child: child))));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
  }

  RecommendedItemModel sample(String id, String name, String brand) {
    return RecommendedItemModel(
      id: id,
      name: name,
      brand: brand,
      imageUrl: 'https://example.invalid/p.png',
      price: 125000,
    );
  }

  testWidgets('RecommendedSection shows headers and item fields', (tester) async {
    await pumpHome(
      tester,
      RecommendedSection(
        items: [sample('r1', 'Dress', 'Mixera')],
      ),
    );

    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('Complete your fits!'), findsOneWidget);
    expect(find.text('View all →'), findsOneWidget);
    expect(find.text('Dress'), findsOneWidget);
    expect(find.text('Mixera'), findsOneWidget);
    expect(find.text('Rp 125.000'), findsOneWidget);
  });

  testWidgets('RecommendedSection view all and item taps fire callbacks', (tester) async {
    var viewAll = 0;
    RecommendedItemModel? tapped;
    final item = sample('r2', 'Skirt', 'BrandX');

    await pumpHome(
      tester,
      RecommendedSection(
        items: [item],
        onViewAll: () => viewAll++,
        onItemTap: (i) => tapped = i,
      ),
    );

    await tester.tap(find.text('View all →'));
    await tester.pump();
    expect(viewAll, 1);

    await tester.ensureVisible(find.text('Skirt'));
    await tester.pump();
    await tester.tap(find.text('Skirt'));
    await tester.pump();
    expect(tapped?.id, 'r2');
  });
}
