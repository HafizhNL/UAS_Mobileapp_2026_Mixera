import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/app/app.dart';
import 'package:frontend/app/routes/app_router.dart';
import 'package:frontend/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('MixeraApp wires theme, router, and exits splash without pending timers',
      (tester) async {
    await tester.pumpWidget(const MixeraApp());
    await tester.pump();

    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.onGenerateRoute, same(AppRouter.onGenerateRoute));
    expect(materialApp.initialRoute, AppRouter.initialRoute);
    expect(materialApp.theme, isNotNull);
    expect(materialApp.debugShowCheckedModeBanner, isFalse);

    // [SplashPage] schedules timers in initState; advance time like splash_page_test.
    for (var i = 0; i < 24; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (!tester.any(find.byType(SplashPage))) break;
    }
    expect(find.byType(SplashPage), findsNothing);
  });
}
