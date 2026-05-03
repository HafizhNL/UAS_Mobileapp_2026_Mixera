import 'package:frontend/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/data/models/address_suggestion_model.dart';
import 'package:frontend/features/profile/data/models/notification_settings_model.dart';
import 'package:frontend/features/profile/data/models/profile_model.dart';

/// Mutable profile + email-change endpoints for widget / flow tests (no network).
class ProfileEmailMutationFakeDatasource implements ProfileDatasource {
  ProfileEmailMutationFakeDatasource(this._profile);

  ProfileModel _profile;

  ProfileModel get profile => _profile;

  @override
  Future<ProfileModel> getProfile() async => _profile;

  @override
  Future<List<AddressModel>> getAddresses() async => const [];

  @override
  Future<ProfileModel> requestEmailChange(String newEmail) async {
    _profile = _profile.copyWith(pendingEmail: newEmail);
    return _profile;
  }

  @override
  Future<ProfileModel> confirmEmailChange(String code) async {
    if (code != '1234') {
      throw Exception('Kode OTP tidak valid.');
    }
    final pending = _profile.pendingEmail;
    if (pending == null) throw Exception('Tidak ada permintaan ubah email.');
    _profile = ProfileModel(
      id: _profile.id,
      email: pending,
      pendingEmail: null,
      username: _profile.username,
      phoneNumber: _profile.phoneNumber,
      authProvider: _profile.authProvider,
      isEmailVerified: _profile.isEmailVerified,
      isSeller: _profile.isSeller,
      sellerStoreName: _profile.sellerStoreName,
      isPremium: _profile.isPremium,
      premiumUntil: _profile.premiumUntil,
    );
    return _profile;
  }

  @override
  Future<ProfileModel> cancelEmailChange() async {
    _profile = ProfileModel(
      id: _profile.id,
      email: _profile.email,
      pendingEmail: null,
      username: _profile.username,
      phoneNumber: _profile.phoneNumber,
      authProvider: _profile.authProvider,
      isEmailVerified: _profile.isEmailVerified,
      isSeller: _profile.isSeller,
      sellerStoreName: _profile.sellerStoreName,
      isPremium: _profile.isPremium,
      premiumUntil: _profile.premiumUntil,
    );
    return _profile;
  }

  @override
  Future<ProfileModel> updateProfile({
    required String username,
    required String? phoneNumber,
  }) async =>
      throw UnimplementedError();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async =>
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
  Future<void> deleteAddress(int id) async => throw UnimplementedError();

  @override
  Future<NotificationSettingsModel> getNotificationSettings() async =>
      const NotificationSettingsModel(
        orderUpdates: true,
        promotions: true,
        securityAlerts: false,
        dailyReminders: false,
      );

  @override
  Future<List<AddressSuggestionModel>> searchAddressSuggestions(String query) async =>
      const [];

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
