import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/navigation/presentation/widgets/app_bottom_navbar.dart';

void main() {
  testWidgets('renders navigation destinations and reports taps', (tester) async {
    final tappedIndexes = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: AppBottomNav(
            selectedIndex: 0,
            onTap: tappedIndexes.add,
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Wardrobe'), findsOneWidget);
    expect(find.text('Mix'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    await tester.tap(find.text('Wardrobe'));
    await tester.tap(find.text('Mix'));
    await tester.tap(find.text('Shop'));
    await tester.tap(find.text('Profile'));

    expect(tappedIndexes, <int>[1, 2, 3, 4]);
  });
}
