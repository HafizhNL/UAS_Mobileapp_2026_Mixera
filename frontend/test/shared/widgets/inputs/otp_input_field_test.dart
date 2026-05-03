import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/inputs/otp_input_field.dart';

void main() {
  testWidgets('renders four one-character OTP fields', (tester) async {
    final controllers = List.generate(4, (_) => TextEditingController());
    addTearDown(() {
      for (final controller in controllers) {
        controller.dispose();
      }
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OtpInputField(controllers: controllers),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(4));

    await tester.enterText(find.byType(TextFormField).first, '7');

    expect(controllers.first.text, '7');
  });
}
