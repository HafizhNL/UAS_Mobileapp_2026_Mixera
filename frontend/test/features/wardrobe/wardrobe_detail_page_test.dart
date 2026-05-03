import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/wardrobe/presentation/controllers/wardrobe_controller.dart';
import 'package:frontend/features/wardrobe/presentation/pages/wardrobe_detail_page.dart';

import 'support/wardrobe_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('WardrobeDetailPage shows count line and filter chip', (tester) async {
    Get.put<WardrobeController>(WardrobeController(datasource: WardrobeWidgetTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: WardrobeDetailPage(
          categorySlug: 'top',
          displayTitle: 'Top',
          itemCountHint: 0,
        ),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));

    expect(
      find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('You own'),
      ),
      findsOneWidget,
    );
    expect(find.text('Filter'), findsOneWidget);
  });
}
