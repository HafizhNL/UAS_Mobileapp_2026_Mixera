import 'package:frontend/features/profile/data/models/address_model.dart';
import 'package:frontend/features/profile/data/models/notification_settings_model.dart';
import 'package:frontend/features/profile/data/models/profile_model.dart';

import '../../checkout/support/checkout_widget_test_doubles.dart';

/// [updateProfile] succeeds (Edit Profile save).
class ProfileSaveOkDatasource extends ProfileCheckoutWidgetDatasource {
  @override
  Future<ProfileModel> updateProfile({
    required String username,
    required String? phoneNumber,
  }) async =>
      ProfileModel(
        id: 1,
        email: 'checkout@test.example',
        username: username,
        phoneNumber: phoneNumber,
        authProvider: 'email',
        isEmailVerified: true,
        isSeller: false,
        sellerStoreName: '',
        isPremium: false,
        premiumUntil: null,
      );
}

/// [updateNotificationSettings] echoes args (Notifications page save).
class ProfileNotifySaveOkDatasource extends ProfileCheckoutWidgetDatasource {
  @override
  Future<NotificationSettingsModel> updateNotificationSettings({
    required bool orderUpdates,
    required bool promotions,
    required bool securityAlerts,
    required bool dailyReminders,
  }) async =>
      NotificationSettingsModel(
        orderUpdates: orderUpdates,
        promotions: promotions,
        securityAlerts: securityAlerts,
        dailyReminders: dailyReminders,
      );
}

/// [changePassword] succeeds without API.
class ProfileChangePasswordOkDatasource extends ProfileCheckoutWidgetDatasource {
  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}
}

/// [createAddress] succeeds (Add New Address).
class ProfileCreateAddressOkDatasource extends ProfileCheckoutWidgetDatasource {
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
      AddressModel(
        id: 500,
        label: label,
        recipientName: recipientName,
        phoneNumber: phoneNumber,
        streetAddress: streetAddress,
        city: city,
        state: state,
        postalCode: postalCode,
        isPrimary: isPrimary,
      );
}

/// [updateAddress] succeeds (Edit Address).
class ProfileUpdateAddressOkDatasource extends ProfileCheckoutWidgetDatasource {
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
      AddressModel(
        id: id,
        label: label,
        recipientName: recipientName,
        phoneNumber: phoneNumber,
        streetAddress: streetAddress,
        city: city,
        state: state,
        postalCode: postalCode,
        isPrimary: isPrimary,
      );
}

/// Google-linked account (Security page social copy).
class ProfileGoogleUserDatasource extends ProfileCheckoutWidgetDatasource {
  @override
  Future<ProfileModel> getProfile() async => const ProfileModel(
        id: 2,
        email: 'google-user@example.com',
        username: 'google_user',
        phoneNumber: null,
        authProvider: 'google',
        isEmailVerified: true,
        isSeller: false,
        sellerStoreName: '',
        isPremium: false,
        premiumUntil: null,
      );
}
