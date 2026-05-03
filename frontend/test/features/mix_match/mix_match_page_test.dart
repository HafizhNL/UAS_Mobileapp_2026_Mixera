import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/mix_match_page.dart';

import '../wardrobe/support/wardrobe_widget_test_doubles.dart';
import 'support/mix_match_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpMix(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('MixMatchPage shows hero, spotlight item, and CTAs', (tester) async {
    final wardrobe = MixMatchSpotlightWardrobeDatasource();
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: wardrobe,
      ),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: MixMatchPage(),
      ),
    );
    await pumpMix(tester);

    expect(find.text('Mix & Match'), findsOneWidget);
    expect(find.text('Clothing Recommendations'), findsOneWidget);
    expect(find.text('Mix Picker Top'), findsOneWidget);
    expect(find.text('Pick From Wardrobe'), findsOneWidget);
    expect(find.text('Belum ada hasil mix'), findsOneWidget);
    expect(find.text('Start mixing'), findsOneWidget);
  });
}
