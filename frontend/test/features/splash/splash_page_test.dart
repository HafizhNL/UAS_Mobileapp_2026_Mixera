import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('SplashPage runs scripted delays then replaces route to auth gate', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: RouteNames.splash,
        routes: {
          RouteNames.splash: (_) => const SplashPage(),
          RouteNames.authGate: (_) => const Scaffold(body: Text('Auth gate')),
        },
      ),
    );

    await tester.pump();
    expect(find.byType(SplashPage), findsOneWidget);

    // Splash uses Future.delayed between letter steps; advance fake time until navigation fires.
    for (var i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (tester.any(find.text('Auth gate'))) break;
    }

    expect(find.text('Auth gate'), findsOneWidget);
    expect(find.byType(SplashPage), findsNothing);
  });
}
