import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/saved_outfits_page.dart';

import '../wardrobe/support/wardrobe_widget_test_doubles.dart';
import 'support/mix_match_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpSaved(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('SavedOutfitsPage empty state', (tester) async {
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: WardrobeWidgetTestDatasource(),
      ),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SavedOutfitsPage(),
      ),
    );
    await pumpSaved(tester);

    expect(find.text('Belum ada outfit tersimpan'), findsOneWidget);
  });

  testWidgets('SavedOutfitsPage lists saved outfit card', (tester) async {
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchSavedOutfitsTestDatasource(),
        wardrobeDatasource: WardrobeWidgetTestDatasource(),
      ),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SavedOutfitsPage(),
      ),
    );
    await pumpSaved(tester);

    expect(find.text('Saved Test Look'), findsOneWidget);
    expect(find.text('top'), findsOneWidget);
  });
}
