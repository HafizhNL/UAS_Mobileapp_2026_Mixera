import 'package:frontend/features/mix_match/data/models/mix_match_api_models.dart';
import 'package:frontend/features/wardrobe/data/models/wardrobe_api_models.dart';

import '../../wardrobe/support/wardrobe_widget_test_doubles.dart';

/// Sample top for spotlight + picker (`getWardrobeItems` with/without category).
const kMixTestTopItem = WardrobeItemApiModel(
  id: 101,
  category: 'top',
  subcategory: 'tee',
  color: 'Navy',
  styleTags: [],
  image: 'https://example.com/mix-top.jpg',
  name: 'Mix Picker Top',
  notes: '',
);

const kMixTestBottomItem = WardrobeItemApiModel(
  id: 102,
  category: 'bottom',
  subcategory: 'jeans',
  color: 'Blue',
  styleTags: [],
  image: 'https://example.com/mix-bottom.jpg',
  name: 'Mix Picker Jeans',
  notes: '',
);

/// Wardrobe items for Mix spotlight (no category) and per-tab picker loads.
class MixMatchSpotlightWardrobeDatasource extends WardrobeWidgetTestDatasource {
  @override
  Future<List<WardrobeItemApiModel>> getWardrobeItems({String? category}) async {
    if (category == null || category.isEmpty) {
      return const [kMixTestTopItem];
    }
    if (category == 'top') return const [kMixTestTopItem];
    if (category == 'bottom') return const [kMixTestBottomItem];
    return const [];
  }
}

/// Enables [MixMatchController.startNewSession] and [submitSelection] in widget tests.
class MixMatchSessionTestDatasource extends MixMatchWidgetTestDatasource {
  @override
  Future<MixSessionModel> createSession() async => const MixSessionModel(
        id: 42,
        status: 'selecting',
        selectedItems: [],
      );

  @override
  Future<MixSessionModel> selectItems(int sessionId, List<int> itemIds) async {
    final items = <WardrobeItemApiModel>[];
    for (final id in itemIds) {
      if (id == kMixTestTopItem.id) items.add(kMixTestTopItem);
      if (id == kMixTestBottomItem.id) items.add(kMixTestBottomItem);
    }
    return MixSessionModel(
      id: sessionId,
      status: 'confirmed',
      selectedItems: items,
    );
  }
}

/// Non-empty saved outfits list for [SavedOutfitsPage].
class MixMatchSavedOutfitsTestDatasource extends MixMatchWidgetTestDatasource {
  @override
  Future<List<MixResultDetailModel>> listSavedMixResults() async => [
        MixResultDetailModel(
          id: 7,
          styleLabel: 'Saved Test Look',
          explanation: 'Great combo',
          tips: '',
          score: 91,
          isSaved: true,
          previewImage: 'https://example.com/saved-mix.jpg',
          createdAt: DateTime(2026, 3, 10),
          selectedItems: const [kMixTestTopItem],
        ),
      ];

  @override
  Future<bool> toggleSaveResult(int resultId) async => false;
}
