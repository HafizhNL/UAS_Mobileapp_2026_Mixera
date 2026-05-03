import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:frontend/features/checkout/data/datasources/card_payment_remote_datasource.dart';
import 'package:frontend/features/checkout/data/models/card_charge_result_model.dart';
import 'package:frontend/features/checkout/data/models/saved_card_model.dart';
import 'package:frontend/features/wallet/data/datasources/wallet_remote_datasource.dart';
import 'package:frontend/features/wallet/data/models/wallet_model.dart';
import 'package:frontend/features/wallet/data/models/wallet_transaction_model.dart';
import 'package:frontend/features/wallet/presentation/controllers/wallet_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  group('WalletController', () {
    test('onInit loads wallet, transactions, and saved cards from fakes', () async {
      final wallet = WalletModel(
        balance: 250000,
        updatedAt: DateTime.utc(2026, 5, 1),
      );
      final txs = [
        WalletTransactionModel(
          id: 1,
          type: 'top_up',
          amount: 50000,
          reference: 'r1',
          description: 'Top up',
          createdAt: DateTime.utc(2026, 5, 1),
        ),
      ];
      const cards = [
        SavedCardModel(
          id: 9,
          cardBrand: 'visa',
          maskedCard: '1111',
          expiryMonth: '12',
          expiryYear: '2030',
          isDefault: true,
        ),
      ];

      Get.put(
        WalletController(
          walletDatasource: _FakeWalletDatasource(wallet: wallet, transactions: txs),
          cardPaymentDatasource: _FakeCardPaymentDatasource(savedCards: cards),
        ),
      );

      await _drainWalletLoads();

      final c = Get.find<WalletController>();
      expect(c.wallet.value?.balance, 250000);
      expect(c.transactions, hasLength(1));
      expect(c.transactions.single.isTopUp, isTrue);
      expect(c.savedCards.single.id, 9);
      expect(c.isLoadingWallet.value, isFalse);
      expect(c.isLoadingTransactions.value, isFalse);
      expect(c.isLoadingCards.value, isFalse);
    });

    test('pollStatus returns transaction_status from datasource', () async {
      Get.put(
        WalletController(
          walletDatasource: _FakeWalletDatasource(
            wallet: WalletModel(balance: 0, updatedAt: DateTime.utc(2026)),
            transactions: <WalletTransactionModel>[],
          ),
          cardPaymentDatasource: _FakeCardPaymentDatasource(
            savedCards: const [],
            statusPayload: {'transaction_status': 'settlement'},
          ),
        ),
      );
      await _drainWalletLoads();

      final c = Get.find<WalletController>();
      final status = await c.pollStatus('order-1');
      expect(status, 'settlement');
    });

    test('pollStatus returns pending when status call throws', () async {
      Get.put(
        WalletController(
          walletDatasource: _FakeWalletDatasource(
            wallet: WalletModel(balance: 0, updatedAt: DateTime.utc(2026)),
            transactions: <WalletTransactionModel>[],
          ),
          cardPaymentDatasource: _FakeCardPaymentDatasource(
            savedCards: const [],
            throwOnStatus: true,
          ),
        ),
      );
      await _drainWalletLoads();

      final c = Get.find<WalletController>();
      expect(await c.pollStatus('x'), 'pending');
    });
  });
}

Future<void> _drainWalletLoads() async {
  for (var i = 0; i < 30; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

class _FakeWalletDatasource implements WalletDatasource {
  _FakeWalletDatasource({required this.wallet, required this.transactions});

  final WalletModel wallet;
  final List<WalletTransactionModel> transactions;

  @override
  Future<WalletModel> getWallet() async => wallet;

  @override
  Future<List<WalletTransactionModel>> getTransactions() async => transactions;
}

class _FakeCardPaymentDatasource implements CardPaymentDatasource {
  _FakeCardPaymentDatasource({
    required this.savedCards,
    this.statusPayload,
    this.throwOnStatus = false,
  });

  final List<SavedCardModel> savedCards;
  final Map<String, dynamic>? statusPayload;
  final bool throwOnStatus;

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
  Future<List<SavedCardModel>> getSavedCards() async => savedCards;

  @override
  Future<Map<String, dynamic>> getTransactionStatus(String midtransOrderId) async {
    if (throwOnStatus) throw Exception('network');
    return statusPayload ?? {'transaction_status': 'pending'};
  }

  @override
  Future<void> setDefaultCard(int id) async => throw UnimplementedError();
}
