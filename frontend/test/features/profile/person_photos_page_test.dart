import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/profile/presentation/pages/person_photos_page.dart';
import 'package:frontend/features/tryon/presentation/controllers/tryon_controller.dart';

import '../tryon/support/tryon_widget_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  testWidgets('PersonPhotosPage shows empty guidance after refresh', (tester) async {
    tester.view.physicalSize = const Size(900, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    Get.put(TryOnController(datasource: TryOnWidgetTestDatasource()));
    await tester.pumpWidget(
      const GetMaterialApp(home: PersonPhotosPage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Foto tubuh (Try-On)'), findsOneWidget);
    expect(
      find.textContaining('Belum ada foto.'),
      findsOneWidget,
    );
    expect(find.text('Tambah foto'), findsOneWidget);
  });
}
