/// Device-level card tokenize slice (T6).
///
/// Host / CI fallback:
/// `flutter test test/integration_binding/excel_t6_binding_slices_test.dart`
///
/// Device:
/// `flutter test integration_test/commerce/card_payment_conversion_test.dart -d <androidId>`

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/features/checkout/presentation/pages/card_tokenize_page.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final base = Directory.systemTemp.createTempSync('mixera_it_card_');
    addTearDown(() {
      if (base.existsSync()) base.deleteSync(recursive: true);
    });
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      switch (call.method) {
        case 'getApplicationSupportDirectory':
        case 'getTemporaryDirectory':
        case 'getApplicationDocumentsDirectory':
          return base.path;
        default:
          return null;
      }
    });
  });

  testWidgets('CardTokenizePage formats 4242… card number with spaces', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CardTokenizePage(
          args: CardTokenizeArgs(clientKey: 'SB-Mid-client', total: 50000),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.first, '4242424242424242');
    await tester.pump();
    final field = tester.widget<TextFormField>(fields.first);
    expect(field.controller?.text, '4242 4242 4242 4242');
  });

  testWidgets('CardTokenizePage renders form fields', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CardTokenizePage(
          args: CardTokenizeArgs(clientKey: 'SB-Mid-client', total: 75000),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsWidgets);
  });
}
