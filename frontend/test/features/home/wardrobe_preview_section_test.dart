import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/data/models/dashboard_model.dart';
import 'package:frontend/features/home/presentation/widgets/wardrobe_preview_section.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
  }

  testWidgets('WardrobePreviewSection empty state message', (tester) async {
    await pumpHome(
      tester,
      const WardrobePreviewSection(items: []),
    );

    expect(find.text('Your Wardrobe'), findsOneWidget);
    expect(
      find.text('No items yet — add clothes from Wardrobe.'),
      findsOneWidget,
    );
  });

  testWidgets('WardrobePreviewSection view all invokes callback', (tester) async {
    var calls = 0;
    final items = [
      const WardrobeItemModel(id: 'w1', imageUrl: 'https://x/i.png', name: 'Coat'),
    ];

    await pumpHome(
      tester,
      WardrobePreviewSection(
        items: items,
        onViewAll: () => calls++,
      ),
    );

    expect(find.text('Your Wardrobe'), findsOneWidget);
    await tester.tap(find.text('View all →'));
    await tester.pump();
    expect(calls, 1);
  });
}
