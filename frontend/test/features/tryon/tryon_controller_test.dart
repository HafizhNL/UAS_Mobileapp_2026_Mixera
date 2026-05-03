import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/tryon/data/datasources/tryon_remote_datasource.dart';
import 'package:frontend/features/tryon/data/models/tryon_api_models.dart';
import 'package:frontend/features/tryon/presentation/controllers/tryon_controller.dart';

void main() {
  test('busy getters follow generation state', () {
    final controller = TryOnController(datasource: _FakeTryOnDatasource());

    expect(controller.isBusy, isFalse);

    controller.genState.value = TryOnGenState.submitting;
    expect(controller.isSubmitting, isTrue);
    expect(controller.isBusy, isTrue);

    controller.genState.value = TryOnGenState.polling;
    expect(controller.isPolling, isTrue);
    expect(controller.isBusy, isTrue);

    controller.genState.value = TryOnGenState.done;
    expect(controller.isBusy, isFalse);
  });
}

class _FakeTryOnDatasource implements TryOnDatasource {
  @override
  Future<void> archivePersonImage(int imageId) async => throw UnimplementedError();

  @override
  Future<PersonProfileImageModel> activatePersonImage(int imageId) async =>
      throw UnimplementedError();

  @override
  Future<TryOnRequestDetailModel> createTryOnRequest({
    required int personImageId,
    required TryOnSourceKind sourceType,
    int? mixResultId,
    int? shopProductId,
  }) async =>
      throw UnimplementedError();

  @override
  Future<TryOnRequestDetailModel> getTryOnRequest(int requestId) async =>
      throw UnimplementedError();

  @override
  Future<List<PersonProfileImageModel>> listPersonImages() async => throw UnimplementedError();

  @override
  Future<List<TryOnSavedEntryModel>> listSavedTryOnResults() async => throw UnimplementedError();

  @override
  Future<bool> toggleTryOnSave(int resultId) async => throw UnimplementedError();

  @override
  Future<PersonProfileImageModel> uploadPersonImage(
    String filePath, {
    String label = '',
    bool setActive = false,
  }) async =>
      throw UnimplementedError();
}

