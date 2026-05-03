import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/profile/presentation/pages/saved_try_on_photos_page.dart';
import 'package:frontend/features/tryon/presentation/controllers/tryon_controller.dart';

import '../tryon/support/tryon_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets('SavedTryOnPhotosPage shows empty-state when list is empty',
      (tester) async {
    tester.view.physicalSize = const Size(900, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(TryOnController(datasource: TryOnWidgetTestDatasource()));
    await tester.pumpWidget(
      const GetMaterialApp(home: SavedTryOnPhotosPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('My Try-On Photos'), findsOneWidget);
    expect(find.text('Belum ada foto try-on tersimpan'), findsOneWidget);
  });
}
