import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/pick_from_wardrobe_page.dart';

import 'support/mix_match_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpPicker(WidgetTester tester) async {
    await tester.pump();
    for (var i = 0; i < 15; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      if (find.text('Add').evaluate().isNotEmpty) break;
    }
  }

  testWidgets('PickFromWardrobePage loads tabs and picker grid', (tester) async {
    final wardrobe = MixMatchSpotlightWardrobeDatasource();
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchSessionTestDatasource(),
        wardrobeDatasource: wardrobe,
      ),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: PickFromWardrobePage(),
      ),
    );
    await pumpPicker(tester);

    expect(find.text('Pick From Wardrobe'), findsOneWidget);
    expect(find.text('Tops'), findsOneWidget);
    expect(find.text('0 / 5 selected'), findsOneWidget);
    expect(find.byType(GridView), findsWidgets);
    expect(find.text('Add'), findsWidgets);
    expect(find.text('Add to outfit'), findsOneWidget);
  });
}
