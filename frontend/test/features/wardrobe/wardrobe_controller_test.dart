import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/wardrobe/data/datasources/wardrobe_remote_datasource.dart';
import 'package:frontend/features/wardrobe/data/models/wardrobe_api_models.dart';
import 'package:frontend/features/wardrobe/presentation/controllers/wardrobe_controller.dart';

void main() {
  test('availableStyleTags returns unique sorted tags', () {
    final controller = WardrobeController(datasource: _FakeWardrobeDatasource());

    controller.categoryItems.assignAll([
      _item(id: 1, styleTags: const ['casual', 'formal']),
      _item(id: 2, styleTags: const ['street', 'casual']),
    ]);

    expect(controller.availableStyleTags, <String>['casual', 'formal', 'street']);
  });

  test('filteredCategoryItems applies style tag and favourite filters', () {
    final controller = WardrobeController(datasource: _FakeWardrobeDatasource());
    final casual = _item(id: 1, styleTags: const ['casual']);
    final formalFavourite = _item(
      id: 2,
      styleTags: const ['formal'],
      isFavourite: true,
    );

    controller.categoryItems.assignAll([casual, formalFavourite]);

    controller.selectedStyleTag.value = 'casual';
    expect(controller.filteredCategoryItems, [casual]);

    controller.setFavouritesFilter();
    expect(controller.filteredCategoryItems, [formalFavourite]);
  });
}

WardrobeItemApiModel _item({
  required int id,
  required List<String> styleTags,
  bool isFavourite = false,
}) {
  return WardrobeItemApiModel(
    id: id,
    category: 'top',
    subcategory: 'shirt',
    color: 'white',
    styleTags: styleTags,
    image: '',
    name: 'Item $id',
    notes: '',
    isFavourite: isFavourite,
  );
}

class _FakeWardrobeDatasource implements WardrobeDatasource {
  @override
  Future<List<WardrobeItemApiModel>> confirmBatch(int batchId) {
    throw UnimplementedError();
  }

  @override
  Future<UploadBatchDetailModel> createUploadBatch(List<String> imagePaths) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteItem(int id) {
    throw UnimplementedError();
  }

  @override
  Future<UploadBatchDetailModel> getUploadBatchDetail(int batchId) {
    throw UnimplementedError();
  }

  @override
  Future<List<WardrobeItemApiModel>> getWardrobeItems({String? category}) {
    throw UnimplementedError();
  }

  @override
  Future<List<WardrobeCategorySummaryEntry>> getCategorySummary() {
    throw UnimplementedError();
  }

  @override
  Future<List<DetectedItemCandidateModel>> patchCandidates(
    int batchId,
    List<Map<String, dynamic>> candidates,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<WardrobeItemApiModel> patchItem(
    int id, {
    String? name,
    bool? isFavourite,
  }) {
    throw UnimplementedError();
  }
}
