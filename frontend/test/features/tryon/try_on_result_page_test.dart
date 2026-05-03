import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/tryon/data/models/tryon_api_models.dart';
import 'package:frontend/features/tryon/presentation/controllers/tryon_controller.dart';
import 'package:frontend/features/tryon/presentation/pages/try_on_result_page.dart';

import 'support/tryon_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets('TryOnResultPage shows invalid-source copy when shop id missing',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(TryOnController(datasource: TryOnWidgetTestDatasource()));
    await tester.pumpWidget(
      const GetMaterialApp(
        home: TryOnResultPage(
          sourceType: TryOnSourceKind.shopProduct,
          shopProductId: null,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Produk tidak valid untuk try-on.'), findsOneWidget);
  });

  testWidgets('TryOnResultPage idle person-picker shows Virtual Try-On headline',
      (tester) async {
    tester.view.physicalSize = const Size(900, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(TryOnController(datasource: TryOnWidgetTestDatasource()));
    await tester.pumpWidget(
      const GetMaterialApp(
        home: TryOnResultPage(
          sourceType: TryOnSourceKind.shopProduct,
          shopProductId: 1,
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(find.text('Virtual Try-On'), findsOneWidget);
    expect(
      find.textContaining('Belum ada foto tubuh'),
      findsOneWidget,
    );
  });
}
