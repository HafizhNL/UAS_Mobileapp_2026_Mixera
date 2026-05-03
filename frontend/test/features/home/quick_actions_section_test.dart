import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/data/models/quick_action_model.dart';
import 'package:frontend/features/home/presentation/widgets/quick_actions_section.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
  }

  testWidgets('QuickActionsSection lists labels and section title', (tester) async {
    final actions = [
      const QuickActionModel(id: 'a', label: 'Shop', iconName: 'bag', route: '/shop'),
      const QuickActionModel(id: 'b', label: 'Mix', iconName: 'sparkles', route: '/mix'),
    ];

    await pumpHome(tester, QuickActionsSection(actions: actions));

    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.text('Shop'), findsOneWidget);
    expect(find.text('Mix'), findsOneWidget);
  });

  testWidgets('QuickActionsSection forwards tap to onActionTap', (tester) async {
    QuickActionModel? received;
    final actions = [
      const QuickActionModel(id: 'x', label: 'TapMe', iconName: 'shirt', route: null),
    ];

    await pumpHome(
      tester,
      QuickActionsSection(
        actions: actions,
        onActionTap: (a) => received = a,
      ),
    );

    await tester.tap(find.text('TapMe'));
    await tester.pump();
    expect(received?.id, 'x');
  });
}
