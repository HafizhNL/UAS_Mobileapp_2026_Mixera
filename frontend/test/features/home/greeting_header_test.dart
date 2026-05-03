import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/presentation/widgets/greeting_header.dart';

void main() {
  Future<void> pumpHome(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
  }

  testWidgets('GreetingHeader shows greeting and subtitle', (tester) async {
    await pumpHome(
      tester,
      const GreetingHeader(
        greeting: 'Hello, Alex',
        subtitle: 'Good morning',
      ),
    );

    expect(find.text('Hello, Alex'), findsOneWidget);
    expect(find.text('Good morning'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
  });

  testWidgets('GreetingHeader notification tap invokes callback', (tester) async {
    var tapped = false;
    await pumpHome(
      tester,
      GreetingHeader(
        greeting: 'Hi',
        subtitle: 'There',
        onNotificationTap: () => tapped = true,
      ),
    );

    await tester.tap(find.byIcon(Icons.notifications_none_rounded));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('GreetingHeader shows numeric unread badge', (tester) async {
    await pumpHome(
      tester,
      const GreetingHeader(
        greeting: 'Hi',
        subtitle: 'There',
        unreadCount: 3,
      ),
    );

    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('GreetingHeader caps unread badge at 99+', (tester) async {
    await pumpHome(
      tester,
      const GreetingHeader(
        greeting: 'Hi',
        subtitle: 'There',
        unreadCount: 120,
      ),
    );

    expect(find.text('99+'), findsOneWidget);
  });
}
