import 'package:frontend/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:frontend/features/auth/presentation/controllers/auth_controller.dart';

/// Login succeeds with tokens (no HTTP). Pair with [AuthController.persistLoginTokens]
/// no-op in tests to avoid secure storage.
class FakeAuthLoginOkDatasource extends FakeAuthDatasource {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async => {
        'access': 'test-access-token',
        'refresh': 'test-refresh-token',
        'user': <String, dynamic>{'is_seller': false},
      };
}

/// Fake [AuthDatasource] for widget tests that only hit validation paths (no HTTP).
class FakeAuthDatasource implements AuthDatasource {
  @override
  Future<Map<String, dynamic>> login(String email, String password) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> register(
    String email,
    String username,
    String phone,
    String password,
  ) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> verifyOtp(String email, String code) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> loginWithGoogle(String idToken) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> refreshTokens({required String refresh}) async =>
      throw UnimplementedError();

  @override
  Future<Map<String, dynamic>> loginWithFacebook(String accessToken) async =>
      throw UnimplementedError();
}

/// Register succeeds without HTTP (widget tests).
class FakeAuthRegisterOkDatasource extends FakeAuthDatasource {
  @override
  Future<Map<String, dynamic>> register(
    String email,
    String username,
    String phone,
    String password,
  ) async =>
      <String, dynamic>{};
}

/// Forgot-password request succeeds without HTTP (widget tests).
class FakeAuthForgotOkDatasource extends FakeAuthDatasource {
  @override
  Future<Map<String, dynamic>> forgotPassword(String email) async =>
      <String, dynamic>{};
}

/// OTP verify + password reset succeed without HTTP (widget tests).
class FakeAuthOtpVerifyResetOkDatasource extends FakeAuthDatasource {
  @override
  Future<Map<String, dynamic>> verifyOtp(String email, String code) async => const {};

  @override
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String code,
    required String newPassword,
    required String confirmPassword,
  }) async =>
      const {};
}

/// Skips [AuthController.onInit] Google pre-init so widget tests do not need dotenv / platform.
class AuthControllerForWidgetTest extends AuthController {
  AuthControllerForWidgetTest({
    AuthDatasource? datasource,
    LoginTokensPersistence? persistLoginTokens,
  }) : super(
          datasource: datasource ?? FakeAuthDatasource(),
          persistLoginTokens: persistLoginTokens,
        );

  @override
  // Skip [AuthController.onInit] (Google Sign-In + dotenv); widget tests only need form actions.
  // ignore: must_call_super
  void onInit() {}
}
