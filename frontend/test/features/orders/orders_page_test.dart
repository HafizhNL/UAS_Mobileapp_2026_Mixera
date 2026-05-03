import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/checkout/data/models/order_model.dart';
import 'package:frontend/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:frontend/features/orders/data/models/tracking_model.dart';
import 'package:frontend/features/orders/presentation/controllers/orders_controller.dart';
import 'package:frontend/features/orders/presentation/pages/orders_page.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  Future<void> pumpOrders(WidgetTester tester, OrdersDatasource ds) async {
    Get.put(OrdersController(datasource: ds));
    await tester.pumpWidget(const GetMaterialApp(home: OrdersPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('shows order tile for ongoing order', (tester) async {
    await pumpOrders(tester, _FixedOrdersDatasource(orders: [_sampleOngoing]));

    expect(find.text('Orders'), findsOneWidget);
    expect(find.textContaining('Order #201'), findsOneWidget);
    expect(find.text('Ongoing'), findsOneWidget);
  });

  testWidgets('tab Delivered shows empty state when no delivered orders', (tester) async {
    await pumpOrders(tester, _FixedOrdersDatasource(orders: [_sampleOngoing]));

    await tester.tap(find.text('Delivered'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('No delivered orders'), findsOneWidget);
  });

  testWidgets('empty order list shows ongoing empty state', (tester) async {
    await pumpOrders(tester, _FixedOrdersDatasource(orders: const []));

    expect(find.text('No active orders'), findsOneWidget);
  });

  testWidgets('error state shows message and Try again refetches', (tester) async {
    final ds = _FlakyOrdersDatasource();
    await pumpOrders(tester, ds);

    expect(find.textContaining('offline'), findsOneWidget);

    ds.failNext = false;
    await tester.tap(find.text('Try again'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.textContaining('Order #'), findsOneWidget);
  });
}

const OrderModel _sampleOngoing = OrderModel(
  id: 201,
  status: 'processing',
  subtotal: 10000,
  deliveryFee: 5000,
  discountTotal: 0,
  total: 15000,
  paymentMethod: 'wallet',
  paymentStatus: 'paid',
  createdAt: '2026-05-02',
  items: [],
);

class _FixedOrdersDatasource implements OrdersDatasource {
  _FixedOrdersDatasource({required this.orders});
  final List<OrderModel> orders;

  @override
  Future<List<OrderModel>> getOrders() async => orders;

  @override
  Future<OrderModel> getOrderDetail(int id) async => throw UnimplementedError();

  @override
  Future<TrackingModel> getTracking(int orderId) async => throw UnimplementedError();
}

class _FlakyOrdersDatasource implements OrdersDatasource {
  bool failNext = true;

  @override
  Future<List<OrderModel>> getOrders() async {
    if (failNext) {
      throw Exception('offline');
    }
    return const [_sampleOngoing];
  }

  @override
  Future<OrderModel> getOrderDetail(int id) async => throw UnimplementedError();

  @override
  Future<TrackingModel> getTracking(int orderId) async => throw UnimplementedError();
}
