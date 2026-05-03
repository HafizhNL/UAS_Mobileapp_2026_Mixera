import 'package:frontend/features/seller/data/datasources/seller_remote_datasource.dart';
import 'package:frontend/features/shop/data/models/product_detail_model.dart';
import 'package:frontend/features/shop/data/models/product_model.dart';

/// Minimal [SellerDatasource] for widget tests (no network). Covers APIs used by
/// [SellerController.refreshAll] and safe defaults for the rest of the interface.
class SellerWidgetTestDatasource implements SellerDatasource {
  static const _sampleProduct = ProductModel(
    id: 1,
    name: 'Widget Produk',
    slug: 'widget-produk',
    price: 10000,
    totalStock: 5,
  );

  static const _sampleDetail = ProductDetailModel(
    id: 1,
    name: 'Widget Produk',
    slug: 'widget-produk',
    price: 10000,
    description: '',
    images: [],
    variants: [],
  );

  @override
  Future<Map<String, dynamic>> getMe() async => {
        'store_name': 'Toko Widget',
        'ship_from_postal_code': '12345',
      };

  @override
  Future<void> patchMe({
    required String storeName,
    required String shipFromPostalCode,
  }) async {}

  @override
  Future<Map<String, dynamic>> getDashboard() async => {
        'unread_notifications': 0,
        'order_count': 3,
        'processing_count': 1,
        'product_count': 2,
        'low_stock_count': 0,
        'available_balance': 100000,
      };

  @override
  Future<List<Map<String, dynamic>>> getFinanceEarnings({
    String? from,
    String? to,
  }) async =>
      [];

  @override
  Future<List<Map<String, dynamic>>> getFinancePayouts() async => [];

  @override
  Future<Map<String, dynamic>> postPayout(int amount) async => {'ok': true};

  @override
  Future<String> downloadEarningsCsv() async => 'date,amount\n';

  @override
  Future<List<Map<String, dynamic>>> getNotifications() async => [];

  @override
  Future<void> markNotificationsRead({bool all = false, int? id}) async {}

  @override
  Future<Map<String, dynamic>> postShippingQuote({
    required int weightGrams,
    String destinationCity = '',
    String destinationPostalCode = '',
  }) async {
    return {'note': 'ok'};
  }

  @override
  Future<List<Map<String, dynamic>>> getChannelListings() async => [];

  @override
  Future<Map<String, dynamic>> postChannelListing({
    required int productId,
    required String channel,
  }) async =>
      {'id': 1};

  @override
  Future<List<ProductModel>> getMyProducts() async => const [];

  @override
  Future<String> uploadProductImage(String filePath) async =>
      'https://example.com/img.png';

  @override
  Future<ProductModel> createProduct({
    required String name,
    required int price,
    String description = '',
    int? discountPrice,
    String color = '',
    int stock = 0,
    String size = 'M',
    String imageUrl = '',
    List<Map<String, dynamic>>? variants,
  }) async =>
      ProductModel(
        id: 999,
        name: name,
        slug: 'new',
        price: price,
        discountPrice: discountPrice,
        color: color,
        totalStock: stock,
        primaryImage: imageUrl.isEmpty ? null : imageUrl,
      );

  @override
  Future<ProductDetailModel> getSellerProduct(int id) async => _sampleDetail;

  @override
  Future<ProductModel> patchProduct(
    int id, {
    String? name,
    int? price,
    int? discountPrice,
    bool clearDiscountPrice = false,
    String? description,
    String? color,
    int? stock,
    bool? isActive,
    String? imageUrl,
    List<Map<String, int>>? variantStocks,
    List<Map<String, dynamic>>? variantsAdd,
  }) async =>
      ProductModel(
        id: id,
        name: name ?? _sampleProduct.name,
        slug: _sampleProduct.slug,
        price: price ?? _sampleProduct.price,
        discountPrice: clearDiscountPrice ? null : discountPrice,
        color: color ?? _sampleProduct.color,
        totalStock: stock ?? _sampleProduct.totalStock,
        primaryImage: imageUrl ?? _sampleProduct.primaryImage,
        isActive: isActive ?? _sampleProduct.isActive,
      );

  @override
  Future<List<Map<String, dynamic>>> getOrders({String? status}) async => [];

  @override
  Future<Map<String, dynamic>> getOrder(int id) async => {
        'id': id,
        'status': 'processing',
        'payment_status': 'paid',
        'tracking_number': '',
        'shipping_courier': '',
        'address_snapshot': {
          'recipient_name': 'Pembeli Tes',
          'phone_number': '081234567890',
          'street_address': 'Jl. Contoh 10',
          'city': 'Jakarta',
          'state': 'DKI',
          'postal_code': '12345',
        },
        'items': [
          {
            'product_name': 'Kaos Widget',
            'variant_size': 'M',
            'quantity': 1,
            'unit_price': 50000,
            'line_total': 50000,
          },
        ],
      };

  @override
  Future<Map<String, dynamic>> updateOrderShipping(
    int id, {
    String? trackingNumber,
    String? shippingCourier,
    String? status,
  }) async =>
      {'id': id, 'status': status ?? 'pending'};
}
