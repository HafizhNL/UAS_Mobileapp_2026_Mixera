import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/mix_match/data/datasources/mix_match_remote_datasource.dart';
import 'package:frontend/features/mix_match/data/models/mix_match_api_models.dart';
import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/wardrobe/data/datasources/wardrobe_remote_datasource.dart';
import 'package:frontend/features/wardrobe/data/models/wardrobe_api_models.dart';

void main() {
  test('toggleItem tracks selected ids and top-bottom rule', () {
    final controller = MixMatchController(
      mixDatasource: _FakeMixMatchDatasource(),
      wardrobeDatasource: _FakeWardrobeForMix(),
    );
    final top = _item(id: 1, category: 'top');
    final bottom = _item(id: 2, category: 'bottom');

    controller.toggleItem(top);
    expect(controller.selectedItemIds, <int>[1]);
    expect(controller.hasTopAndBottom, isFalse);

    controller.toggleItem(bottom);
    expect(controller.selectedItemIds, <int>[1, 2]);
    expect(controller.hasTopAndBottom, isTrue);

    controller.toggleItem(top);
    expect(controller.selectedItemIds, <int>[2]);
    expect(controller.hasTopAndBottom, isFalse);
  });
}

WardrobeItemApiModel _item({required int id, required String category}) {
  return WardrobeItemApiModel(
    id: id,
    category: category,
    subcategory: '',
    color: '',
    styleTags: const [],
    image: '',
    name: 'Item $id',
    notes: '',
  );
}

class _FakeMixMatchDatasource implements MixMatchDatasource {
  @override
  Future<MixSessionModel> createSession() async => throw UnimplementedError();

  @override
  Future<MixSessionModel> getSession(int sessionId) async => throw UnimplementedError();

  @override
  Future<MixResultDetailModel> generate(int sessionId) async => throw UnimplementedError();

  @override
  Future<MixResultDetailModel> getResult(int resultId) async => throw UnimplementedError();

  @override
  Future<List<MixResultDetailModel>> listSavedMixResults() async => throw UnimplementedError();

  @override
  Future<MixSessionModel> selectItems(int sessionId, List<int> itemIds) async =>
      throw UnimplementedError();

  @override
  Future<bool> toggleSaveResult(int resultId) async => throw UnimplementedError();
}

class _FakeWardrobeForMix implements WardrobeDatasource {
  @override
  Future<List<WardrobeItemApiModel>> confirmBatch(int batchId) async => throw UnimplementedError();

  @override
  Future<UploadBatchDetailModel> createUploadBatch(List<String> imagePaths) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteItem(int id) async => throw UnimplementedError();

  @override
  Future<UploadBatchDetailModel> getUploadBatchDetail(int batchId) async =>
      throw UnimplementedError();

  @override
  Future<List<WardrobeCategorySummaryEntry>> getCategorySummary() async =>
      throw UnimplementedError();

  @override
  Future<List<WardrobeItemApiModel>> getWardrobeItems({String? category}) async =>
      throw UnimplementedError();

  @override
  Future<List<DetectedItemCandidateModel>> patchCandidates(
    int batchId,
    List<Map<String, dynamic>> candidates,
  ) async =>
      throw UnimplementedError();

  @override
  Future<WardrobeItemApiModel> patchItem(
    int id, {
    String? name,
    bool? isFavourite,
  }) async =>
      throw UnimplementedError();
}
