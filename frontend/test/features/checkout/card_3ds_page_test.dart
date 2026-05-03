import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/checkout/presentation/pages/card_3ds_page.dart';

void main() {
  test('Card3DSArgs exposes redirect URL and Midtrans order id', () {
    const args = Card3DSArgs(
      redirectUrl: 'https://example.com/acs',
      midtransOrderId: 'order-123',
    );
    expect(args.redirectUrl, 'https://example.com/acs');
    expect(args.midtransOrderId, 'order-123');
  });

  test('Card3DSResult includes staleRedirect for expired 3DS session', () {
    expect(Card3DSResult.values, contains(Card3DSResult.staleRedirect));
    expect(Card3DSResult.values, contains(Card3DSResult.success));
    expect(Card3DSResult.values, contains(Card3DSResult.cancelled));
  });
}
