import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'package:frontend/features/notifications/data/models/notification_item_model.dart';
import 'package:frontend/features/notifications/presentation/controllers/notifications_controller.dart';

void main() {
  tearDown(Get.reset);

  NotificationItemModel n({required int id, required bool isRead}) {
    return NotificationItemModel(
      id: id,
      notifType: 'system',
      title: 'Title $id',
      body: 'Body $id',
      isRead: isRead,
      payload: const {},
      createdAt: DateTime(2026, 1, id),
    );
  }

  test('loadNotifications assigns list and recomputes unreadCount', () async {
    final ds = _ConfigurableNotificationsDatasource(
      notifications: [n(id: 1, isRead: false), n(id: 2, isRead: true)],
      unreadCount: 99,
    );
    final controller = NotificationsController(datasource: ds);

    await controller.loadNotifications();

    expect(controller.notifications.length, 2);
    expect(controller.unreadCount.value, 1);
    expect(controller.isLoading.value, isFalse);
  });

  test('refreshUnreadCount sets unread from datasource', () async {
    final ds = _ConfigurableNotificationsDatasource(unreadCount: 7);
    final controller = NotificationsController(datasource: ds);

    await controller.refreshUnreadCount();

    expect(controller.unreadCount.value, 7);
  });

  test('markRead updates matching row and decrements unreadCount', () async {
    final ds = _ConfigurableNotificationsDatasource();
    final controller = NotificationsController(datasource: ds);

    controller.notifications.assignAll([n(id: 1, isRead: false), n(id: 2, isRead: false)]);
    controller.unreadCount.value = 2;

    await controller.markRead(1);

    expect(controller.notifications.firstWhere((e) => e.id == 1).isRead, isTrue);
    expect(controller.unreadCount.value, 1);
  });

  test('markAllRead updates local unread state after datasource success', () async {
    final controller = NotificationsController(datasource: _ConfigurableNotificationsDatasource());
    controller.notifications.assignAll([
      n(id: 1, isRead: false),
      n(id: 2, isRead: false),
    ]);
    controller.unreadCount.value = 2;

    await controller.markAllRead();

    expect(controller.unreadCount.value, 0);
    expect(controller.notifications.every((item) => item.isRead), isTrue);
  });

  test('registerFcmToken completes when datasource succeeds', () async {
    final ds = _ConfigurableNotificationsDatasource();
    final controller = NotificationsController(datasource: ds);

    await controller.registerFcmToken('test-fcm-token');

    expect(ds.lastRegisteredToken, 'test-fcm-token');
  });
}

class _ConfigurableNotificationsDatasource implements NotificationsDatasource {
  _ConfigurableNotificationsDatasource({
    List<NotificationItemModel>? notifications,
    this.unreadCount = 0,
  }) : _notifications = notifications ?? const [];

  final List<NotificationItemModel> _notifications;
  final int unreadCount;
  String? lastRegisteredToken;

  @override
  Future<List<NotificationItemModel>> getNotifications() async =>
      List<NotificationItemModel>.from(_notifications);

  @override
  Future<int> getUnreadCount() async => unreadCount;

  @override
  Future<void> markRead({bool all = false, int? id}) async {}

  @override
  Future<void> registerFcmToken(String token) async {
    lastRegisteredToken = token;
  }
}
