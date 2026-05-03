import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:frontend/features/cart/data/models/cart_item_model.dart';
import 'package:frontend/features/cart/data/models/cart_summary_model.dart';
import 'package:frontend/features/checkout/data/datasources/card_payment_remote_datasource.dart';
import 'package:frontend/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:frontend/features/checkout/data/models/card_charge_result_model.dart';
import 'package:frontend/features/checkout/data/models/checkout_request_model.dart';
import 'package:frontend/features/checkout/data/models/order_model.dart';
import 'package:frontend/features/checkout/data/models/saved_card_model.dart';
import 'package:frontend/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:frontend/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:frontend/features/wallet/data/models/wallet_model.dart';
import 'package:frontend/features/wallet/data/models/wallet_transaction_model.dart';

void main() {
  test('selectShippingQuote stores selected quote index and delivery fee', () {
    final controller = CheckoutController(
      checkoutDatasource: _FakeCheckoutDatasource(),
      cardPaymentDatasource: _FakeCardPaymentDatasource(),
      cartDatasource: _FakeCartForCheckout(),
      walletDatasource: _FakeWalletForCheckout(),
    );

    controller.shippingQuotes.assignAll([
      {'service': 'regular', 'price': 18000},
      {'service': 'express', 'price': 32000},
    ]);

    controller.selectShippingQuote(1);

    expect(controller.selectedShippingQuoteIndex.value, 1);
    expect(controller.selectedDeliveryFee.value, 32000);

    controller.selectShippingQuote(null);

    expect(controller.selectedShippingQuoteIndex.value, isNull);
    expect(controller.selectedDeliveryFee.value, isNull);
  });
}

class _FakeCheckoutDatasource implements CheckoutDatasource {
  @override
  Future<OrderModel> checkout(CheckoutRequestModel request) async => throw UnimplementedError();

  @override
  Future<List<OrderModel>> getOrders() async => throw UnimplementedError();
}

class _FakeCardPaymentDatasource implements CardPaymentDatasource {
  @override
  Future<CardChargeResultModel> chargeCard({
    required int orderId,
    String cardToken = '',
    int? savedCardId,
    bool saveCard = false,
    bool retryThreeDs = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<CardChargeResultModel> chargeWalletTopUp({
    required int amount,
    String cardToken = '',
    int? savedCardId,
    bool saveCard = false,
    bool retryThreeDs = false,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteCard(int id) async => throw UnimplementedError();

  @override
  Future<List<SavedCardModel>> getSavedCards() async => const [];

  @override
  Future<Map<String, dynamic>> getTransactionStatus(String midtransOrderId) async =>
      throw UnimplementedError();

  @override
  Future<void> setDefaultCard(int id) async => throw UnimplementedError();
}

class _FakeCartForCheckout implements CartDatasource {
  @override
  Future<CartItemModel> addItem(int variantId, int quantity) async => throw UnimplementedError();

  @override
  Future<void> clearCart() async => throw UnimplementedError();

  @override
  Future<CartSummaryModel> getCart() async => throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> postShippingQuote({
    int? addressId,
    String? destinationPostalCode,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> removeItem(int id) async => throw UnimplementedError();

  @override
  Future<CartItemModel> updateItem(int id, int quantity) async => throw UnimplementedError();
}

class _FakeWalletForCheckout implements WalletDatasource {
  @override
  Future<WalletModel> getWallet() async => WalletModel(
        balance: 0,
        updatedAt: DateTime.utc(2026),
      );

  @override
  Future<List<WalletTransactionModel>> getTransactions() async => const [];
}
