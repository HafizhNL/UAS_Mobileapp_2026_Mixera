import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/checkout/data/models/order_model.dart';
import 'package:frontend/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:frontend/features/orders/data/models/tracking_model.dart';
import 'package:frontend/features/orders/presentation/controllers/orders_controller.dart';
import 'package:frontend/features/orders/presentation/pages/order_detail_page.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('shows order id and status after fetchDetail', (tester) async {
    Get.put<OrdersController>(OrdersController(datasource: _OrderDetailTestDatasource()));

    await tester.pumpWidget(
      const GetMaterialApp(
        home: OrderDetailPage(orderId: 301),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Order Details'), findsOneWidget);
    expect(find.textContaining('Order #301'), findsOneWidget);
    expect(find.text('Payment: paid'), findsOneWidget);
  });
}

const OrderModel _detailOrder = OrderModel(
  id: 301,
  status: 'paid',
  subtotal: 50000,
  deliveryFee: 10000,
  discountTotal: 0,
  total: 60000,
  paymentMethod: 'wallet',
  paymentStatus: 'paid',
  trackingNumber: '',
  shippingCourier: '',
  createdAt: '2026-05-02',
  items: [],
);

class _OrderDetailTestDatasource implements OrdersDatasource {
  @override
  Future<List<OrderModel>> getOrders() async => const [];

  @override
  Future<OrderModel> getOrderDetail(int id) async => _detailOrder;

  @override
  Future<TrackingModel> getTracking(int orderId) async => throw UnimplementedError();
}
