import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/auth/presentation/widgets/remember_me_row.dart';

void main() {
  testWidgets('RememberMeRow shows label and a checked checkbox', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RememberMeRow(),
        ),
      ),
    );

    expect(find.text('Remember Me'), findsOneWidget);
    final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));
    expect(checkbox.value, isTrue);
  });
}
