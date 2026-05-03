import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/orders/data/models/order_status_model.dart';

void main() {
  test('OrderTab matches canonical order status groups', () {
    expect(OrderTab.ongoing.matchesStatus('pending'), isTrue);
    expect(OrderTab.ongoing.matchesStatus('shipped'), isTrue);
    expect(OrderTab.ongoing.matchesStatus('delivered'), isFalse);

    expect(OrderTab.delivered.matchesStatus('delivered'), isTrue);
    expect(OrderTab.delivered.matchesStatus('completed'), isTrue);

    expect(OrderTab.cancelled.matchesStatus('canceled'), isTrue);
    expect(OrderTab.cancelled.matchesStatus('cancelled'), isTrue);
  });
}
