import 'package:frontend/features/checkout/data/datasources/card_payment_remote_datasource.dart';
import 'package:frontend/features/checkout/data/datasources/checkout_remote_datasource.dart';
import 'package:frontend/features/checkout/data/models/card_charge_result_model.dart';
import 'package:frontend/features/checkout/data/models/checkout_request_model.dart';
import 'package:frontend/features/checkout/data/models/order_model.dart';
import 'package:frontend/features/checkout/data/models/saved_card_model.dart';
import 'package:frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/data/models/address_suggestion_model.dart';
import 'package:frontend/features/profile/data/models/notification_settings_model.dart';
import 'package:frontend/features/profile/data/models/profile_model.dart';
import 'package:frontend/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:frontend/features/wallet/data/models/wallet_model.dart';
import 'package:frontend/features/wallet/data/models/wallet_transaction_model.dart';

/// Profile + addresses for [CheckoutController] / [AddressSelector] (no HTTP).
class ProfileCheckoutWidgetDatasource implements ProfileDatasource {
  @override
  Future<ProfileModel> getProfile() async => const ProfileModel(
        id: 1,
        email: 'checkout@test.example',
        username: 'checkout_tester',
        phoneNumber: '081234567890',
        authProvider: 'email',
        isEmailVerified: true,
        isSeller: false,
        sellerStoreName: '',
        isPremium: false,
        premiumUntil: null,
      );

  @override
  Future<List<AddressModel>> getAddresses() async => const [
        AddressModel(
          id: 100,
          label: 'home',
          recipientName: 'Jane Checkout',
          phoneNumber: '081234567890',
          streetAddress: 'Jl. Contoh 1',
          city: 'Jakarta',
          state: 'DKI',
          postalCode: '12345',
          isPrimary: true,
        ),
      ];

  @override
  Future<ProfileModel> updateProfile({required String username, required String? phoneNumber}) async =>
      throw UnimplementedError();

  @override
  Future<ProfileModel> requestEmailChange(String newEmail) async => throw UnimplementedError();

  @override
  Future<ProfileModel> confirmEmailChange(String code) async => throw UnimplementedError();

  @override
  Future<ProfileModel> cancelEmailChange() async => throw UnimplementedError();

  @override
  Future<void> changePassword({required String currentPassword, required String newPassword}) async =>
      throw UnimplementedError();

  @override
  Future<AddressModel> createAddress({
    required String label,
    required String recipientName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String state,
    required String postalCode,
    required bool isPrimary,
  }) async =>
      throw UnimplementedError();

  @override
  Future<AddressModel> updateAddress({
    required int id,
    required String label,
    required String recipientName,
    required String phoneNumber,
    required String streetAddress,
    required String city,
    required String state,
    required String postalCode,
    required bool isPrimary,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> deleteAddress(int id) async => throw UnimplementedError();

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async => const NotificationSettingsModel(
        orderUpdates: true,
        promotions: true,
        securityAlerts: true,
        dailyReminders: false,
      );

  @override
  Future<NotificationSettingsModel> updateNotificationSettings({
    required bool orderUpdates,
    required bool promotions,
    required bool securityAlerts,
    required bool dailyReminders,
  }) async =>
      throw UnimplementedError();

  @override
  Future<List<AddressSuggestionModel>> searchAddressSuggestions(String query) async => const [];
}

class CheckoutWalletWidgetDatasource implements WalletDatasource {
  @override
  Future<WalletModel> getWallet() async => WalletModel(
        balance: 500000,
        updatedAt: DateTime.utc(2026, 5, 1),
      );

  @override
  Future<List<WalletTransactionModel>> getTransactions() async => const [];
}

class CheckoutCardWidgetDatasource implements CardPaymentDatasource {
  @override
  Future<List<SavedCardModel>> getSavedCards() async => const [];

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
  Future<Map<String, dynamic>> getTransactionStatus(String midtransOrderId) async =>
      throw UnimplementedError();

  @override
  Future<void> setDefaultCard(int id) async => throw UnimplementedError();
}

class CheckoutSuccessDatasource implements CheckoutDatasource {
  @override
  Future<OrderModel> checkout(CheckoutRequestModel request) async => const OrderModel(
        id: 501,
        status: 'processing',
        subtotal: 99000,
        deliveryFee: 20000,
        discountTotal: 0,
        total: 119000,
        paymentMethod: 'wallet',
        paymentStatus: 'paid',
        trackingNumber: '',
        shippingCourier: '',
        createdAt: '2026-05-02',
        items: [],
      );

  @override
  Future<List<OrderModel>> getOrders() async => throw UnimplementedError();
}
