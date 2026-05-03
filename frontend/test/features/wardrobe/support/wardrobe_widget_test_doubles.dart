import 'package:frontend/features/mix_match/data/datasources/mix_match_remote_datasource.dart';
import 'package:frontend/features/mix_match/data/models/mix_match_api_models.dart';
import 'package:frontend/features/wardrobe/data/datasources/wardrobe_remote_datasource.dart';
import 'package:frontend/features/wardrobe/data/models/wardrobe_api_models.dart';

/// Minimal [WardrobeDatasource] for wardrobe widget tests (no HTTP).
class WardrobeWidgetTestDatasource implements WardrobeDatasource {
  @override
  Future<List<WardrobeCategorySummaryEntry>> getCategorySummary() async => const [];

  @override
  Future<List<WardrobeItemApiModel>> getWardrobeItems({String? category}) async => const [];

  @override
  Future<UploadBatchDetailModel> createUploadBatch(List<String> imagePaths) async =>
      throw UnimplementedError();

  @override
  Future<UploadBatchDetailModel> getUploadBatchDetail(int batchId) async => throw UnimplementedError();

  @override
  Future<List<DetectedItemCandidateModel>> patchCandidates(
    int batchId,
    List<Map<String, dynamic>> candidates,
  ) async =>
      throw UnimplementedError();

  @override
  Future<List<WardrobeItemApiModel>> confirmBatch(int batchId) async => throw UnimplementedError();

  @override
  Future<WardrobeItemApiModel> patchItem(
    int id, {
    String? name,
    bool? isFavourite,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteItem(int id) async => throw UnimplementedError();
}

/// Minimal [MixMatchDatasource] so [MixMatchController.refreshSavedMixOutfits] succeeds.
class MixMatchWidgetTestDatasource implements MixMatchDatasource {
  @override
  Future<List<MixResultDetailModel>> listSavedMixResults() async => const [];

  @override
  Future<MixSessionModel> createSession() async => throw UnimplementedError();

  @override
  Future<MixSessionModel> getSession(int sessionId) async => throw UnimplementedError();

  @override
  Future<MixSessionModel> selectItems(int sessionId, List<int> itemIds) async =>
      throw UnimplementedError();

  @override
  Future<MixResultDetailModel> generate(int sessionId) async => throw UnimplementedError();

  @override
  Future<MixResultDetailModel> getResult(int resultId) async => throw UnimplementedError();

  @override
  Future<bool> toggleSaveResult(int resultId) async => throw UnimplementedError();
}
