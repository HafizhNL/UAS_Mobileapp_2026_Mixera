import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/seller/presentation/controllers/seller_controller.dart';

import 'support/seller_widget_test_doubles.dart';

void main() {
  tearDown(Get.reset);

  test('loadMe populates store profile from datasource', () async {
    final c = SellerController(datasource: SellerWidgetTestDatasource());
    await c.loadMe();
    expect(c.storeName.value, 'Toko Widget');
    expect(c.shipFromPostalCode.value, '12345');
  });

  test('loadDashboard sets dashboard map', () async {
    final c = SellerController(datasource: SellerWidgetTestDatasource());
    await c.loadDashboard();
    expect(c.dashboard.value?['order_count'], 3);
    expect(c.dashboard.value?['available_balance'], 100000);
  });

  test('loadProducts assigns list from datasource', () async {
    final c = SellerController(datasource: SellerWidgetTestDatasource());
    await c.loadProducts();
    expect(c.products, isEmpty);
  });

  test('loadChartData builds eight weekly buckets when earnings list is empty',
      () async {
    final c = SellerController(datasource: SellerWidgetTestDatasource());
    await c.loadChartData();
    expect(c.weeklyEarnings.length, 8);
    for (final row in c.weeklyEarnings) {
      expect(row.containsKey('label'), isTrue);
      expect(row.containsKey('amount'), isTrue);
    }
  });
}
