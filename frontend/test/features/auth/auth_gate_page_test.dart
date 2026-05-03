import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:frontend/app/routes/route_names.dart';
import 'package:frontend/core/errors/session_unauthorized_exception.dart';
import 'package:frontend/features/auth/presentation/pages/auth_gate_page.dart';
import 'package:frontend/features/profile/data/models/profile_model.dart';

void main() {
  setUp(Get.reset);
  tearDown(Get.reset);

  ProfileModel buyerProfile() => const ProfileModel(
        id: 1,
        email: 'buyer@example.com',
        pendingEmail: null,
        username: 'buyer',
        phoneNumber: '',
        authProvider: 'email',
        isEmailVerified: true,
        isSeller: false,
        sellerStoreName: '',
        isPremium: false,
        premiumUntil: null,
      );

  ProfileModel sellerProfile() => const ProfileModel(
        id: 2,
        email: 'seller@example.com',
        pendingEmail: null,
        username: 'seller',
        phoneNumber: '',
        authProvider: 'email',
        isEmailVerified: true,
        isSeller: true,
        sellerStoreName: 'Toko Tes',
        isPremium: false,
        premiumUntil: null,
      );

  Future<void> pumpGate(WidgetTester tester, AuthGateOverrides overrides) async {
    await tester.pumpWidget(
      GetMaterialApp(
        routes: {
          RouteNames.login: (_) => const Scaffold(
                body: Center(child: Text('LOGIN_ROUTE')),
              ),
          RouteNames.mainShell: (_) => const Scaffold(
                body: Center(child: Text('MAIN_SHELL')),
              ),
          RouteNames.sellerShell: (_) => const Scaffold(
                body: Center(child: Text('SELLER_SHELL')),
              ),
        },
        home: AuthGatePage(overrides: overrides),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('routes to login when there is no token', (tester) async {
    await pumpGate(
      tester,
      AuthGateOverrides(hasToken: () async => false),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('LOGIN_ROUTE'), findsOneWidget);
  });

  testWidgets('routes to main shell for buyer profile', (tester) async {
    await pumpGate(
      tester,
      AuthGateOverrides(
        hasToken: () async => true,
        ensureBiometricUnlocked: () async => true,
        getProfile: () async => buyerProfile(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('MAIN_SHELL'), findsOneWidget);
  });

  testWidgets('routes to seller shell when profile is seller', (tester) async {
    await pumpGate(
      tester,
      AuthGateOverrides(
        hasToken: () async => true,
        ensureBiometricUnlocked: () async => true,
        getProfile: () async => sellerProfile(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('SELLER_SHELL'), findsOneWidget);
  });

  testWidgets('shows biometric lock when biometric unlock fails', (tester) async {
    await pumpGate(
      tester,
      AuthGateOverrides(
        hasToken: () async => true,
        ensureBiometricUnlocked: () async => false,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Buka dengan sidik jari'), findsOneWidget);
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('shows error and retry when profile load fails', (tester) async {
    await pumpGate(
      tester,
      AuthGateOverrides(
        hasToken: () async => true,
        ensureBiometricUnlocked: () async => true,
        getProfile: () async => throw Exception('network'),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.textContaining('Tidak dapat menghubungi server'),
      findsOneWidget,
    );
    expect(find.text('Coba lagi'), findsOneWidget);
  });

  testWidgets('401 without refresh clears session and opens login', (tester) async {
    await pumpGate(
      tester,
      AuthGateOverrides(
        hasToken: () async => true,
        ensureBiometricUnlocked: () async => true,
        getProfile: () async => throw const SessionUnauthorizedException(),
        tryRefreshSession: () async => false,
        clearAccessTokens: () async {},
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('LOGIN_ROUTE'), findsOneWidget);
  });

  testWidgets('401 with refresh true loads profile on second attempt',
      (tester) async {
    var calls = 0;
    await pumpGate(
      tester,
      AuthGateOverrides(
        hasToken: () async => true,
        ensureBiometricUnlocked: () async => true,
        getProfile: () async {
          calls++;
          if (calls == 1) throw const SessionUnauthorizedException();
          return buyerProfile();
        },
        tryRefreshSession: () async => true,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('MAIN_SHELL'), findsOneWidget);
  });
}
