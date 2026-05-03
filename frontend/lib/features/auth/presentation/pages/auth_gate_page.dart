import 'package:flutter/material.dart';

import '../../../../app/routes/route_names.dart';
import '../../../../core/auth/token_refresh_helper.dart';
import '../../../../core/biometric/app_biometric_auth.dart';
import '../../../../core/biometric/biometric_lock_storage.dart';
import '../../../../core/errors/session_unauthorized_exception.dart';
import '../../../../core/storage/token_storage.dart';
import '../../../profile/data/datasources/profile_remote_datasource.dart';
import '../../../profile/data/models/profile_model.dart';

/// Optional dependencies for [AuthGatePage] (widget / integration tests).
/// Any callback left null uses the normal production implementation.
class AuthGateOverrides {
  const AuthGateOverrides({
    this.hasToken,
    this.ensureBiometricUnlocked,
    this.getProfile,
    this.tryRefreshSession,
    this.clearAccessTokens,
  });

  final Future<bool> Function()? hasToken;
  final Future<bool> Function()? ensureBiometricUnlocked;
  final Future<ProfileModel> Function()? getProfile;
  final Future<bool> Function()? tryRefreshSession;
  final Future<void> Function()? clearAccessTokens;
}

class AuthGatePage extends StatefulWidget {
  const AuthGatePage({super.key, this.overrides});

  /// Non-null in tests; production uses `const AuthGatePage()`.
  final AuthGateOverrides? overrides;

  @override
  State<AuthGatePage> createState() => _AuthGatePageState();
}

class _AuthGatePageState extends State<AuthGatePage> {
  String? _error;
  bool _biometricLocked = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  void _routeBySeller(ProfileModel profile) {
    if (profile.isSeller) {
      Navigator.pushReplacementNamed(context, RouteNames.sellerShell);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.mainShell);
    }
  }

  Future<bool> _readHasToken() async {
    final o = widget.overrides?.hasToken;
    if (o != null) return o();
    return TokenStorage.hasToken();
  }

  Future<ProfileModel> _fetchProfile() async {
    final o = widget.overrides?.getProfile;
    if (o != null) return o();
    return ProfileRemoteDatasource().getProfile();
  }

  Future<bool> _tryRefreshSession() async {
    final o = widget.overrides?.tryRefreshSession;
    if (o != null) return o();
    return TokenRefreshHelper.tryRefresh();
  }

  Future<void> _clearAccessTokens() async {
    final o = widget.overrides?.clearAccessTokens;
    if (o != null) {
      await o();
      return;
    }
    await TokenStorage.clearTokens();
  }

  Future<bool> _ensureBiometricUnlocked() async {
    final o = widget.overrides?.ensureBiometricUnlocked;
    if (o != null) return o();
    if (!await BiometricLockStorage.isLockEnabled()) return true;
    return AppBiometricAuth.instance.authenticateToUnlock();
  }

  Future<void> _loadProfileAndRoute() async {
    try {
      final profile = await _fetchProfile();
      if (!mounted) return;
      _routeBySeller(profile);
    } on SessionUnauthorizedException {
      final refreshed = await _tryRefreshSession();
      if (!mounted) return;
      if (refreshed) {
        try {
          final profile = await _fetchProfile();
          if (!mounted) return;
          _routeBySeller(profile);
          return;
        } on SessionUnauthorizedException {
          // fall through: clear session and go to login
        } catch (_) {
          if (!mounted) return;
          setState(() {
            _loading = false;
            _error =
                'Tidak dapat memuat profil setelah memperbarui sesi. Coba lagi.';
          });
          return;
        }
      }
      await _clearAccessTokens();
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.login);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error =
            'Tidak dapat menghubungi server atau profil gagal dimuat. Periksa koneksi lalu coba lagi.';
      });
    }
  }

  Future<void> _checkAuth() async {
    setState(() {
      _error = null;
      _biometricLocked = false;
      _loading = true;
    });

    final hasToken = await _readHasToken();

    if (!mounted) return;

    if (!hasToken) {
      Navigator.pushReplacementNamed(context, RouteNames.login);
      return;
    }

    if (!await _ensureBiometricUnlocked()) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _biometricLocked = true;
      });
      return;
    }

    await _loadProfileAndRoute();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _retryBiometric() async {
    setState(() => _loading = true);
    if (!await _ensureBiometricUnlocked()) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }
    if (!mounted) return;
    setState(() {
      _biometricLocked = false;
      _loading = true;
    });
    await _loadProfileAndRoute();
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _exitBiometricLock() async {
    await _clearAccessTokens();
    await BiometricLockStorage.setLockEnabled(false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, RouteNames.login);
  }

  @override
  Widget build(BuildContext context) {
    if (_biometricLocked) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.fingerprint, size: 56),
                  const SizedBox(height: 16),
                  Text(
                    'Buka dengan sidik jari',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Autentikasi dibatalkan atau gagal. Coba lagi atau keluar untuk login dengan akun lain.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _loading ? null : _retryBiometric,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Coba lagi'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _loading ? null : _exitBiometricLock,
                    child: const Text('Keluar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _checkAuth,
                    child: const Text('Coba lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
