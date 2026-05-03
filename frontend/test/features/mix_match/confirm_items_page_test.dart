import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/mix_match/data/models/mix_match_api_models.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/confirm_items_page.dart';

import '../wardrobe/support/wardrobe_widget_test_doubles.dart';
import 'support/mix_match_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('ConfirmItemsPage shows session items and Mix Outfit', (tester) async {
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: WardrobeWidgetTestDatasource(),
      ),
    );

    const session = MixSessionModel(
      id: 1,
      status: 'selecting',
      selectedItems: [kMixTestTopItem],
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: ConfirmItemsPage(session: session),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Confirm Your Items'), findsOneWidget);
    expect(find.text('Mix Picker Top'), findsOneWidget);
    expect(find.text('Mix Outfit'), findsOneWidget);
    expect(find.text('Cancel'), findsWidgets);
  });
}
