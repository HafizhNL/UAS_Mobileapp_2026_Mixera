import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:frontend/features/wallet/presentation/utils/thousand_separator_input_formatter.dart';

void main() {
  const formatter = ThousandSeparatorInputFormatter();

  test('formats 600000 to 600.000 with caret at end', () {
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: '600000',
        selection: TextSelection.collapsed(offset: 6),
      ),
    );
    expect(result.text, '600.000');
    expect(result.selection.extentOffset, 7);
  });

  test('empty digit run clears text', () {
    final result = formatter.formatEditUpdate(
      const TextEditingValue(
        text: '1',
        selection: TextSelection.collapsed(offset: 1),
      ),
      TextEditingValue.empty,
    );
    expect(result.text, '');
  });

  test('reformats when pasted value already contains dots', () {
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: '1.000.000',
        selection: TextSelection.collapsed(offset: 9),
      ),
    );
    expect(result.text, '1.000.000');
  });

  test('single digit unchanged', () {
    final result = formatter.formatEditUpdate(
      TextEditingValue.empty,
      const TextEditingValue(
        text: '5',
        selection: TextSelection.collapsed(offset: 1),
      ),
    );
    expect(result.text, '5');
  });
}
