import 'package:frontend/features/shop/data/datasources/shop_remote_datasource.dart';
import 'package:frontend/features/shop/data/models/category_model.dart';
import 'package:frontend/features/shop/data/models/product_detail_model.dart';
import 'package:frontend/features/shop/data/models/product_model.dart';

const ProductModel _wishlistSampleProduct = ProductModel(
  id: 99,
  name: 'Wish Tee',
  slug: 'wish-tee',
  price: 120000,
  categoryName: 'Tops',
  isWishlisted: true,
);

/// Deterministic catalog for shop widget tests (no HTTP).
class ShopWidgetTestDatasource implements ShopDatasource {
  static const sampleProduct = ProductModel(
    id: 1,
    name: 'Widget Test Shirt',
    slug: 'widget-test-shirt',
    price: 150000,
    primaryImage: 'https://example.com/product.jpg',
  );

  @override
  Future<List<CategoryModel>> getCategories() async => const [
        CategoryModel(id: 1, name: 'Tops', slug: 'top'),
      ];

  @override
  Future<List<ProductModel>> getProducts({String? search, String? category}) async =>
      const [sampleProduct];

  @override
  Future<ProductDetailModel> getProductDetail(String slug) async {
    return ProductDetailModel(
      id: sampleProduct.id,
      name: sampleProduct.name,
      slug: slug,
      price: sampleProduct.price,
      primaryImage: sampleProduct.primaryImage,
      description: 'Widget test description',
      images: const [
        ProductImageModel(id: 1, imageUrl: 'https://example.com/a.jpg', isPrimary: true),
      ],
      variants: const [
        ProductVariantModel(id: 10, size: 'M', stock: 3),
      ],
    );
  }

  @override
  Future<List<ProductModel>> getWishlist() async => const [];

  @override
  Future<bool> toggleWishlist(int productId) async => true;
}

/// Wishlist with one line (widget tests).
class ShopWishlistOneItemDatasource extends ShopWidgetTestDatasource {
  @override
  Future<List<ProductModel>> getWishlist() async => const [_wishlistSampleProduct];
}

/// After [toggleWishlist], next [getWishlist] returns empty (removed server-side).
class ShopWishlistToggleClearsDatasource extends ShopWidgetTestDatasource {
  bool _cleared = false;

  @override
  Future<List<ProductModel>> getWishlist() async {
    if (_cleared) return const [];
    return const [_wishlistSampleProduct];
  }

  @override
  Future<bool> toggleWishlist(int productId) async {
    _cleared = true;
    return false;
  }
}
