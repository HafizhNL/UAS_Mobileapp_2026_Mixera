import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/profile/presentation/pages/saved_try_on_detail_page.dart';
import 'package:frontend/features/tryon/data/models/tryon_api_models.dart';
import 'package:frontend/features/tryon/presentation/controllers/tryon_controller.dart';

import '../tryon/support/tryon_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets('SavedTryOnDetailPage shows source label and notes after request loads',
      (tester) async {
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    const entry = TryOnSavedEntryModel(
      id: 7,
      requestId: 42,
      sourceType: 'shop_product',
      resultImage: null,
      isSaved: true,
      notes: 'Catatan uji',
      createdAt: null,
    );

    final detail = TryOnRequestDetailModel(
      id: 42,
      status: 'completed',
      sourceType: 'shop_product',
      personImage: const PersonProfileImageModel(
        id: 1,
        image: '',
        label: 'Utama',
        isActive: true,
      ),
      shopProductId: 9,
      result: const TryOnResultModel(
        id: 7,
        notes: 'Catatan uji',
        isSaved: true,
      ),
    );

    Get.put(
      TryOnController(
        datasource: TryOnWidgetTestDatasource(
          requestById: {42: detail},
        ),
      ),
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: SavedTryOnDetailPage(entry: entry),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Try-on preview'), findsOneWidget);
    expect(find.text('From shop product'), findsOneWidget);
    expect(find.text('Catatan uji'), findsWidgets);
  });
}
