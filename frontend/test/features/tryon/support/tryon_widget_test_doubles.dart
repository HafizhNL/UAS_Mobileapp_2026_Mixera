import 'package:frontend/features/tryon/data/datasources/tryon_remote_datasource.dart';
import 'package:frontend/features/tryon/data/models/tryon_api_models.dart';

/// [TryOnDatasource] with no network; safe defaults for try-on profile / saved pages.
class TryOnWidgetTestDatasource implements TryOnDatasource {
  TryOnWidgetTestDatasource({
    List<PersonProfileImageModel>? personImages,
    List<TryOnSavedEntryModel>? savedResults,
    Map<int, TryOnRequestDetailModel>? requestById,
  })  : _personImages = List<PersonProfileImageModel>.from(personImages ?? const []),
        _savedResults = List<TryOnSavedEntryModel>.from(savedResults ?? const []),
        _requestById = requestById ?? const {};

  final List<PersonProfileImageModel> _personImages;
  final List<TryOnSavedEntryModel> _savedResults;
  final Map<int, TryOnRequestDetailModel> _requestById;

  @override
  Future<void> archivePersonImage(int imageId) async {}

  @override
  Future<PersonProfileImageModel> activatePersonImage(int imageId) async {
    final list = _personImages.map((p) {
      if (p.id == imageId) {
        return PersonProfileImageModel(
          id: p.id,
          image: p.image,
          label: p.label,
          isActive: true,
          isArchived: p.isArchived,
          uploadedAt: p.uploadedAt,
        );
      }
      return PersonProfileImageModel(
        id: p.id,
        image: p.image,
        label: p.label,
        isActive: false,
        isArchived: p.isArchived,
        uploadedAt: p.uploadedAt,
      );
    }).toList();
    _personImages
      ..clear()
      ..addAll(list);
    return _personImages.firstWhere((p) => p.id == imageId);
  }

  @override
  Future<TryOnRequestDetailModel> createTryOnRequest({
    required int personImageId,
    required TryOnSourceKind sourceType,
    int? mixResultId,
    int? shopProductId,
  }) async {
    return TryOnRequestDetailModel(
      id: 1,
      status: 'completed',
      sourceType: sourceType.apiValue,
      personImage: PersonProfileImageModel(
        id: personImageId,
        image: '',
        label: '',
        isActive: true,
      ),
      mixResultId: mixResultId,
      shopProductId: shopProductId,
      result: const TryOnResultModel(id: 1, notes: '', isSaved: false),
    );
  }

  @override
  Future<TryOnRequestDetailModel> getTryOnRequest(int requestId) async {
    final hit = _requestById[requestId];
    if (hit != null) return hit;
    return TryOnRequestDetailModel(
      id: requestId,
      status: 'completed',
      sourceType: 'shop_product',
      personImage: const PersonProfileImageModel(
        id: 1,
        image: '',
        label: '',
        isActive: true,
      ),
      shopProductId: 1,
      result: const TryOnResultModel(id: 1, notes: '', isSaved: true),
    );
  }

  @override
  Future<List<PersonProfileImageModel>> listPersonImages() async =>
      List<PersonProfileImageModel>.from(_personImages);

  @override
  Future<List<TryOnSavedEntryModel>> listSavedTryOnResults() async =>
      List<TryOnSavedEntryModel>.from(_savedResults);

  @override
  Future<bool> toggleTryOnSave(int resultId) async => true;

  @override
  Future<PersonProfileImageModel> uploadPersonImage(
    String filePath, {
    String label = '',
    bool setActive = false,
  }) async {
    final nextId = _personImages.isEmpty ? 1 : _personImages.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1;
    final img = PersonProfileImageModel(
      id: nextId,
      image: filePath,
      label: label,
      isActive: setActive,
    );
    _personImages.add(img);
    return img;
  }
}
