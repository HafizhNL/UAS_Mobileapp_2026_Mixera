import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/notifications/data/models/notification_item_model.dart';

void main() {
  group('NotificationItemModel.fromJson', () {
    test('parses core fields and payload map', () {
      final m = NotificationItemModel.fromJson({
        'id': 42,
        'notif_type': 'order',
        'title': 'Shipped',
        'body': 'Your order is on the way.',
        'is_read': true,
        'payload': {'order_id': 7},
        'created_at': '2026-05-01T10:00:00.000Z',
      });

      expect(m.id, 42);
      expect(m.notifType, 'order');
      expect(m.title, 'Shipped');
      expect(m.body, 'Your order is on the way.');
      expect(m.isRead, isTrue);
      expect(m.payload, {'order_id': 7});
      expect(m.createdAt.toUtc().year, 2026);
    });

    test('defaults notif_type, is_read, and empty payload', () {
      final m = NotificationItemModel.fromJson({
        'id': 1,
        'title': 'T',
        'body': 'B',
        'created_at': '2026-01-01T00:00:00.000Z',
      });

      expect(m.notifType, 'system');
      expect(m.isRead, isFalse);
      expect(m.payload, isEmpty);
    });
  });

  group('NotificationItemModel.copyWith', () {
    test('updates is_read', () {
      final a = NotificationItemModel.fromJson({
        'id': 1,
        'title': 'T',
        'body': 'B',
        'is_read': false,
        'created_at': '2026-01-01T00:00:00.000Z',
      });
      final b = a.copyWith(isRead: true);
      expect(b.isRead, isTrue);
      expect(b.id, a.id);
    });
  });
}
