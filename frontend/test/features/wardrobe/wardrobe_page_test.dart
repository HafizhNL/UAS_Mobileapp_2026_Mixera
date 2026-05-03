import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/wardrobe/presentation/controllers/wardrobe_controller.dart';
import 'package:frontend/features/wardrobe/presentation/pages/wardrobe_page.dart';

import 'support/wardrobe_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpWardrobe(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('WardrobePage shows header, upload, saved outfits, and category grid', (tester) async {
    final wardrobeDs = WardrobeWidgetTestDatasource();
    Get.put<WardrobeController>(WardrobeController(datasource: wardrobeDs));
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: wardrobeDs,
      ),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: WardrobePage(),
      ),
    );
    await pumpWardrobe(tester);

    expect(find.text('Wardrobe'), findsOneWidget);
    expect(find.text('Upload Photos'), findsOneWidget);
    expect(find.text('Saved Outfits'), findsOneWidget);
    expect(find.text('You have 0 Outfits'), findsOneWidget);
    expect(find.text('Top'), findsWidgets);
    expect(find.text('Bottom'), findsWidgets);
  });
}
