import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/navigation/presentation/pages/main_shell_page.dart';

void main() {
  Future<void> pumpShell(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));
  }

  List<Widget> fakeTabs() {
    return List<Widget>.generate(
      5,
      (i) => Scaffold(
        body: Center(child: Text('SHELL_TAB_$i')),
      ),
    );
  }

  testWidgets('MainShellPage starts on first tab', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainShellPage(tabBodies: fakeTabs()),
      ),
    );
    await pumpShell(tester);

    expect(find.text('SHELL_TAB_0'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('MainShellPage _onNavTap switches IndexedStack for each destination', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainShellPage(tabBodies: fakeTabs()),
      ),
    );
    await pumpShell(tester);

    await tester.tap(find.text('Wardrobe'));
    await pumpShell(tester);
    expect(find.text('SHELL_TAB_1'), findsOneWidget);

    await tester.tap(find.text('Mix'));
    await pumpShell(tester);
    expect(find.text('SHELL_TAB_2'), findsOneWidget);

    await tester.tap(find.text('Shop'));
    await pumpShell(tester);
    expect(find.text('SHELL_TAB_3'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await pumpShell(tester);
    expect(find.text('SHELL_TAB_4'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await pumpShell(tester);
    expect(find.text('SHELL_TAB_0'), findsOneWidget);
  });

  testWidgets('MainShellPage ignores tap on already selected tab', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MainShellPage(tabBodies: fakeTabs()),
      ),
    );
    await pumpShell(tester);

    expect(find.text('SHELL_TAB_0'), findsOneWidget);
    await tester.tap(find.text('Home'));
    await pumpShell(tester);
    expect(find.text('SHELL_TAB_0'), findsOneWidget);
  });
}
