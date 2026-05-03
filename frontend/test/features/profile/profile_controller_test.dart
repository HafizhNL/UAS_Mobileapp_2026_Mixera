import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/data/models/address_suggestion_model.dart';
import 'package:frontend/features/profile/data/models/notification_settings_model.dart';
import 'package:frontend/features/profile/data/models/profile_model.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';

void main() {
  test('fillAddressForm and clearAddressForm update address fields', () {
    final controller = ProfileController(datasource: _FakeProfileDatasource());
    addTearDown(controller.onClose);

    controller.fillAddressForm(
      const AddressModel(
        id: 1,
        label: 'work',
        recipientName: 'Mira',
        phoneNumber: '08123456789',
        streetAddress: 'Jl. Melati 1',
        city: 'Bandung',
        state: 'Jawa Barat',
        postalCode: '40123',
        isPrimary: true,
      ),
    );

    expect(controller.recipientNameController.text, 'Mira');
    expect(controller.selectedAddressLabel.value, 'work');
    expect(controller.isPrimaryAddress.value, isTrue);

    controller.clearAddressForm();

    expect(controller.recipientNameController.text, isEmpty);
    expect(controller.selectedAddressLabel.value, 'home');
    expect(controller.isPrimaryAddress.value, isFalse);
  });
}

class _FakeProfileDatasource implements ProfileDatasource {
  @override
  Future<ProfileModel> cancelEmailChange() async => throw UnimplementedError();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async =>
      throw UnimplementedError();

  @override
  Future<ProfileModel> confirmEmailChange(String code) async => throw UnimplementedError();

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
  Future<void> deleteAddress(int id) async => throw UnimplementedError();

  @override
  Future<List<AddressModel>> getAddresses() async => throw UnimplementedError();

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async =>
      throw UnimplementedError();

  @override
  Future<ProfileModel> getProfile() async => throw UnimplementedError();

  @override
  Future<ProfileModel> requestEmailChange(String newEmail) async => throw UnimplementedError();

  @override
  Future<List<AddressSuggestionModel>> searchAddressSuggestions(String query) async =>
      throw UnimplementedError();

  @override
  Future<ProfileModel> updateProfile({
    required String username,
    required String? phoneNumber,
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
  Future<NotificationSettingsModel> updateNotificationSettings({
    required bool orderUpdates,
    required bool promotions,
    required bool securityAlerts,
    required bool dailyReminders,
  }) async =>
      throw UnimplementedError();
}
