import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/features/profile/data/models/profile_model.dart';
import 'package:frontend/features/profile/presentation/controllers/profile_controller.dart';

import 'support/profile_email_change_test_doubles.dart';

void main() {
  setUp(Get.reset);
  tearDown(() {
    Get.closeAllSnackbars();
    Get.reset();
  });

  ProfileModel baseProfile() => const ProfileModel(
        id: 1,
        email: 'user@example.com',
        pendingEmail: null,
        username: 'Tester',
        phoneNumber: '',
        authProvider: 'email',
        isEmailVerified: true,
        isSeller: false,
        sellerStoreName: '',
        isPremium: false,
        premiumUntil: null,
      );

  Future<void> _flushSnackbars(WidgetTester tester) async {
    Get.closeAllSnackbars();
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));
  }

  Future<ProfileController> pumpProfile(
    WidgetTester tester,
    ProfileEmailMutationFakeDatasource fake,
  ) async {
    await tester.pumpWidget(const GetMaterialApp(home: SizedBox.shrink()));
    await tester.pump();
    final c = ProfileController(datasource: fake);
    Get.put(c);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    return c;
  }

  testWidgets('requestEmailChangeOtp returns false when new email is empty',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.clear();
    expect(await c.requestEmailChangeOtp(), isFalse);
    await _flushSnackbars(tester);
  });

  testWidgets('requestEmailChangeOtp returns false for invalid email format',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.text = 'bukan-email';
    expect(await c.requestEmailChangeOtp(), isFalse);
    await _flushSnackbars(tester);
  });

  testWidgets('requestEmailChangeOtp returns false when new email equals login email',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.text = 'user@example.com';
    expect(await c.requestEmailChangeOtp(), isFalse);
    await _flushSnackbars(tester);
  });

  testWidgets('requestEmailChangeOtp sets pending email on success', (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.text = 'newaddr@example.com';
    expect(await c.requestEmailChangeOtp(), isTrue);
    expect(fake.profile.pendingEmail, 'newaddr@example.com');
    await _flushSnackbars(tester);
  });

  testWidgets('confirmEmailChangeOtp returns false when code is not four digits',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailChangeOtpController.text = '12';
    expect(await c.confirmEmailChangeOtp(), isFalse);
    await _flushSnackbars(tester);
  });

  testWidgets('confirmEmailChangeOtp applies pending email when code is valid',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.text = 'newaddr@example.com';
    await c.requestEmailChangeOtp();
    await _flushSnackbars(tester);
    c.emailChangeOtpController.text = '1234';
    expect(await c.confirmEmailChangeOtp(), isTrue);
    expect(fake.profile.email, 'newaddr@example.com');
    expect(fake.profile.pendingEmail, isNull);
    await _flushSnackbars(tester);
  });

  testWidgets('resendEmailChangeOtp is no-op when there is no pending email',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    expect(await c.resendEmailChangeOtp(), isFalse);
    await _flushSnackbars(tester);
  });

  testWidgets('resendEmailChangeOtp succeeds when pending email exists',
      (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.text = 'pending@example.com';
    await c.requestEmailChangeOtp();
    await _flushSnackbars(tester);
    expect(await c.resendEmailChangeOtp(), isTrue);
    expect(fake.profile.pendingEmail, 'pending@example.com');
    await _flushSnackbars(tester);
  });

  testWidgets('cancelEmailChangeRequest clears pending email', (tester) async {
    final fake = ProfileEmailMutationFakeDatasource(baseProfile());
    final c = await pumpProfile(tester, fake);
    c.emailController.text = 'pending@example.com';
    await c.requestEmailChangeOtp();
    await _flushSnackbars(tester);
    expect(fake.profile.pendingEmail, isNotNull);
    await c.cancelEmailChangeRequest();
    expect(fake.profile.pendingEmail, isNull);
    await _flushSnackbars(tester);
  });
}
