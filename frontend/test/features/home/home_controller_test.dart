import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/features/home/data/models/dashboard_model.dart';
import 'package:frontend/features/home/domain/repositories/home_repository.dart';
import 'package:frontend/features/home/domain/usecases/get_dashboard_usecase.dart';
import 'package:frontend/features/home/presentation/controllers/home_controller.dart';

void main() {
  group('HomeController', () {
    late _FakeHomeRepository repo;
    late HomeController controller;

    DashboardModel sampleDashboard() {
      return DashboardModel.fromJson({
        'greeting': 'Hello',
        'greeting_subtitle': 'There',
        'featured_banner': {
          'id': 'b1',
          'title': 'Banner',
          'subtitle': 'Sub',
          'image_url': 'https://x/b.png',
          'cta_label': 'Go',
          'cta_route': null,
        },
        'quick_actions': <Map<String, dynamic>>[],
        'wardrobe_items': <Map<String, dynamic>>[],
        'sale_items': <Map<String, dynamic>>[],
        'recommended_items': <Map<String, dynamic>>[],
      });
    }

    setUp(() {
      repo = _FakeHomeRepository();
      controller = HomeController(GetDashboardUseCase(repo));
    });

    test('loadDashboard sets success and dashboard when use case succeeds', () async {
      repo.nextDashboard = sampleDashboard();

      await controller.loadDashboard();

      expect(controller.status, HomeStatus.success);
      expect(controller.hasData, isTrue);
      expect(controller.dashboard?.greeting, 'Hello');
      expect(controller.hasError, isFalse);
      expect(controller.errorMessage, isNull);
    });

    test('loadDashboard sets error when repository throws', () async {
      repo.error = Exception('offline');

      await controller.loadDashboard();

      expect(controller.status, HomeStatus.error);
      expect(controller.hasError, isTrue);
      expect(controller.dashboard, isNull);
      expect(controller.errorMessage, contains('offline'));
    });

    test('loadDashboard no-ops while already loading', () async {
      repo.delay = const Duration(milliseconds: 50);
      repo.nextDashboard = sampleDashboard();

      final first = controller.loadDashboard();
      expect(controller.isLoading, isTrue);
      await controller.loadDashboard();
      await first;

      expect(repo.callCount, 1);
    });
  });
}

class _FakeHomeRepository implements HomeRepository {
  DashboardModel? nextDashboard;
  Object? error;
  Duration delay = Duration.zero;
  int callCount = 0;

  @override
  Future<DashboardModel> getDashboard() async {
    callCount++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    if (error != null) {
      throw error!;
    }
    return nextDashboard!;
  }
}
