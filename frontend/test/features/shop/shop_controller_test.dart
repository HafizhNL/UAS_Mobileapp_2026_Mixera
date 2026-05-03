import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/shop/data/datasources/shop_remote_datasource.dart';
import 'package:frontend/features/shop/data/models/category_model.dart';
import 'package:frontend/features/shop/data/models/product_detail_model.dart';
import 'package:frontend/features/shop/data/models/product_model.dart';
import 'package:frontend/features/shop/presentation/controllers/shop_controller.dart';

void main() {
  test('empty search clears results without calling the datasource', () async {
    final datasource = _FakeShopDatasource();
    final controller = ShopController(datasource: datasource);

    controller.searchResults.add(
      const ProductModel(id: 1, name: 'Dress', slug: 'dress', price: 10000),
    );

    await controller.search('   ');

    expect(controller.searchResults, isEmpty);
    expect(datasource.productCalls, 0);
  });

  test('clearRecentSearches removes stored terms', () {
    final controller = ShopController(datasource: _FakeShopDatasource());

    controller.recentSearches.addAll(['dress', 'bag']);
    controller.clearRecentSearches();

    expect(controller.recentSearches, isEmpty);
  });
}

class _FakeShopDatasource implements ShopDatasource {
  int productCalls = 0;

  @override
  Future<List<CategoryModel>> getCategories() async => const [];

  @override
  Future<ProductDetailModel> getProductDetail(String slug) {
    throw UnimplementedError();
  }

  @override
  Future<List<ProductModel>> getProducts({String? search, String? category}) async {
    productCalls++;
    return const [];
  }

  @override
  Future<List<ProductModel>> getWishlist() async => const [];

  @override
  Future<bool> toggleWishlist(int productId) async => false;
}
