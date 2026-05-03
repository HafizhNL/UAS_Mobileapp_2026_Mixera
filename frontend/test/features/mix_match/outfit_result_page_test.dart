import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/mix_match/data/models/mix_match_api_models.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/outfit_result_page.dart';

import '../wardrobe/support/wardrobe_widget_test_doubles.dart';
import 'support/mix_match_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('OutfitResultPage shows preloaded result without generating', (tester) async {
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: WardrobeWidgetTestDatasource(),
      ),
    );

    const result = MixResultDetailModel(
      id: 99,
      styleLabel: 'Preloaded Style',
      explanation: 'Looks good',
      tips: '',
      score: 93,
      isSaved: false,
      previewImage: 'https://example.com/outfit.jpg',
      selectedItems: [kMixTestTopItem],
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: OutfitResultPage(preloadedResult: result),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Mix Outfit Result'), findsOneWidget);
    expect(find.text('Preloaded Style'), findsOneWidget);
    expect(find.text('Score: 93 / 100'), findsOneWidget);
  });
}
