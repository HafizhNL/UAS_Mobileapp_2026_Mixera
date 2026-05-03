/// Pure MIXÉRA password rules for registration UI (no GetX / no network).
class RegisterPasswordRules {
  RegisterPasswordRules._();

  static final RegExp _number = RegExp(r'\d');
  static final RegExp _symbol = RegExp(r'[!@#\$%^&*(),.?":{}|<>]');
  static final RegExp _lower = RegExp(r'[a-z]');
  static final RegExp _upper = RegExp(r'[A-Z]');

  static bool hasMinLength(String password, {int min = 8}) =>
      password.length >= min;

  static bool hasNumber(String password) => password.contains(_number);

  static bool hasSymbol(String password) => password.contains(_symbol);

  static bool hasMixedCase(String password) =>
      password.contains(_lower) && password.contains(_upper);
}
