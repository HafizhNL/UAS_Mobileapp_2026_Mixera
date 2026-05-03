import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/profile/presentation/widgets/security_option_tile.dart';

void main() {
  testWidgets('renders title, description, trailing, and children', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SecurityOptionTile(
            icon: Icons.lock_outline,
            title: 'App lock',
            description: 'Require unlock before opening the app',
            trailing: const Icon(Icons.chevron_right),
            children: const [Text('Extra setting')],
          ),
        ),
      ),
    );

    expect(find.text('App lock'), findsOneWidget);
    expect(find.text('Require unlock before opening the app'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    expect(find.text('Extra setting'), findsOneWidget);
  });
}
