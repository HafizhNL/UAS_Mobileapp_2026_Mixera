import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/wardrobe/data/models/wardrobe_api_models.dart';
import 'package:frontend/features/wardrobe/presentation/controllers/wardrobe_controller.dart';
import 'package:frontend/features/wardrobe/presentation/pages/wardrobe_batch_review_page.dart';

import 'support/wardrobe_widget_test_doubles.dart';

/// Supports confirm flow on [WardrobeBatchReviewPage].
class _WardrobeBatchConfirmTestDatasource extends WardrobeWidgetTestDatasource {
  @override
  Future<List<DetectedItemCandidateModel>> patchCandidates(
    int batchId,
    List<Map<String, dynamic>> candidates,
  ) async =>
      const [];

  @override
  Future<List<WardrobeItemApiModel>> confirmBatch(int batchId) async => const [];
}

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpBatch(WidgetTester tester) async {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  testWidgets('Batch review empty state and snackbar when confirming none', (tester) async {
    Get.put<WardrobeController>(WardrobeController(datasource: WardrobeWidgetTestDatasource()));

    const batch = UploadBatchDetailModel(
      id: 1,
      status: 'review_ready',
      photos: [],
    );

    await tester.pumpWidget(
      const GetMaterialApp(
        home: WardrobeBatchReviewPage(batch: batch),
      ),
    );
    await pumpBatch(tester);

    expect(find.text('Tidak ada item terdeteksi pada foto ini.'), findsOneWidget);

    await tester.tap(find.text('Add to Wardrobe'));
    await pumpBatch(tester);
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Pilih minimal satu item.'), findsOneWidget);
    Get.closeAllSnackbars();
    // Let GetX snackbar overlay finish animations before the test disposes the tree.
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  });

  testWidgets('Batch review pops true after confirm with selection', (tester) async {
    Get.put<WardrobeController>(WardrobeController(datasource: _WardrobeBatchConfirmTestDatasource()));

    const candidate = DetectedItemCandidateModel(
      id: 10,
      photoId: 1,
      isSelected: false,
      category: 'top',
      subcategory: 'Tee',
      color: '',
      styleTags: [],
    );

    // Absolute URL so [resolveMediaUrl] never reads [ApiBaseUrl.origin] (dotenv) in tests.
    final batch = UploadBatchDetailModel(
      id: 42,
      status: 'review_ready',
      photos: [
        UploadedPhotoModel(
          id: 1,
          image: 'https://example.com/photo.jpg',
          candidates: const [candidate],
        ),
      ],
    );

    bool? popped;
    await tester.pumpWidget(
      GetMaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: TextButton(
                onPressed: () async {
                  popped = await Navigator.of(context).push<bool>(
                    MaterialPageRoute(
                      builder: (_) => WardrobeBatchReviewPage(batch: batch),
                    ),
                  );
                },
                child: const Text('open'),
              ),
            );
          },
        ),
      ),
    );
    await pumpBatch(tester);

    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final checkbox = find.byType(Checkbox);
    expect(checkbox, findsOneWidget);
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox);
    await pumpBatch(tester);

    await tester.tap(find.text('Add to Wardrobe'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(popped, isTrue);
  });
}
