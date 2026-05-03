/// Device-level Mix & Match wardrobe slice (T6).
/// Try-on is not required here — one stable mix slice is sufficient.
///
/// Host / CI fallback:
/// `flutter test test/integration_binding/excel_t6_binding_slices_test.dart`
///
/// Device:
/// `flutter test integration_test/styling/wardrobe_mix_tryon_flow_test.dart -d <androidId>`

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:integration_test/integration_test.dart';

import 'package:frontend/features/mix_match/presentation/controllers/mix_match_controller.dart';
import 'package:frontend/features/mix_match/presentation/pages/mix_match_page.dart';

import '../../test/features/mix_match/support/mix_match_widget_test_doubles.dart';
import '../../test/features/wardrobe/support/wardrobe_widget_test_doubles.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    final base = Directory.systemTemp.createTempSync('mixera_it_mix_');
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

  tearDown(Get.reset);

  testWidgets('MixMatchPage renders header and start-mixing prompt', (tester) async {
    Get.put<MixMatchController>(
      MixMatchController(
        mixDatasource: MixMatchWidgetTestDatasource(),
        wardrobeDatasource: MixMatchSpotlightWardrobeDatasource(),
      ),
    );
    await tester.pumpWidget(const GetMaterialApp(home: MixMatchPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Mix & Match'), findsOneWidget);
    expect(find.text('Start mixing'), findsOneWidget);
  });
}
