import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/features/splash/presentation/pages/splash_page.dart';
import 'package:integration_test/integration_test.dart';

/// Device-level smoke (T6): real [SplashPage] + navigator, no `main()`, Firebase, or dotenv.
///
/// Run on a supported device (e.g. Android emulator):
/// `flutter test integration_test/smoke/app_boot_smoke_test.dart -d <deviceId>`
///
/// Web targets are not supported for `integration_test`. Windows desktop may require
/// a working CMake/Firebase Windows build for that target.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Splash completes scripted sequence and reaches auth-gate route', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: RouteNames.splash,
        routes: {
          RouteNames.splash: (_) => const SplashPage(),
          RouteNames.authGate: (_) => const Scaffold(
                body: Center(child: Text('INTEGRATION_AUTH_GATE')),
              ),
        },
      ),
    );

    await tester.pump();
    expect(find.byType(SplashPage), findsOneWidget);

    for (var i = 0; i < 16; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (tester.any(find.text('INTEGRATION_AUTH_GATE'))) break;
    }

    expect(find.text('INTEGRATION_AUTH_GATE'), findsOneWidget);
    expect(find.byType(SplashPage), findsNothing);
  });
}
