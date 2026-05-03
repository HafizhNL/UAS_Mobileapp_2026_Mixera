import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:frontend/features/notifications/data/models/notification_item_model.dart';
import 'package:frontend/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:frontend/features/notifications/presentation/pages/notifications_page.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  testWidgets('empty list shows Belum ada notifikasi', (tester) async {
    Get.put(NotificationsController(datasource: _EmptyNotificationsDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: NotificationsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Notifikasi'), findsOneWidget);
    expect(find.text('Belum ada notifikasi'), findsOneWidget);
  });

  testWidgets('unread items show Tandai semua; markAllRead clears action', (tester) async {
    Get.put(NotificationsController(datasource: _TwoUnreadNotificationsDatasource()));
    await tester.pumpWidget(const GetMaterialApp(home: NotificationsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Promo A'), findsOneWidget);
    expect(find.text('Tandai semua'), findsOneWidget);

    await tester.tap(find.text('Tandai semua'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Tandai semua'), findsNothing);
    expect(Get.find<NotificationsController>().unreadCount.value, 0);
  });

  testWidgets('tapping tile triggers markRead', (tester) async {
    final ds = _OneUnreadNotificationsDatasource();
    Get.put(NotificationsController(datasource: ds));
    await tester.pumpWidget(const GetMaterialApp(home: NotificationsPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    await tester.tap(find.text('Order shipped'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(ds.markReadIds, contains(7));
  });
}

class _EmptyNotificationsDatasource implements NotificationsDatasource {
  @override
  Future<List<NotificationItemModel>> getNotifications() async => const [];

  @override
  Future<int> getUnreadCount() async => 0;

  @override
  Future<void> markRead({bool all = false, int? id}) async {}

  @override
  Future<void> registerFcmToken(String token) async {}
}

class _TwoUnreadNotificationsDatasource implements NotificationsDatasource {
  @override
  Future<List<NotificationItemModel>> getNotifications() async => [
        NotificationItemModel(
          id: 1,
          notifType: 'promo',
          title: 'Promo A',
          body: 'Diskon',
          isRead: false,
          payload: {},
          createdAt: _t,
        ),
        NotificationItemModel(
          id: 2,
          notifType: 'system',
          title: 'Promo B',
          body: 'Info',
          isRead: false,
          payload: {},
          createdAt: _t,
        ),
      ];

  @override
  Future<int> getUnreadCount() async => 2;

  @override
  Future<void> markRead({bool all = false, int? id}) async {}

  @override
  Future<void> registerFcmToken(String token) async {}
}

final _t = DateTime(2026, 5, 2);

class _OneUnreadNotificationsDatasource implements NotificationsDatasource {
  final List<int> markReadIds = [];

  @override
  Future<List<NotificationItemModel>> getNotifications() async => [
        NotificationItemModel(
          id: 7,
          notifType: 'order',
          title: 'Order shipped',
          body: 'Paket dikirim',
          isRead: false,
          payload: {},
          createdAt: _t,
        ),
      ];

  @override
  Future<int> getUnreadCount() async => 1;

  @override
  Future<void> markRead({bool all = false, int? id}) async {
    if (id != null) markReadIds.add(id);
  }

  @override
  Future<void> registerFcmToken(String token) async {}
}
