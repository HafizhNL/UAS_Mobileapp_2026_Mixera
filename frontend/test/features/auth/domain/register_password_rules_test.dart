import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/domain/register_password_rules.dart';

void main() {
  group('RegisterPasswordRules', () {
    test('checks minimum password length', () {
      expect(RegisterPasswordRules.hasMinLength('1234567'), isFalse);
      expect(RegisterPasswordRules.hasMinLength('12345678'), isTrue);
    });

    test('detects numeric characters', () {
      expect(RegisterPasswordRules.hasNumber('Password'), isFalse);
      expect(RegisterPasswordRules.hasNumber('Password1'), isTrue);
    });

    test('detects supported symbols', () {
      expect(RegisterPasswordRules.hasSymbol('Password1'), isFalse);
      expect(RegisterPasswordRules.hasSymbol('Password1!'), isTrue);
    });

    test('requires lower and upper case letters', () {
      expect(RegisterPasswordRules.hasMixedCase('password1!'), isFalse);
      expect(RegisterPasswordRules.hasMixedCase('PASSWORD1!'), isFalse);
      expect(RegisterPasswordRules.hasMixedCase('Password1!'), isTrue);
    });
  });
}
